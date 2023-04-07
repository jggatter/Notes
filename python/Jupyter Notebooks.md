#jupyter #notebook #python #datascience

## Install

`pip install notebook`

## Run

Change to desired working directory.

`jupyter notebook`

## Kernels

See [[venv#For use with Jupyter notebooks]]

## Extensions
[Source](https://stackoverflow.com/a/56609172)

**TODO: Not working**

Install nbextensions, specific extensions, and configurator UI: ````

```
# Install
pip install jupyter_contrib_nbextensions

# Copy CSS/JS files
jupyter contrib nbextension install --user

# Enable Table of Contents
jupyter nbextension enable toc2/main

# Install configurator UI and enable
pip install jupyter_nbextensions_configurator
jupyter nbextensions_configurator enable --user
```

In browser, go to http://localhost:8888/nbextensions  
Uncheck the checkbox at the top "disable configuration for nbextensions without explicit compatability..." and enable the plugin.
