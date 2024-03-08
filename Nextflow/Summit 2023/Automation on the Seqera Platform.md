#nextflow 

Three automation use cases
- UI (Scientist): I want to do analysis quickly and reproducibly without writing code
- API (Tool builder): i want to hook our existing tools into the Seqera platform
- CLI (Bioinformatician): I want to do analysis quickly and reproducibly and a UI is soul-destroying

Launching with the Seqera platform UI is the click of buttons and input into forms
API is a request to the Seqera Platform REST API
The CLI can be used to simplify interactions with the API

We can get logging, monitoring, resource provisioning, and collaborative sharing functionalities.

We can also have infrastructure as code.
`seqera compute-envs export --name=aws_ireland_fusion2_nvme_fargate`
Stored, version controlled workflows + their environments

`seqerakit` is a Python wrapper toolkit for the Seqera CLI.
Configuration can be done with YAML for CLI or Python API.

TODO: what is ngrok??
```bash
ngrok --http 8000  # Something that starts up a web server

# Source env vars
source env_vars.sh

# all_the_things.yaml contains the configurations that use these env vars by reference ($GITHUB_USERNAME)

# Picks up the conf and creates what it needs to (including AWS compute env for fargate) and runs the nextflow run
seqerakit all_the_things.yml

# You can have it run fetchngs and scrna-seq
```

`nf-aggregate` TODO: LOOK THIS UP




