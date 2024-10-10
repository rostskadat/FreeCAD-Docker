# FreeCAD-docker

This is a docker container intended to act as a build and run environment for
FreeCAD.

It is based on [daviddaish/freecad_docker_env](https://gitlab.com/daviddaish/freecad_docker_env)

The directories containing FreeCAD's source code and build are not included
inside the docker image. Instead, they are attached to the docker container
when you run the container. This allows the built code to have continuity
across different docker containers, reducing the time for a build to occur, and
allowing you to use your own editor/IDE outside of the container.

The docker is not deployed and therefore you need to build it locally

## Build the docker image

You must edit the [run_docker.sh](run_docker.sh) to set the correct path to the `SOURCE_DIR`, `BUILD_DIR` and `CONF_DIR`. Then you can execute `run_docker.sh`:

```shell
?> ./run_docker.sh
```

## Build FreeCAD

Once the docker container has been created, you should have access to a command prompt that allows you to build your version of FreeCAD.

```shell
docker> /root/build_script.sh
```

## Run FreeCAD

Once you have build FreeCAD you can execute it with:

```shell
docker> /mnt/build/bin/FreeCAD
```

>**For mac users:**
>
>In order to use the GUI, you must install [XQuartz](https://www.xquartz.org/).
>
>Then, open XQuartz with `open -a XQuartz`, and ensure "Allow connections from
>within network clients" is ticked, under the "Security" tab. This process was
>taken from this [blogpost](https://sourabhbajaj.com/blog/2017/02/07/gui-applications-docker-mac/).

You will be able to find the mounted directories within the container in the
`/mnt` directory, named `/mnt/source`, `/mnt/build`, and `/mnt/files`.

## Developing the image

### Build docker image

Building the docker image might take several hours (depending on your connection).

```shell
docker build -t registry.gitlab.com/daviddaish/freecad_docker_env:latest .
```

Note that, because of the size of the dependancies, docker may throw a `no space left on device`
error part way through the build. To reduce the likelyhood of this, ensure you have around 25GB
of space on your storage. You can also run `docker system prune` to free up space.

### Pushing the docker image

Prior to pushing, the image must be able to reliabily build the most recent
tags of the FreeCAD source code: `master`, `0.19_pre`, and `0.18.4`.

```shell
docker login registry.gitlab.com
docker push registry.gitlab.com/daviddaish/freecad_docker_env:updates
```
