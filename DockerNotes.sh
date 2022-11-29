#docker pull <repository name>/<image name>:<version> # Pull a hosted image to the local system(?).
#docker build -t <repository name>/<image name>:<version> . # The period is very important. Build an image from the file called Dockerfile in this directory, and tag it with the name.
#docker images # List all built images (on the system?)
#docker run
#	-d # Will detatch from the running image.
#	--name # Give the container a custom name. Will give a random fun name viewable in docker ps
#	--rm # Remove the image after it has run
#	-p <local-host-IP e.g. 127.0.0.1>:<local-host port number e.g. 8000>:<docker container port number e.g. 8000>
#		docker run -d -p 127.0.0.1:8000:8000 -it us.gcr.io/broad-dsp-gcr-public/terra-jupyter-bioconductor:0.0.10
#	--mount <???:???:???> # Mount a volume (file system?). I forget the syntax, look it up.
#	--entrypoint # Override the entrypoint command of the Dockerfile. "/bin/bash" will put you in bash.
#	-it <repository name>/<image name>:<version> # Run the tagged image.
# NOTE: When running, can quit at any time with control-c, or can detatch by hitting control-p then control-q
#docker ps # List all containers (on the system?)
#	-a #Shows list of containers that we ran
#	-q #Returns IDs in numeric value.
#	-f #Filters based on provided conditions.
#docker attach <container ID> # Attach to a container you are not attached to
#docker exec -it <repository name>/<image name>:<version> <unix command> # Execute a command in a running docker container you are detached from.
#docker stop <container ID>
#docker start <container ID>
#docker rm <container ID> <another container ID and so on>
#	Cheat code: docker rm $(docker ps -a -q -f status=exited) removed all stopped containers.
#docker rmi <image ID> # Removes the image
#docker rmi <image name> # Removes the image by name. If one image has multiple tags, I think it will only delete the specified tagged image. 
# docker create
# docker cp
# docker rm -v

# Below is based on the tutorial I originally followed.

#TERMINOLOGY
#Images - The blueprints of our application which form the basis of containers. In the demo above, we used the docker pull command to download the busybox image.
#Containers - Created from Docker images and run the actual application. We create a container using docker run which we did using the busybox image that we downloaded. A list of running containers can be seen using the docker ps command.
#Docker Daemon - The background service running on the host that manages building, running and distributing Docker containers. The daemon is the process that runs in the operating system to which clients talk to.
#Docker Client - The command line tool that allows the user to interact with the daemon. More generally, there can be other forms of clients too - such as Kitematic which provide a GUI to the users.
#Docker Hub - A registry of Docker images. You can think of the registry as a directory of all available Docker images. If required, one can host their own Docker registries and can use them for pulling images.

# BASICS
#docker pull [container] #Fetches image from docker registry.
#docker images #Lists images on system
#docker run [image]
#	docker run hello-world
#	docker run busybox echo "Hello!"
#   docker run -it busybox sh #-it attaches us to an interactive tty in the container.
#    Now we can run as many commands in the container as we want. Take some time to run your favorite commands. exit to exit.
#	docker run --help to see supported flags
#docker ps #Lists containers that are currently running
#	-a #Shows list of containers that we ran
#	-q #Returns IDs in numeric value.
#	-f #Filters based on provided conditions.
#docker rm [container ID] [container ID] ... # Remove as many containers as you want using IDs from docker images
#docker rm $(docker ps -a -q -f status=exited) # Removes all containers that have stopped
#docker container prune #does the same thing.
#docker run --rm [image] #Removes image after it has finished running.

# STATIC SITES
#docker run -d -P --name static-site prakhar1989/static-site e61d12292d69556eabe2a44c16cbd54486b2527e2ce4f95438e504afb7b02810
# In the above command, -d will detach our terminal, -P will publish all exposed ports to random ports and finally 
# --name corresponds to a name we want to give. Now we can see the ports by running the docker port [CONTAINER] command
# To stop a detached container, run docker stop by giving the container ID. In this case, we can use the name static-site we used to start the container.

# DOCKER IMAGES: the basis of containers
#docker images
# TAG refers to specific snapshot, IMAGE ID is the unique identifier
# images can be committed with changes and have multiple versions. If you don't provide a specific version number, the client defaults to latest
# You can also search for images directly from the command line using docker search
# Base images are images that have no parent image, usually images with an OS like ubuntu, busybox or debian.
# Child images are images that build on base images and add additional functionality.
# Official images are images that are officially maintained and supported by the folks at Docker. These are typically one word long. In the list of images above, the python, ubuntu, busybox and hello-world images are official images.
# User images are images created and shared by users like you and me. They build on base images and add additional functionality. Typically, these are formatted as user/image-name.

#CREATING OWN DOCKER IMAGE
# A Dockerfile is a simple text-file that contains a list of commands that the Docker client calls while creating an image. 
# It's a simple way to automate the image creation process. The best part is that the commands you write in a Dockerfile are almost identical to their equivalent Linux commands.
#git clone https://github.com/prakhar1989/docker-curriculum.git
#cd docker-curriculum/flask-app
# create a new blank file in our favorite text-editor and save it in the same folder as the flask app by the name of 'Dockerfile'
# In this file:
# We start with specifying our base image. Use the FROM keyword to do that -
#FROM python:3-onbuild
# The next step usually is to write the commands of copying the files and installing the dependencies. Luckily for us, the onbuild version of the image takes care of that. 
# The next thing we need to specify is the port number that needs to be exposed. Since our flask app is running on port 5000, that's what we'll indicate.
#EXPOSE 5000
# The last step is to write the command for running the application, which is simply - python ./app.py. We use the CMD command to do that -
#CMD ["python", "./app.py"]
# back to terminal (period below is important): 
#docker build -t [username]/catnip .
# docker tag [IMAGE ID] [username]/catnip:[version name]
# docker login # VERY IMPORTANT
# docker push [username]/catnip:version

# MULTI-CONTAINER ENVIRONMENTS
# Let's first pull the image
#docker pull docker.elastic.co/elasticsearch/elasticsearch:6.3.2
# then run it in development mode by specifying ports and setting an environment variable that configures Elasticsearch cluster to run as a single-node.
#docker run -d --name es -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.3.2 277451c15ec183dd939e80298ea4bcf55050328a39b04124b387d668e3ed3943
