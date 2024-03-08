#nextflow #duckdb #databases #workflows

Powering data engineering, exploring DuckDB, and beyond

## Data Engineering vs. Science
Data engineers do ETLs and work with databases, focus on data quality and build pipelines that transform this data into formats that are more useful for data scientists.
Data science involves statistics, etc.

## Bioinformatics vs Comp Bio:
bfx run tools, focus on files, data quality, building poipelines
Comp bio focus on statistics, ML, reports, algorithms

## Big data is dead 
Very few people make huge queries everyday
Most work is done on the most recent data
If data is needed for future, archived (glacier in AWS)

## DuckDB

OSS, in-process SQL OLAP database management system
"SQL-lite" for analytics
can run SQL on files directly
power of databases without the headache
Has speed with L1 cache optimized (stays around the CPU) and query execution engine.
Runs anywhere, Cloud, HPC, laptops.
## DuckDB Comparisons

In-process: SQlite and DuckDB
Client/Server: postgres etc.

Can run SQL queries directly on file paths (parquet) and dataframes.
Can import it in python and use it there
It's compatible with pyspark
DuckDB is faster for small workloads, Pyspark can scale more
Exon is an olap query enginer specifically for bio and life sciences
## DuckDB + Nextflow

Not a plugin, just command-line usage

Duck can be a parquet reader for Nextflow.
Use it in nextflow and run the flow.

This allows it to be used similarly to dbt for etls.

The nf-sqldb cplugin is designed to be a client, don't use it with this.

## Medallion architecture

Raw -> Filtered/Silver -> Gold business level
MultiQC gets you roughly to silver. It can give you HTML, JSON, and parquet outputs
DuckDB could be used to query these

MegaQC (https://megaqc.info/) aggregates MultiQC reports into a single report.
DuckDB could be used to query this aggregate data




