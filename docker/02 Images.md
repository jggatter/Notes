# Docker Images
#docker #image

## Listing and inspecting

List images on local system
```sh
docker images
```

Inspect an image, e.g. to determine architecture it was built for:
```sh
docker image inspect <image id> | grep Architecture
``` 

## Pulling images

Pull a hosted image from the docker registry to the local system
```sh
docker pull repository/image:version
```

## Building and tagging images

Build from a Dockerfile in the present working directory and tag the image:
```sh
docker build -t repository/image:version .
```
You can also do as separate steps using `docker build` then `docker tag`.

Build from a Dockerfile specified by its path and tag the image:
```sh
docker build -f path/to/Dockerfile -t repository/image:version .
```

Build for a specific OS and architecture, like Linux x86, using `--platform`:
```sh
docker buildx build --platform linux/amd64 -t repository/image:version .
```
Note: The server must be multi-platform capable. Ex: Install Rosetta on Mac M1, M2, and other systems with Apple Silicon chips.

Tag a built image with another tag:

```sh
docker tag <existing image tag> <new image tag>
```

## Pushing images

Push a tagged image to a remote repository using `push`:
```sh
docker push repository/image:version
```

Push all tags of an image name to a repository using `--all-tags`:
```sh
docker push --all-tags repository/image
```

### AWS Elastic Container Registry

If AWS Elastic Container Registry (ECR) is the image hosting platform, there are some additional steps to take:

1) Logging in: 
```sh
aws ecr get-login-password --profile <AWSPROFILE> \
	| docker login \
		--username AWS \
		--password-stdin \
		$ECR_REGISTRY

```
2) Create the ECR repository if it does not yet exist! Otherwise you will be stuck "retrying".

## Removing images

Remove images:
```sh
docker rmi <image ID>
```

Remove a tag from an image that has multiple tags:
```sh
docker rmi <image name>:<tag>
```
