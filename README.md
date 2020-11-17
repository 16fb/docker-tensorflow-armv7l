# docker-tensorflow-armv7l

## DockerHub Images
Repo with tf2.3 on debian buster [Link to Docker Hub](https://hub.docker.com/repository/docker/16fb/tf2.3) \
Versions
* v1.0 -> base variant
* v1.1 -> added packages to download modules.
* v1.2 -> more packages to download modules, HTTPS functionality.
* v1.3 -> jupyter fully functional.

## Cross compiling using buildx to generate armv7l tensorflow2.3 docker images

### Set Dockerfile file to version we want
Requires linux with docker installed.  \
I'am using wsl2 with Ubuntu with docker installed.

## Multi Architecture Builds Commands
Run the following commands to setup envrionment to cross compile docker containers.

### [Enable experimental features]
* `export DOCKER_CLI_EXPERIMENTAL=enabled`

### [List what architecture current builder can handle]
* `docker buildx ls`

### [QEMU cross compilation framework]
* `docker run --rm --privileged multiarch/qemu-user-static --reset -p yes`

### [Create new builder that can use QEMU]
* `docker buildx create --name mybuilder --driver docker-container --use`

### [Display buildable platforms]
* `docker buildx inspect --bootstrap`

### [Building, is the same, just with --platform]
* `docker buildx build --platform <Target_Platforms> -t <tag> . --push`
* `docker buildx build --platform linux/amd64,linux/arm/v7 -t 16fb/tf2.3:v1.3 . --push`
\
\<tag\> = \<namespace\>/\<name\>:\<version\> \
In this case its named `tf2.3` in my personal `16fb` namespace for `version 1.1` \
Replace `16fb/tf2.3:v1.1` with your respective image tag. 

### [Test run docker container]
* `docker run 16fb/tf2.3:v1.1`

## Run docker interactively
### Pull Docker image to current directory
* `docker pull 16fb/tf2.3:v1.1`

### Run in shell
* `docker container run -it [docker_image] /bin/bash`
* `docker container run -it 16fb/tf2.3:v1.1 /bin/bash`

### Test Tensorflow version
* `python3`
* `import tensorflow as tf`
* `print(tf.___version__)`

## Run using Singularity 
File size can be quite big.

### Singularity pull
* `singularity pull docker://16fb/tf2.3:v1.1`

### install squashfstools
squashfstools is required by machine to convert docker into singularity containers
* `sudo apt-get install squashfs-tools`

### run in shell / interactively
* `singularity shell 16fb/tf2.3:v1.1`

## Writable Version of Singularity Container (Dev purposes)
Obtain writable(can install modules) version of container by using a sandbox: \

Build a Sandbox to enable writable version of container
* `sudo singularity build --sandbox tf2.3_sb docker://16fb/tf2.3:v1.1`

OR Convert SIF to Sandbox, be in same directory as SIF file (doesnt seem to work for me)
* `sudo singularity build --sandbox tf2.3_sb tf2.3_v1.1.sif`

Run as shell, mount mounts, allow writes so can install, Ensure you are root.
* `singularity shell --bind /mnt:/mnt --writable tf2.3_sb /bin/bash`

## Credits to these great ppl for guides
[fgervais](https://github.com/fgervais/docker-tensorflow) who did something similar. \
this [blog](https://www.padok.fr/en/blog/multi-architectures-docker-iot) that guides using buildx. 

### commands
docker buildx build --platform linux/amd64,linux/arm/v7 -t 16fb/tf2.3:v1.2 . --push
sudo singularity build --sandbox tf2.3_sb_v1.2 docker://16fb/tf2.3:v1.2