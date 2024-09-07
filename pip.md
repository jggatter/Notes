#pip #python 

## Install and upgrade pip

Don't use root installation of python? Doesn't have pip?

ensurepip?
Ubuntu/Debian install python3-pip

`pip install -U pip`
# Install packages

`pip install <package names>` on PyPI
`pip install --extra-index-url $PIP_EXTRA_INDEX_URL <package names>`
`pip install git+https://github.com/username/repository.git@branch-name
`
`pip install -U`  aka `--upgrade`
`pip install -e <path>`
`pip install --pre`
`pip install --no-cache-dir`

### Pip config

TODO
## Show packages

`pip show`
`pip show -f <package>`
`pip list | grep <pattern>`

pipdeptree