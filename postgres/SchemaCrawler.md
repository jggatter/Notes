# SchemaCrawler

## Running

```bash
docker run --rm -it -v $(pwd):/output schemacrawler/schemacrawler /bin/bash
```

## Example

`export PASSWORD=...` ???

```bash
schemacrawler --server postgresql --host <host> --user <user> --database <database> --info-level standard --command schema --schemas "public|hdb_catalog" --grep-tables "public.file.*" --output-format pdf --output-file /output/holo_file2.pdf --children 1
```
