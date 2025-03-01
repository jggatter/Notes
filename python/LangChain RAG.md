# LangChain: Building a Retrieval Augmented Generation (RAG) App
#python #langchain #llm #rag #ml

Retrieval Augmented Generation (RAG) is a powerful technique
that enhances language models by combining them with external knowledge bases.

RAG addresses a key limitation of models:
models rely on fixed training sets, leading to outdated/incomplete info.
When queried, RAG systems first search a knowledge base for relevant info.
The system incorporates the retrieved info into the model's prompt,
using the provided context to generate a response to the query.

By bridging the gap between vast language models and dynamic, targeted info retrieval, RAG builds more capable and reliable AI systems.

## Key concepts of RAG

1) Retrieval system (Indexing): Retrieves relevant info from knowledge base.
2) Adding external knowledge (Retrieval + Generation): Pass retrieved info to a model.

Flow:
Question -> Retrieval System -> Relevant documents -> Model -> Answer

## Retrieval systems

Models have internal knowledge that is often fixed, or infrequently updated due to the high cost of training.
This limits their question-answering ability regarding current events or domain-specific knowledge.
There are various knowledge injection techniques like fine-tuning or continued pre-training,
but these are costly and poorly suited for factual retrieval.

A retrieval system offers several advantages:
- Up-to-date info
- Domain-specific expertise
- Reduced hallucination
- Cost-effective knowledge integration

## Adding external knowledge via RAG (minimal example)

With a retrieval system in place, we need to pass knowledge to the model.
A RAG pipeline typically achieves this following these steps:
1. Receive an input query
2. Use retrieval system to search for relevant info based on query
3. Incorporate retrieved info into prompt sent to LLM
4. Generate response that leverages the retrieved context

Example of simple RAG workflow which passes info from retriever -> chat model:
```python
from langchain_openai import ChatOpenAI
from langchain_core.messages import SystemMessage, HumanMessage

# Define system prompt telling model how to use retrieved context
SYSTEM_PROMPT = """You're an assistant for question-answering tasks.
Use the following pieces of retrieved context to answer the qeustion.
If you don't know how to answer, just say you don't know.
Use three sentences maximum and keep the answer concise.
Context: {context}:"""

# Define a question
question = (
    "What are the main components of an LLM-powered autonomous agent system?"
)

# Retrieve relevant docs
# Note: Not defined in this example
docs = retriever.invoke(question)

# Combine docs into single string
docs_text = "".join(d.page_content for d in docs)

# Populate the system prompt with the retrieved context
system_prompt_fmt = SYSTEM_PROMPT.format(context=docs_text)

# Create a model
model = ChatOpenAI(model="gpt-4o", temperature=0)

# Generate a response
questions = model.invoke([
    SystemMessage(content=system_prompt_fmt),
    HumanMessage(content=question)
])
```

A `retriever` may be defined such as below:
```python
from langchain.vectorstores import FAISS
from langchain.embeddings import OpenAIEmbeddings
from langchain.retrievers import VectorStoreRetriever

# Initialize vector store retriever
embeddings = OpenAIEmbeddings()
vectorstore = FAISS.load_local("path_to_vector_store", embeddings)
retriever = VectorStoreRetriever(vectorstore=vectorstore)

# Retrieve relevant documents
docs = retriever.retrieve(question)
```
This backend would use FAISS as a vector store and OpenAI embeddings.

## RAG implementation walk-through

### Recapping concepts

#### Indexing

As stated earlier, the first component of RAG is indexing. Steps:
1. __Load__ our data via _document loaders_
2. __Split__ large documents into _chunks_ aka _splits_ via _text splitters_
3. __Store__ and index our splits for retrieval.

Since large chunks are harder to search over and might not fit in a model's finite context window,
splitting can be useful for both indexing and passing the docs to a model.

Storing is often done using a vector store and an embeddings model.

#### Retrieval and Generation

The second part of RAG.

1. __Retrieve__ relevant splits from storage via a retriever 
2. __Generate__ an answer from a LLM using a prompt which includes both question and retrieved data.

### Installation and Setup

Install dependencies:
```sh
pip install -U langchain-core \
    langchain-text-splitters \
    langchain-community \
    langgraph 
```

