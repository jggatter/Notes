#python #troubleshooting #dependencyhell

## No file `Python.h`

On Fedora ran into this when trying to install h5py and pyarrow, etc. Need to install `python3-devel` files. Specifically for my separate 3.11 installation I needed to do:
`sudo dnf install python3.11-devel`

## Command `cmake` failed: No such file or directory

Encountered on fedora when trying to install `pyarrow`.
`cmake` needed to be installed.
`sudo dnf install cmake`

Then h5py failed saying `No CMAKE_CXX_COMPILER could be found`, so:
`sudo dnf install g++`

Then I spent hours trying to figure out why pyarrow wouldn't install. It was hard finding a working libarrow version. The problem was pyarrow does not yet support python 3.11 outside of nightlies.
`pip install --extra-index-url https://pypi.fury.io/arrow-nightlies/ --prefer-binary --pre pyarrow`

## 