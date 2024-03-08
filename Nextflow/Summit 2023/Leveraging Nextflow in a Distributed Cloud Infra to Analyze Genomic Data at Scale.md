Pfizer Data Engineer Mayur Khanna

Key problems:
Scale of genetic data available is growing exponentially
Reproducibility is tough. Algorithms inconsistent across platforms.

Genomics Informatics Platform(?) infra enables reproducible workflows through distributed cloud computing
visualization tools, etc.

containerized plpelines ensure wsame deps
standardized workflow defs from nextflow
gip infra provides storage and compute for dist processing
use aws batch executor
vertical and horizontal scaling

GWASdb internal database
aws redshift columnar database
data sources: GWAS catalog ingested and internal studies

limitations of GWAS catalog: unable to perform cross study analysis
GWASdb allows this. UI provides visualization. Performant hundreds of studies in a second.

harmonization:
Standardize GWAS input data formats
challenge: requires manual mapping of column names to set of known types
flip alleles
update rsIDs
neglog ip1s
etc.
Use picard software from broad to convert coordinates from hg19 ref to hg38 build

opportunity to use lustre network drives to avoid staging large files
allievaites need for copies of data (duplication) and can have single copy

VCF files -> parquet.
Columnar databases have expensive insert operations, so they have to update over long periods of time.

nextflow drives ingestion of gwas data into db.


