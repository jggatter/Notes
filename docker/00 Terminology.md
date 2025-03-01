# Docker Terminology
#docker #image #container #daemon

## Terminology

**Images** - The blueprints of our application which form the basis of containers.

**Containers** - Created from Docker images and run the actual application.

**Docker Daemon** - The background service running on the host that manages building, running and distributing Docker containers. The daemon is the process that runs in the operating system to which clients talk to.

**Docker Client** - The command line tool that allows the user to interact with the daemon. More generally, there can be other forms of clients too - such as Kitematic which provide a GUI to the users.

**Docker Hub** - _A registry of Docker images. You can think of the registry as a directory of all available Docker images. If required, one can host their own Docker registries and can use them for pulling images.

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

