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

Build from a Dockerfile in the present working directory and tag it
`docker build -t repository/image:version .`
Can also do as separate steps using `docker build` and `docker tag`

Tag a built image with another tag:
`docker tag <existing image tag> <new image tag>`

Remove images
`docker rmi <image ID>`

Remove a tag from an image that has multiple tags
`docker rmi <image name>:<tag>`

Push a tagged image to a repository
`docker push repository/image:version`

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

When attached to running container, \^C will terminate while (holding both at the same time) \^P\^Q detaches. Reattach using `docker attach`.

Simplest example: Launch a container with the specified tagged image
`docker run --rm -it repository/image:version`

#### Flags
`man docker run`

`docker run [OPTIONS] IMAGE [COMMAND] [ARG...]`
Note COMMAND, e.g. `/bin/bash`
`docker run --rm -it repository/image:version /bin/sh`

##### Main flags:
`-t` : Allocate a pseudo-tty (terminal)
`-i` : Interactive; keep `STDIN` open even if not attached
`--rm` : Automatically clean up the container and remove the file system when the container exits

##### Useful flags:
* *`--name` : Give the container a name for easy identification/referencing.
* `-p <local-host-IP>:<local-host-port>:<docker-container-port>` : Map the container port to a local host's IP and port. Can also do just ports, e.g. `-p 5432:5432`
* `--entrypoint <command>` : Override the `ENTRYPOINT` command of the Dockerfile, e.g. `/bin/sh` will start the container's shell.
* `--mount <???:???:???>` : TODO
* `--volume` : TODO
* `-d` : Start in detatched instead of attached mode. Containers exit when root process used to run container exits. If used with `--rm`, remove the container when it or the daemon exits
* `-e` : Set environment variables that are available for the process that will be launched inside of the container. See also `--env-file` in manual.

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

Remove/delete container(s)
`docker rm <container IDs>
Remove all stopped containers
`docker container prune`
OR:
`docker rm $(docker ps -a -q -f status=exited)`

## Cleaning up

Freeing up resources is important from time to time! Check how much resources Docker is using up:
```sh
docker system df
# or more granularly
docker system df -v
```

Most docker subcommands have a `prune` command, e.g.
`docker container prune`

Delete everything! Even images you may want to keep!
```
docker system prune --volumes --all

# Not cache layers
docker system prune
```

