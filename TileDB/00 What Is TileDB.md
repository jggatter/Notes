# What is TileDB?
#tiledb

TileDB is foundational software designed by scientists for scientific discovery.

Structures all data types, including data that doesn't easily fit
into relational databases.

Built on a powerful shape-shifting array database, TileDB handles
complexities of non-traditional, "unstructured", multimodal data.
Includes transcriptomic, proteomic, genomic variant, biomedical imaging, etc.

The TileDB core engine was developed during 2014-2017 at MIT and Intel Labs.
TileDB, Inc. was formed in 2017 to further develop and commericialize it.

The name "TileDB" consists of two parts:
1. Tile - The atomic unit of storage for TileDB's array format.
2. DB - Database, a system that stores, manages, and processes data.

## Discovery in life sciences relies on frontier data

Drug discovery is expensive and inefficient.
It can cost a few billion to bring a new drug to market,
taking 10 to 15 years.
90% of drug candidates do not get approved.
The bar is getting higher and higher, new drugs need to outperform existing.

Valuable and expensive frontier data emerges, such as:
- bulk and single-cell transcriptomics
- spatial transcriptomics
- proteomics
- population genomics
- bioimaging

These power research to improve discovery.
By combining these omics sets with existing literature and assays,
scientists can uncover novel relationships, identify biomarkers,
unravel complex disease mechanisms, and ultimately drive
precision medicine approaches in drug discovery and the clinic.

However this multimodal, predominately unstructured data,
i.e. data that cannot be natively modeled as structured relational tables,
is large-scale, multi-dimensional, and notoriously difficult to use.
It stretches limits of general-purpose data and compute management.

As a result, data needs to be managed and computed in ways
that are abstracted away from the scientists.
Scientists lean on research informatics teams in order to glean
biological insights.

Collaboration between these teams suffers and is backlogged
due to lack of robust tools that scale and perform for both of these groups.

Valuable data is often siloed and cataloged in ways that make it hard to reuse.

## The status quo cannot handle frontier data

### Databases

Such as Snowflake, AWS RedShift, Databricks, Google Big Query.
Have the power to model and analyze efficiently and securely.

But mainly only handle structured, tabular data.
Tabular data accounts for only a small fraction of scientific data in an org.
(I don't think I agree with this).
Force-fitting non-tabular data into a tabular database results in
poor performance experience and unecessary usage complexity.

### File managers

Such as SharePoint, Dropbox, Box, Google Drive, AWS S3, Google Cloud Storage.
Have the ability to store any type of data in the form of binary files.

However they don't provide any context semantics, or specialized metadata
about the underlying data modalities.
This makes it difficult to search and locate data relevant to a specific
scientific workflow.

Processing large flat binary files is usually extremely inefficient,
especially compared to rigorous database approaches.

### Data catalogs

Such as Collibra, Alation, and Atlan.
Add more meaningful info about data, exposing important relationships,
and enhancing findability.

However, lack the computational power of databases to analyze data.

### Scientific platforms

Such as DNA Nexus, Velsera, Illumina Connected Analytics, and Lifebit.
Speciaized for scientific domain, offering deep understanding and functionality
surrounding the data modalities used in the Life Sciences industry.

Not architected to be powerful database systems,
treating compute, performance, and scale as afterthoughts.

Also typically tailored for narrow set of data modalities,
treating all else as binary files.
This forces organizations to adopt multiple solutions for larger coverage
of their modalities.


## TileDB is a new data platform for discovery

Combines strong aspects of databases, sci. platforms, file systems, catalogs
to overcome their limitations.

Centralize and catalog data modalities,
from simple PDF, XLS, CSV, to frontier -omics data.

Collaborate securely to eliminate data siloes.
Data sharing is easy and safe with logging.
Ensures FAIR data practices and compliance with HIPAA and SOC 2 regulations.

Analysis can happen in flexibile ways.
Programmatic access for data wrangling.
Notebooks for data science.
Flexible dashboards for visualization.
Interoperability with popular analysis tools.
LLM integration and copilots.
Extensibility to add more tools.

Scale economically.
Control costs with highly performant, cloud-optimized, array storage format
and compute engine,
which utilize efficient compression and indexing techniques.
Cloud offers distributed compute with task graphs and parallel algorithms.
Complex workflows in a serverless dashion at lowest cost.

Structure the "unstructured".
Underyling arrays shape-shift to structure all data, regardless of modality.

Deploy generative AI and ML tooling like vector search to accelerate insights.


