# AWS Glue
#aws #glue #serverless #etl #athena #s3 #rds #emr #datapipeline
## Glue 101

Serverless ETL system. 

AWS DataPipeline is another service that does ETL but using servers (EMR)

Glue is used to move and transform data between source and a destination.

It crawls data sources and generated the AWS Glue Data catalog

Data source stores: S3, RDS, DBC-compatible DBs (e.g. RedShift), DynamoDB
Data source streams: Kinesis Data Stream and Apache Kafka
Data targets: S3, RDS, JDBC-compatible Databases

AWS Glue Data Catalog:
Catalog: collection of metadata combined with data management and search tools. Persistent metadata about metadata sources within a region.
One catalog per region per account to avoid data silos.
Athena, RedShift Spectrum, EMR, and AWS Lake Formation all use Data Catalog.
Data is discovered through configuring crawlers and pointing them at data sources.
The crawlers connect, determine schema, and create metadata in the data catalog.
So you can catalog metadata from multiple sources (e.g. S3 buckets) and allow a team upstream to view the data.
Glue Jobs are ETL operations that use scripts for transformations that you create. You don't have to manage compute. AWS maintains a Managed Warm Resource Pool from which your compute can be performed.
Jobs can be triggered manually or automatically (event-driven from EventBridge)

On the exam you will typically only see Glue or DataPipeline. Glue is best for serverless, ad hoc, or cost-effective situations. Glue will likely replace DataPipeline eventually.