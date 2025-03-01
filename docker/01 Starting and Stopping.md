# Starting Docker
#docker #daemon #unix #linux #groups
First one must install Docker and complete optional post-installation steps.

## Running `docker` without `sudo`
[Article](https://www.baeldung.com/linux/docker-run-without-sudo)

The Docker daemon binds to a Unix socket, and the __root__ user owns this Unix socket. Other users need to prefix their `docker` commands with `sudo` to access the Docker daemon. Running Docker commands with the `sudo` command is a sound security restriction. **However, users added to the Unix group _docker_ can run Docker commands as __root__ users while maintaining their usernames**.

By adding our Linux username to the Unix group _docker_, we can bypass this. When the Docker daemon starts, it creates a Unix socket accessible by the members of the _docker_ group.

```sh
# Create Unix group "docker"
sudo groupadd docker

# Add user jgatter to docker group
sudo usermod -aG docker jgatter

# Log back in
su - jgatter
```

## Starting the Docker Daemon

Starting docker is necessary before running any docker commands.

On Linux systems, depending on the distribution, you can use `systemctl` or `service`:
`sudo systemctl start docker`

On macOS, generally Docker Desktop is used to manage Docker. However, either `open -a` or `launchctl` can be used:
`open -a Docker`

## Stopping the Docker Daemon

On Linux systems, depending on the distribution, you can use `systemctl` or `service`:
`sudo systemctl stop docker`

On macOS, you can stop Docker Desktop from the menu bar icon, or use:
`killall Docker`

