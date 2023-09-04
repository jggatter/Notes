#python #pip #venv

## Setup and general usage

Add alias to `.zshrc`:
`alias venv='python -m venv'`

Change directory to project in which you intend to use virtual env. Create the environment:
`venv <name of virtual environment, e.g venv-myproj>`

Source the project to activate it:
`source venv-myproj/bin/activate`

Install packages:
`pip install packages`  
or if requirements.txt,
	`pip install -r requirements.txt`

To deactivate, simply `deactivate`

## For use with Jupyter notebooks
#jupyter #notebook

We first have to create a kernel
`pip install jupyter`
`ipython kernel install --name "local-venv" --user`

Now we start the notebook:
`jupyter notebook`
and in the UI we select the kernel: 
"Kernel" -> "Change kernel" -> "local-venv"
and restart

Confirm  `!which python` within the notebook cell shows the path to the desired installation of python.

To uninstall:
`jupyter kernelspec uninstall local-venv`