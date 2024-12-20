 #docker #image #container

## Terminology

**Images** - _The blueprints of our application which form the basis of containers.

**Containers** - _Created from Docker images and run the actual application.

**Docker Daemon** - _The background service running on the host that manages building, running and distributing Docker containers. The daemon is the process that runs in the operating system to which clients talk to._

**Docker Client** - _The command line tool that allows the user to interact with the daemon. More generally, there can be other forms of clients too - such as Kitematic which provide a GUI to the users._

**Docker Hub** - _A registry of Docker images. You can think of the registry as a directory of all available Docker images. If required, one can host their own Docker registries and can use them for pulling images._

## Start docker daemon

Necessary before running any docker commands
`sudo systemctl start docker`

## Run `docker` CLI without `sudo`
[Article](https://www.baeldung.com/linux/docker-run-without-sudo)

"The Docker daemon binds to a Unix socket, and the _root_ user owns this Unix socket. Other users need to prefix their _docker_ commands with _sudo_ to access the Docker daemon.

By adding our Linux username to the Unix group _docker_, we can bypass this. When the Docker daemon starts, it creates a Unix socket accessible by the members of the _docker_ group.

Running Docker commands with the _sudo_ command is a sound security restriction. **However, users added to the Unix group _docker_ can run Docker commands as _root_ users while maintaining their usernames**."

```sh
# Create Unix group "docker"
sudo groupadd docker
# Add user jgatter to docker group
sudo usermod -aG docker jgatter
# Log back in
su - jgatter
```
`
## Images: pulling, tagging/building, and pushing

List images on local system
`docker images`

Inspect an image, e.g. to determine architecture it was built for:
`docker image inspect <image id> | grep Architecture` 

Build from a Dockerfile in the present working directory and tag the image:
`docker build -t repository/image:version .`
Can also do as separate steps using `docker build` and `docker tag`

Build from a Dockerfile specified by its path and tag the image:
`docker build -f path/to/Dockerfile -t repository/image:version .`

Symptom: `exec /bin/sh: exec format error`
Build for a specific OS and architecture like Linux amd64 aka x86-64:
`docker buildx build --platform linux/amd64 -t repository/image:version .`
Note: The server must be multi-platform capable. Ex: Install Rosetta on Mac M1, M2, and other systems with Apple Silicon chips.
Conversely for Linux amd64 systems, we can build a arm64 image using QEMU emulation:
```sh
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

docker buildx create --name mybuilder --use
docker buildx inspect --bootstrap
```
Bootstrapping performs additional setup, such as creating a **BuildKit** container, which is essential for running builds in isolation and enabling QEMU emulation for cross-platform builds.

Adjust Dockerfile to specify platform to guarantee the right base image is selected
```Dockerfile
FROM --platform=linux/arm64 python:3.12-slim
```
Build
```sh
docker buildx build --platform linux/arm64 -t <image:tag> .
```

Tag a built image with another tag:
`docker tag <existing image tag> <new image tag>`

Remove images
`docker rmi <image ID>`

Remove a tag from an image that has multiple tags
`docker rmi <image name>:<tag>`

Push a tagged image to a repository
`docker push repository/image:version`

Push all tags of an image name to a repository:
`docker push --all-tags repository/image`

Pull a hosted image from the docker registry to the local system
`docker pull repository/image:version`

### AWS Elastic Container Registry

If the images are/will be hosted on AWS ECR, there are some additional steps to take:

1) Logging in: 
```bash
aws ecr get-login-password --profile <AWSPROFILE> \
	| docker login \
		--username AWS \
		--password-stdin \
		$ECR_REGISTRY
```
2) When pushing, create the ECR repository if it does not yet exist! Otherwise you will be stuck "retrying".

## Containers: running and interacting

### Running

When attached to running container, `^C` will terminate while (holding both at the same time) `^P^Q` detaches. Reattach using `docker attach`.

Simplest example: Launch a container with the specified tagged image
`docker run --rm -it repository/image:version`

#### Flags
`man docker run`

`docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`
Note `COMMAND`, e.g. `/bin/bash`
`docker run --rm -it repository/image:version /bin/sh`

##### Main flags:
`-t` : Allocate a pseudo-tty (terminal)
`-i` : Interactive; keep `STDIN` open even if not attached
`--rm` : Automatically clean up the container and remove the file system when the container exits

##### Useful flags:
* `-p <local-host-IP>:<local-host-port>:<docker-container-port>` : Map the container port to a local host's IP and port. Can also do just ports, e.g. `-p 5432:5432`
* `--entrypoint <command>` : Override the `ENTRYPOINT` command of the Dockerfile, e.g. `/bin/sh` will start the container's shell.
* `--mount <???:???:???>` : TODO
* `--volume` : TODO
* `-d` : Start in detached instead of attached mode. Containers exit when root process used to run container exits. If used with `--rm`, remove the container when it or the daemon exits
* `-e` : Set environment variables that are available for the process that will be launched inside of the container. See also `--env-file` in manual.
* `--name` : Give the container a name for easy identification/referencing.
* `--platform`: Specify the OS and CPU architecture to run. With Rosetta installed on Apple Silicon Macbooks, specify `linux/amd64` to run images that were built for Linux and x86 architecture. 

Alternatively, you can `create` a container without running it. It prepares the container for execution by setting up any configurations specified in the command such as volumes, environment variables, and networking options. However, the main process isn't started until `docker start` is invoked. Example:
```sh
docker create --name my-container nginx
```
`docker run` is just a combination of `create` and `start`.
### Interacting
The operator can identify the container by its long UUID, short UUID, or container name.

List containers
`docker ps`
- `-a` : All
- `-f` : Filter based on conditions provided, e.g. `status=exited`
- `-q` : Returns IDs in numeric value

Attach to container
`docker attach <container ID>`

Execute a command within a running container
`docker exec <container ID>`
Can use `-it` flags like the `run` command

Stop the container (does not delete unless was run with `--rm`)
`docker stop <container ID>`

Start a stopped container
`docker start <container ID>`

Copy files from a container
`docker cp <container id>:/path/to/file/in/container /path/to/local/dir`
Alternatively:
```sh
# Create a temporary container from the image:
docker create --name temp-container your-image-name
# Copy the file from the newly created container:
docker cp temp-container:/path/to/file /local/path
# docker rm temp-container
docker rm temp-container
```
## Cleaning up

Freeing up resources is important from time to time! Check how much resources Docker is using up:
```sh
docker system df
# or more granularly
docker system df -v
```

Most docker subcommands have a `prune` command, e.g.
```sh
# Remove/delete container(s)
docker rm <container IDs>
# Remove all stopped containers
docker container prune
# OR:
docker rm $(docker ps -a -q -f status=exited)
```

Before deleting images, it's a good idea to prune containers that have stopped / that are dangling. Then you can prune them:
```sh
# Remove image(s)
docker rmi <image IDs>

# An image with multiple repository references or tags 
# may need to be forcefully removed
docker rmi -f <image IDs>

# Removes dangling images
docker image prune

# Alternatively
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
```

Delete everything! Even images you may want to keep!
`docker system prune --volumes --all`

# Not cache layers
```sh
docker system prune
```

