#yaml #docker #compose #swarm #aws

[Article](https://www.baeldung.com/ops/docker-compose)

`docker-compose`, or `docker compose`, allows us to easily handle multiple containers and all their parameter sets by declaring configurations within a `docker-compose.yaml` file. This file is also known under the preferred name, `compose.yaml`.

Almost every rule within the YAML effectively replaces a specific Docker command. So, in the end we just need to run this command:

`docker-compose up`

The first thing to specify is the `version`. This is technically optional as Compose doesn't use it anymore for validation. Compose prefers the most recent schema when it's implemented.
```yaml
version: "3.7"
services:
  ...
volumes:
  ...
networks:
  ...
```

## Services

Services refer to the container's configuration. We can divide them up by labels like "frontend", "backend", and "db":
```yaml
services:
  frontend:
    image: my-vue-app
    ...
  backend:
    image: my-springboot-app
    ...
  db:
    image: postgres
    ...
```

## Volumes & Networks

Volumes are physical areas of disk space shared between the host and a container, or even between containers. A volume is a shared directory in the host that is visible from some or all containers.

Similarly, networks define the communication rules among containers and between a container and the host. Common network zones will make the container's services discoverable by each other. Private zones will segregate them in virtual sandboxes.

## Dissecting a service

### `image` and `build`

The `image` attribute allows us to reference a published image from a registry like Dockerhub or an image already built locally.

The `build` attribute allows us to build an image from source code by reading its Dockerfile. You can pass a local path or URL to the directory containing the Dockerfile.
```yaml
services: 
  my-custom-app:
    build: /path/to/dockerfile/
    ...
```
```yaml
services: 
  my-custom-app:
    build: https://github.com/my-company/my-project.git
    ...
```

An `image` name can be specified in addition to a `build` path!
```yaml
services: 
  my-custom-app:
    build: https://github.com/my-company/my-project.git
    image: my-project-image
    ...
```
The `image` name will make the built image available for use once created.
```yaml
version: '2'

services:
  es-master:
    build: ./elasticsearch
    image: porter/elasticsearch
    ports:
      - "9200:9200"
    container_name: es_master

  es-node:
    image: porter/elasticsearch
    depends_on:
      - es-master
    ports:
      - "9200"
    command: elasticsearch --discovery.zen.ping.unicast.hosts=es_master
```

### Configure the networking

Docker containers communicate between themselves in networks created, implicitly through configuration by Docker Compose.

A service can communicate with another service on the same network simply by referencing it by container name and port, provided we've made the port accessible via the `expose` attribute. For example: an app running on a service could use `network-example-service:80` to communicate with the container running on `network-example-service` with port `80` exposed. 
```yaml
services:
  network-example-service:
    image: karthequian/helloworld:latest
    expose:
      - "80"
```

To reach a container from the host, the ports must be exposed declaratively through the `ports` keyword. This allows us to choose if we're exposing the port differently in the host.
```yaml
services:
  network-example-service:
    image: karthequian/helloworld:latest
    ports:
      - "80:80"
    ...
  my-custom-app:
    image: myapp:latest
    ports:
      - "8080:3000"
    ...
  my-custom-app-replica:
    image: myapp:latest
    ports:
      - "8081:3000"
    ...
```
Port 80 will now be visible from the host, while port 3000 of the other two containers will be available on 8080 and 8081 in the host. This allows us to expose the same container ports without any collision.

### Volumes

There are three types of volumes:
- anonymous
- named
- host

Docker manages anonymous and named volumes, automatically mounting them in self-generated directories in the host. It's suggested to use named ones over anonymous volumes with newer versions of Docker (1.9+).

Host volumes allow us to specify an existing folder in the host.

We can configure host volumes at the service level, and named volumes in the outer level of the configuration. Using the outer level for named volumes makes it visible to the other containers rather than remaining private to the one it belongs to.
_(Reminder: convention is `<host path>:<container path>:<permission flags>` where permission flags is optional)_
```yaml
services:
	volumes-example-service:
		image: alpine:latest
		volumes:
			- my-named-global-volume:/my-volumes/named-global-volume
			- /tmp:/my-volumes/host-volume
			- /home:/my-volumes/readonly-host-volume:ro
			...

	another-volumes-example-service:
		image: alpine:linux
		volumes:
			- my-named-global-volume:/another-path/the-same-named-global-volume
		...

volumes:
	my-named-global-volume:
```
- Here both containers have read-write access to the `my-named-global-volume` shared folder, regardless of the paths they've mapped to.
- The `/tmp` folder of the host's file system is mapped to the `/my-volumes/host-volume` folder of the container. This portion of the file system is writeable, which means that the container can also delete files within the folder of the host machine.
- We can mount a volume in read-only mode by appending `:ro` to avoid containers deleting data within this folder in the host.

### Declaring dependencies

Oftentimes we need to create a dependency chain between our services such that some services get loaded before (and unloaded after) others. We can achieve this result through `depends on`:
```yaml
services:
  kafka:
    image: wurstmeister/kafka:2.11-0.11.0.3
    depends_on:
      - zookeeper
    ...
  zookeeper:
    image: wurstmeister/zookeeper
    ...
```
Be aware that Compose will not wait for the zookeeper service to finish **loading** before starting the kafka service; it will simply wait for zookeeper to **start**. If we need a service to be fully loaded before starting another service, we need to get [deeper control of the startup/shutdown order in Compose](https://docs.docker.com/compose/startup-order/).

### Managing `environment` variables

Working with environment variables is easy in Compose! Using the `${}` notation, we can define **static** environment variables as well as **dynamic** variables.
```yaml
services:
	database:
		image: "postgres:${POSTGRES_VERSION}"
		environment:
			DB: mydb
			USER: "${USER}"
```
We have different options for providing these values to Compose.
1) Setting them in an `.env` file in the same directory as the configuration, structures like a `.properties` file, `key=value` style:
```text
POSTGRES_VERSION=alphine
USER=foo
```
2) Setting them in the OS before calling the command `docker-compose up`:
```console
export POSTGRES_VERSION=alphine
export USER=foo
```
3) A simple one-liner: `POSTGRES_VERSION=alphine USER=foo docker-compose up`