We'll use LangGraph as our orchestration framework to implement retrieval and generation steps.

LangSmith can be used for debugging chains/agents. Useful for large setups.
After signing up, you can configure the environment:
```sh
export LANGCHAIN_TRACING_V2="true"
export LANGCHAIN_API_KEY=...
```

### Components

We'll need a chat model, embeddings model, and a vector store:
```sh
pip install -U langchain-openai

export OPENAI_API_KEY=...
```

```python
from langchain_openai import ChatOpenAI, OpenAIEmbeddings
from langchain_core.vectorstores import InMemoryVectorStore

llm = ChatOpenAI(model='gpt-4o-mini')
embeddings = OpenAIEmbeddings(model='text-embedding-3-large')
vector_store = InMemoryVectorStore(embeddings)
```

### Preview

We'll build an app that answers questions about a website's contents.

Imports:
```python
import bs4
from langchain import hub
from langchain_community.document_loaders import WebBaseLoader
from langchain_core.documents import Document
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langgraph.graph import START, StateGraph
from typing_extensions import List, TypedDict
```

Loading documents using `BeautifulSoup` and `urllib`:
```python
# Load and chunk contents of the blog
loader = WebBaseLoader(
    web_paths=('https://lilianweng.github.io/posts/2023-06-23-agent/',),
    bs_kwargs={
        'parse_only': bs4.SoupStrainer(
            class_=('post-content', 'post-title', 'post-header')
        ),
    },
)
docs = loader.load()
```

Our loaded document is over 42k chars long, too long for context window of most models. Even those that can handle, it can be challenging to parse for right info. 

We split the `Document` into chunks for embedding and vector storage:
```python
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200,
)
splits = text_splitter.split_documents(docs)
```
We get 66 text chunks.


We embed the contents of each split and store them in the vector store:
```python
# Index chunks
_ = vector_store.add_documents(documents=splits)
```

We define a prompt. Here just pulling it from the LangChain prompt hub:
```python
# Define prompt for question-answering
prompt = hub.pull('rlm/rag-prompt')
```

The state of of our application controls what data is input to the app,
transferred between steps, and output by the app.

We can keep track of the input question, retrieved context, and output answer:
```python
# This could also be a Pydantic base model
class State(TypedDict):
    question: str
    context: List[Document]
    answer: str
```

We define an application step, or node, each for retrieval and generation:
```python
# Define application steps
def retrieve(state: State):
    retrieved_docs = vector_store.similarity_search(state['question'])
    return {'context': retrieved_docs}


def generate(state: State):
    docs_content = '\n\n'.join(doc.page_content for doc in state['context'])
    messages = prompt.invoke({
        'question': state['question'],
        'context': docs_content
    })
    response = llm.invoke(messages)
    return {'answer': response.content}
```
The retrieval step runs similarity search using the input question.
The generation step formats the context and original question into a prompt,
subsequently invoking the model to generate a response.

We compile the sequence of our app's steps app into a `graph` object.
```python
# Compile application
graph_builder = StateGraph(State).add_sequence([retrieve, generate])
graph_builder.add_edge(START, 'retrieve')
graph = graph_builder.compile()
```

We can visualize our DAG:
```python
from IPython.display import Image, display

display(Image(graph.get_graph().draw_mermaid_png()))
```

We can run it and get our response.
```python
# Test
response = graph.invoke({'question': 'What is task decomposition?'})
print(response['answer'])
```

We didn't have to use LangGraph. We could have simply done this:
```python
question = "..."

retrieved_docs = vector_store.similarity_search(question)
docs_content = '\n\n'.join(doc.page_content for doc in retrieved_docs)

prompt = prompt.invoke({'question': question, 'context': docs_content})
answer = llm.invoke(prompt)
```
LangChain is a more scaleable option and integrates well with LangSmith.

With LangGraph, we could alternatively stream steps as they happen:
```python
for step in graph.stream(
    {"question": "What is Task Decomposition?"}, stream_mode="updates"
):
    print(f"{step}\n\n----------------\n")
```
Methods `ainvoke()` or `astream()` could be used in async contexts.

