# Amazon Athena
#aws #athena #serverless #sql #querying #s3 #json #parquet #database #schema #tables
## Athena 101

Severless interactive querying service.
Ad-hoc queries on S3 data
Pay only for amount of data consumed while making the query and for storage costs
No base monthly cost, no per minute/hour
Athena uses schema-on-read: table-like translation
Handles structured, semi-structured, and unstructured data
Uses a process called Schema-on-read: Table-like translation
Original data on S3 is never changed and remains on S3
Schema translates data -> Relational-like structure when read
Athena helps avoid doing ETLs yourself. Just have to define schema, then data translates to your schema and the output can be sent to other AWS services

Source data on S3 (read only): Can be XML, JSON, CSV/TSV, AVRO, PARQUET, ORC, Apache, CloudTrail, VPC Flowlogs, other log files

Schema contains tables which are defined in advance

The source data is streamed through the schema when read. It allows SQL-like queries on data without transforming source data. Hence, "Schema-on-read"

Athena has no infrastructure to set up; No databases, no data manipulation, or data loading. Athena is great when loading/transformation isn't desired, just querying occasional / ad-hoc. 
Serverless querying is cost conscious.
Great for querying AWS logs
Can also query data from Glue Data Catalog & Web Server Logs
With Athena Federated Query, you can query non-S3 data sources. It uses data source connectors (Pieces of code that can translate between non-S3 datasources and Athena) on AWS Lambda to perform federated queries.

##  Creating Athena Database (Getting started)

Under Amazon Athena, visit Query Editor -> Settings -> Manage.
Enter in the S3 bucket to use as well as the account number of the expected owner.

Go to Editor and within the Query window, create a database.
```sql
CREATE DATABASE A4L;
```
Run it. Then, hit the '+' at the top right of the query window to add definition for a table:
```sql
CREATE EXTERNAL TABLE planet (
  id BIGINT,
  type STRING,
  tags MAP<STRING,STRING>,
  lat DECIMAL(9,7),
  lon DECIMAL(10,7),
  nds ARRAY<STRUCT<ref: BIGINT>>,
  members ARRAY<STRUCT<type: STRING, ref: BIGINT, role: STRING>>,
  changeset BIGINT,
  timestamp TIMESTAMP,
  uid BIGINT,
  user STRING,
  version BIGINT
)
STORED AS ORCFILE
LOCATION 's3://osm-pps/planet/';
```
Athena doesn't store any data. We're only specifying the data source and definition.
Run it. A table definition will appear in the left panel for Tables and Views. No infra has been configured.

Add a new query ('+' button) to query against this table.
```sql
Select * from planet LIMIT 100;
```

Add a new query to clean up the space:
```sql
drop table planet;

drop database a4l;
```
The underlying data is not deleted, only the database and table definitions.