# docker-tensorflow-armv7l
Guide to build + run container with tensorflow for ARMv7l 

## DockerHub Images
Repo with tf2.3 on debian buster [Link to Docker Hub](https://hub.docker.com/repository/docker/16fb/tf2.3) \
Versions
* v1.0 -> base variant
* v1.1 -> added packages to download modules.
* v1.2 -> more packages to download modules, HTTPS functionality.
* v1.3 -> jupyter fully functional.
* v1.4 -> SKlearn and pandas included.

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
* `docker buildx build --platform linux/amd64,linux/arm/v7,linux/arm64 -t 16fb/tf2.3:v1.4 . --push`
\
\<tag\> = \<namespace\>/\<name\>:\<version\> \
In this case its named `tf2.3` in my personal `16fb` namespace for `version 1.4` \
Replace `16fb/tf2.3:v1.4` with your respective image tag. 

List of common platforms:
* linux/amd64 
* linux/386
* linux/arm64
* linux/arm/v7
* linux/arm/v6
* linux/riscv64
* linux/ppc64le
* linux/s390x

### [Test run docker container]
* `docker run 16fb/tf2.3:v1.4`

## Run docker interactively
### Pull Docker image to current directory
* `docker pull 16fb/tf2.3:v1.4`

### Run in shell
* `docker container run -it [docker_image] /bin/bash`
* `docker container run -it 16fb/tf2.3:v1.4 /bin/bash`

### Test Tensorflow version
* `python3`
* `import tensorflow as tf`
* `print(tf.___version__)`

## Run docker Jupyter notebook
Runs Jupyter notebook server, exposing port 8899 on host machine, password auth is dependant on hash. 
[How to compute Hash](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html#preparing-a-hashed-password)
```

export image="16fb/tf2.3:v1.4"
export Hash='<Hash here>'
export NOTEBOOKPORT=8899

docker run --env NOTEBOOKPORT=${NOTEBOOKPORT} --env Hash=${Hash} -p ${NOTEBOOKPORT}:${NOTEBOOKPORT}/tcp --rm -v $PWD:/data -w /data -u 0 --name JupyterNotebook -i $image /bin/bash << EOF	
export PATH=$PATH:~/.local/bin

echo Running Jupyter Notebook Server:
jupyter notebook --NotebookApp.password='$Hash' --no-browser --port=$NOTEBOOKPORT --ip=0.0.0.0 --allow-root

EOF

```
### Making changes in running container
Opens bash shell on container
`docker exec -it JupyterNotebook  /bin/bash`

## Run using Singularity 
File size can be quite big.

### Singularity pull
Singularity pull docker uri.
* `singularity pull docker://16fb/tf2.3:v1.4`

### install squashfstools
squashfstools is required by machine to convert docker into singularity containers
* `sudo apt-get install squashfs-tools`

### run in shell / interactively
* `singularity shell 16fb/tf2.3:v1.4`

## Writable Version of Singularity Container (Dev purposes)
Obtain writable(can install modules) version of container by using a sandbox: \

Build a Sandbox to enable writable version of container
* `sudo singularity build --sandbox <sand_box_name> <image_uri>`
* `sudo singularity build --sandbox tf2.3_sb_1.4 docker://16fb/tf2.3:v1.4`

OR Convert SIF to Sandbox, be in same directory as SIF file (doesnt seem to work for me)
* `sudo singularity build --sandbox <sand_box_name> <sif_file_path>`
* `sudo singularity build --sandbox tf2.3_sb_1.4 tf2.3_v1.4.sif`

Run as shell, mount mounts, allow writes so can install, Ensure you are root.
* `singularity shell --bind /mnt:/mnt --writable tf2.3_sb_1.4 /bin/bash`

## Export to tar file.
Export and Import docker image to file.  

Save to tar file
* `docker save --output tf2.3_v1.4 16fb/tf2.3:v1.4`

Load from tar file
* `docker load --input tf2.3_v1.4`

## Credits to these great ppl for guides
[fgervais](https://github.com/fgervais/docker-tensorflow) who did something similar. \
this [blog](https://www.padok.fr/en/blog/multi-architectures-docker-iot) that guides using buildx. 
