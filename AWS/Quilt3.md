## Delete packages
[Source](https://docs.quiltdata.com/more/faq#how-do-i-delete-a-data-package-and-all-of-the-objects-in-the-data-package)

They make it difficult deliberately. They favor immutability in data, but I need to delete workflow test data.
```python
import quilt3 as q3; import boto3; s3 = boto3.client('s3')

pname = "author/packagename"; reg = "s3://company-quilt-bucket"; p = q3.Package.browse(pname, registry=reg)

for (k, e) in p.walk(): pk = e.physical_key; s3.delete_object(Bucket=pk.bucket, Key=pk.path, VersionId=pk.version_id)

q3.delete_package(pname, registry=reg, top_hash=p.top_hash)
```

