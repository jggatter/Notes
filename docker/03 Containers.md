# Docker Containers
#docker #container #image

## Running

Simplest example: Launch a container with the specified tagged image
```sh
docker run --rm -it repository/image:version`
```

Flags explained:
- `-t` : Allocate a pseudo-tty (terminal)
- `-i` : Interactive; keep `STDIN` open even if not attached
- `--rm` : Automatically clean up the container and remove the file system when the container exits

### Entrypoint and Command

The `ENTRYPOINT` specifies a command that will always be executed when the container starts.

The `CMD` aka `COMMAND` specifies arguments that will be fed to the `ENTRYPOINT`.
By default, there is no entrypoint set. Any commands specified will be executed using `/bin/sh -c`.
```sh
docker run --rm -it repository/image:version echo "hi"
```
Our command runs as `/bin/sh -c echo "hi"` within the container.

It's common to specify a command of `/bin/bash` to explore using `bash` instead of `sh`.
Note that some images may not have `bash` or the ability to whatever command you specify.

We can specify the entrypoint using `--entrypoint`:
```sh
docker run --rm --entrypoint "/bin/bash -c" -it myimage:latest
```

### Other useful flags:
* `-p <local-host-IP>:<local-host-port>:<docker-container-port>` : Map the container port to a local host's IP and port. Can also do just ports, e.g. `-p 5432:5432`
* `--entrypoint <command>` : Override the `ENTRYPOINT` command of the Dockerfile, e.g. `/bin/sh` will start the container's shell.
* `--mount <???:???:???>` : TODO
* `--volume` : TODO
* `-d` : Start in detached instead of attached mode. Containers exit when root process used to run container exits. If used with `--rm`, remove the container when it or the daemon exits
* `-e` : Set environment variables that are available for the process that will be launched inside of the container. See also `--env-file` in manual.
* `--name` : Give the container a name for easy identification/referencing.
* `--platform`: Specify the OS and CPU architecture to run. With Rosetta installed on Apple Silicon MacBooks, specify `linux/amd64` to run images that were built for Linux and x86 architecture. 

## Creating

Alternatively, you can `create` a container without running it.
```sh
docker create --name my-container nginx
```

It prepares the container for execution by setting up any configurations specified in the command such as:
- volumes
- environment 
- variables
- and networking options

However, the main process isn't started until `docker start` is invoked. 
Ultimately, `docker run` is just a combination of `create` and `start`.

## Attaching and Detaching:

`docker attach <container id>` will attach to the container

When attached to running container:
- `^C` will terminate the container
- `^P^Q` (holding both at the same time) will detach

## Interacting

A container can be specified as `docker` command arguments by its:
- long UUID
- short UUID
- or container name.

Sometimes commands can accept multiple containers as arguments.

List containers using `docker ps`.

Flags:
- `-a` : All
- `-f` : Filter based on conditions provided, e.g. `status=exited`
- `-q` : Returns IDs in numeric value

Attach to container
```sh
docker attach <container ID>`

Execute a command within a running container
```sh
docker exec <container ID>`
Can use `-it` flags like the `run` command

Stop the container (does not delete unless was run with `--rm`)
```sh
docker stop <container ID>`

Start a stopped container
```sh
docker start <container ID>`

Copy files from a container
```sh
docker cp <container id>:/path/to/file/in/container /path/to/local/dir`
Alternatively:
```sh
# Create a temporary container from the image:
docker create --name temp-container your-image-name
# Copy the file from the newly created container:
docker cp temp-container:/path/to/file /local/path
# docker rm temp-container
docker rm temp-container
```