We can mix approaches, but note that Compose uses the following priority order, overwriting the less important with the higher priorities.
1. Compose file
2. Shell environment variables
3. Environment file
4. Dockerfile
5. Variable not defined

### Scaling and replicas

The `deploy` section of a service specifies the configuration for the deployment and lifecycle of the service, as defined in the [Compose Deploy Specification](https://docs.docker.com/compose/compose-file/deploy/). It's specifically designed for use with [Docker Swarm](https://docs.docker.com/engine/swarm/), a cluster of Docker Engines. If Swarm is not used, the `deploy` section is ignored.

We can use Docker Swarm to _scale_ our containers, defining the number of _replicas_.
- A replica is an instance of a Docker container. In the context of Docker Swarm, when you deploy a service (which is a group of containers running the same image), you can specify how many replicas of that service you want. Each replica is a container of the service running on a node in the swarm.

Scaling horizontally refers to the action of changing the number of replicas. It's about adjusting the number of container instances to match the load or availability requirements. In Docker Swarm, you can scale services up or down by increasing or decreasing the number of replicas. This is often done dynamically in response to application demands.

To actually use Docker Swarm features, including those specified under the `deploy` key, you need to initialize a Docker Swarm. This is done with the `docker swarm init` command, which turns a Docker engine into a Swarm manager node. Once in Swarm mode, you deploy your application stack using the `docker stack deploy` command with the `docker-compose.yml` file. This command respects the `deploy` configurations, applying them to the services as they are deployed across the Swarm cluster.

We use the`replicas` attribute of the `deploy` section to specify the number of instances to run for a service.
```yaml
services:
	worker:
		image: dockersamples/examplevotingapp_worker
		networks:
			- frontend
			- backend
		deploy:
			mode: replicated
			replicas: 6
			resources:
				limits:
					cpus: '0.50'
					memory: 50M
				reservations:
					cpus: '0.25'
					memory: 20M
			...
```

Under `deploy`, we can also specify many other options, like the `resources` limits and reservations for CPU and memory:
- `limits` define the maximum amount of resources a replica can use. In your example, each replica of the `worker` service is limited to using up to 0.50 CPUs and 50M of memory.
- `reservations` indicate the minimum amount of resources guaranteed to each replica. Here, each replica is guaranteed 0.25 CPUs and 20M of memory.

Above, the configuration has static scaling because it always maintains 6 replicas regardless of load or resource usage. It does not automatically adjust the number based on metrics like CPU usage, memory usage, or network I/O. Docker Swarm does not provide built-in autoscaling like other orchestrators such as Kubernetes.

We can horizontally scale actively deployed services by running:
`docker-compose up --scale <SERVICE>=<NUM>`: Scale SERVICE to NUM instances.

Be aware that scaling down services might result in stateful data being lost if your container are not set up to handle horizontal scaling. This is important for databases and other services that maintain state. Key points for ensuring data integrity and service continuity:
- Use volumes to persist data
- Implement a replication mechanism for your database
	- e.g. configure MySQL settings to enable master-slave replication and compose a separate master service and slave services.
- Implement graceful shutdown procedures in your application
	- e.g. In Python, use `signal.signal()` to handle `signal.SIGTERM` and `signal.SIGINT` and call `my_signal_handler`. If the Python app is processing a work unit, the signal handler can flip a state flag that can be used to bring the process to an end after the unit is processed.
	- Many API frameworks have built-in support for graceful shutdown.
	- The implementation could be used to pause a process for resuming later. The application can define how to checkpoint the state, persisting the information on disk or in a DB. On startup, check if a saved state exists and load it if so. Tasks can be designed as idempotent as well, meaning that potentially repeating a task would not impact the result.
### Lifecycle Management

Let's revisit the syntax of Docker Compose:
```plaintext
docker-compose [-f <arg>...] [options] [COMMAND] [ARGS...]
```
[Compose command reference](https://docs.docker.com/compose/reference/overview/) for other commands and options.

We can create and start the defined containers, networks, and volumes in the configuration with `up`. After the first time we can do `start` to start the services. `start` can accept different configuration files when specified:
`docker-compose -f alt-compose-file.yml start`

Compose can also run in the background as a daemon when launched with `-d`:
`docker-compose up -d`

We can shut down active services using `stop`, which preserves containers, volumes, and networks along with every modification made to them:
`docker-compose stop`

We can reset the status of the project using `down`, which destroys everything except for external volumes:
`docker-compose down`
Running the following instead will also destroy the external volumes that were created:
`docker-compose down -v`

### Other useful CLI commands

We can validate and show the configuration:
`docker-compose config`

We can tail the logs:
`docker-compose logs`

We can list all running containers for defined services:
`docker-compose ps`

We can execute a command in a running container:
`docker-compose exec my-service bash` 

We can apply other Docker equivalent commands like `build`, `run`, `pull`, `push`, `restart`, and `rm`.
### Other useful configuration keywords
[Compose file reference](https://docs.docker.com/compose/compose-file/)

- `command`: overrides Dockerfile's `CMD`
- `entrypoint`: overrides Dockerfile's `ENTRYPOINT`
- `working_dir`: overrides Dockerfile's `WORKDIR`
- `user`: Set username or UID to use when running the container
- `container_name`: specifies the container name rather than Compose generating one. Does not work with `scale`.
- `env_file`: adds environment variables to the container based on the file content.
- [`healthcheck`](https://docs.docker.com/compose/compose-file/05-services/#healthcheck): declares a check that's run to determine whether or not the service containers are "healthy". Works the same as Dockerfile's `HEALTHCHECK`.
- `external_links`:  Links to containers started outside of the current Docker Compose file.
	- Example: `external_links: - redis_1`
- `restart`: Specifies the restart policy for how a container should or should not be restarted on exit. 
	- Example: `restart: on-failure`

## AWS Integrations

AWS Elastic Container Service (ECS) has support for Compose, allowing you to use Docker compose files to define and run multi-container applications on ECS. You can deploy applications to a fully managed container orchestration service without the need for managing underyling infrastructure.

Also Docker itself has introduced an ECS context integration. By setting up an ECS context in Docker, you can deploy your application to ECS using `docker compose up`.

AWS CloudFormation also has integration with Compose. Compose files can be converted to CloudFormation templates which can then be used to provision and manage AWS resources. This can be done via `docker compose convert`.

AWS Elastic Beanstalk supports the deployment of Docker-based applications. You can package a `docker-compose.yaml` and deploy it using Elastic Beanstalk which manages the deployment process, including load balancing, scaling, and application health monitoring. Elastic beanstalk is good for relatively simple, non-mission critical applications.


