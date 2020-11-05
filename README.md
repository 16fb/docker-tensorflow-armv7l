## docker-tensorflow-armv7l

# Cross compiling using buildx to generate armv7l tensorflow2.3 docker images

## Set Dockerfile file to version we want

## Multi Architecture Builds Commands
[Enable experimental features]
* `$ export DOCKER_CLI_EXPERIMENTAL=enabled`

[List what architecture current builder can handle]
* `$ docker buildx ls`

[QEMU cross compilation framework]
* `$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes`

[Create new builder that can use QEMU]
* `$ docker buildx create --name mybuilder --driver docker-container --use`

[Display buildable platforms]
* `$ docker buildx inspect --bootstrap`

[Building, is the same, just with --platform]
* `$ docker buildx build --platform <Platform> -t <tag> . --push`
* `$ docker buildx build --platform linux/amd64,linux/arm/v7 -t 16fb/pytime2:v1.1 . --push`
\
<tag> = namespace/name:version \
In this case its named pytime in my personal 16fb namespace for vesion 1.1\

[Try Running on rasp pi and on windows]
* `docker run 16fb/pytime2:v1.1`

## Run docker interactively
### Docker Pull
* `docker pull 16fb/tf2.3:v1.1`

### Run in shell
* `docker container run -it [docker_image] /bin/bash`
* `docker container run -it 16fb/tf2.3:v1.1 /bin/bash`

### Test Tensorflow version
* `python3`
* `import tensorflow as tf`
* `print(tf.___version__)`

## Run Singularity 
File size quite big

### Singularity pull
* `singularity pull docker://16fb/tf2.3:v1.1`

### install squashfstools
* `sudo apt-get install squashfs-tools`

### run in shell
* `singularity shell 16fb/tf2.3:v1.1`


## Credits to these great ppl for guides
[fgervais](https://github.com/fgervais/docker-tensorflow) who did something similar. \
this [blog](https://www.padok.fr/en/blog/multi-architectures-docker-iot) that guides using buildx. \