# TileDB SOMA ML
#tiledb #singlecell #soma

Challenges with SC:

size of datasets, increasingly too large for RAM
working with subsets/chunks of data important
need to work with package used to analyze data determines published format
lack of interoperability b/w formats hinders interoperability

## TileDB Core + TileDB

TileDB core built around multi-dim arrays.
Flexible for formats like k-v data, dataframes, ND arrays
Columnar with flexibility over attribute dtypes and sizes
Columnar: efficient compression and column-wise access
Data is broken up to small tiles on disk, allowing for loading chunks of dataset.
Works on a variety of backends
C++ lib provides efficiency, many language bindings available for accessibility.

Cloud allows for multiomic data storage and cataloging.
Groups and arrays!
Permissions system
Cloud compute in notebooks and serverless task graphs.

## TileDB-SOMA

TileDB and CZI collaboration
SOMAExperiment format is close to AnnData.
Allows interoperability with AnnData, Seurat, etc.
SOMA is multi-modal container (multiple measurements in `ms`)
obs is global, rest is per measurement.
X in each ms is a collection of matrices (`.X` + `.layers` in AnnData).

Language-independent format. Interoperable with R and Python.
Can read from S3 directly.
Can read data in chunks (`blockwise` w/ cardinality)
Can subset and filter data based on obs attributes.

ExperimentAxisQuery allows filtering on obs attrs via a custom QL that is similar to Pandas.

CZI census comprises 90+ million cells across 1486 datasets.
907 cell types.
Weekly releases and LTS releases every 6 months.
Schema ensures metadata standardization.
cellxgene_census and Discover APIs allow access.

## TileDB-SOMA-ML

Alpha releasing for training Pytorch models on SOMA data.
Pytorch loaders for SOMA.
Started based on CZI work, refactored and updated to make many improvements.
Multi-GPU support, shuffling improvements.

Shuffling is nuanced.
Compute obs IDs respoinsive to queries
Shuffle chunks of 64 cells by default.
Assign chunks to # GPU processes * # dataloader workers
Sequentially iterating introduces batch effects
shuffling removes the training loss since data is more random

## Pytorch Model Training Demo

1. open Experiment
2. axis_query on experiment on tissue and is_primary
3. get obs['cell_type'] concat to pandas
4. LabelEncoder().fit(obs_df['cell_type'].unique())
5. soma_ml.ExperimentAxisQueryIterDataPipe on X['raw'] and 'cell_type' with batch_size=128 and shuffling
6. we get an experiment_dataset from this
7. experiment_dataset.random_split(weights={train, test})
8. soma_ml.experiment_dataloader(train_dataset)
9. class LogisticRegression(torch.nn.Module) example model
10. def train_epoch for single epoch over data, iterating over each batch in train_dataloader. get predicitions and convert to probabilities. compute loss and ...
11. use torchdevice('cuda') if abailable else torch.device('cpu')
train for 20 epochs, accuracy increases!

then able to use the model to predict cell types.
(was too slow to take notes on this)

## TileDB Vector Search

Vector search allows for similarity searches of different types of objects.

Objects -> embedding model -> vector embeddings
embedding model is distance in vector space ~ object similarity

Then vector embeddings -> Vector index
create an index for efficient NN search
then can query for object similarity by retrieving NN embeddings

Why TileDB vector search?
Indexing:
can handle large-scale datasets at billion scale.
Distributed exeution via GPU workers for embedding generation

Vector search assets:
Object-store-based (S3). Cost effective for TB scale datasets.

Similarity Queries:
serverless. low maintanence cost, no active servers required (pay for what you use)
distributed: for large datasets or batch queries

Cell similarity search:
Cell -> Vector (via embedding model)
scVI and GeneFormer and scGPT are open source models
cell embeddings based on raw gene expression of cell
no need for normalization, fine-tuning, or custom pre-processing

Cell similatiy index once you have the vector embeddings!
Embed and index large single-cell reference datasets.
CellXGene census similarity index
made public!
have several open-source embedding models!

Can do sample reference mapping (automatic cell annotation based on retrieved similar cells (e.g. cell type))
can do Interactive analysis for cells of interest! Finding similar cells for disesases, tissues etc. signatures
Then compute attribute correlations

## Cell Similarity Reference Mapping Demo

use TileDB-Vector-Search on 74M human reference cells.
use scVI embeddings.

setup: import tiledb.vector_search.object_api object_index

Indexing:
Task graph generates embeddings (takes a few hours with many workers)
from vectors we create the index in 30 mins using distr compute.

Now we use the index for cell sim serach:

1. index = object_index.ObjectIndex(index_uri, config, m,emory budget, etc.)
2. use pbmc3k dataset AnnData
3. distances, neighbor_ids, neighbor_obs = index.query(
 {anndata: adata}, k=10, nprobe=1, return_objects=False
) 
4. get pandas df of new obs to check metadata on cells
5. majority vote for cell type
6. umap and plot to check
7. can denoise by doing popular vote by leiden cluster annotation

interactive analysis:
query based on ...??
load NN k=100
plot cell type of fetched cells
refine sim query based on new subset
