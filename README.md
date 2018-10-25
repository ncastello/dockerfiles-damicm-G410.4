# dockerfiles-damicm-G410.4
Docker context to create docker Geant4 10.3 image to developments and background
studies with Geant4 for DAMIC@MODENA
# dockerfiles-damicm-G410.4

Docker __context__ to create docker Geant4 version 10.4 image to developments and background studies for 
DAMIC@Modane (DAMIC-M experiment). This image is based on an ubuntu-16.04 and contains the necessary 
packages to run DAMICMG4 (private repository git@gitlab.in2p3.fr:damicm/DAMICSNOLAB_G4sims).

## Install

#### installing prerequisites
Assuming `docker` and `docker-compose` is installed on your system (host-computer).

[how to install docker](https://docs.docker.com/install/linux/docker-ce/debian/#install-docker-ce-1) in linux

[how to install docker-compose](https://docs.docker.com/compose/install/#install-compose) in linux

execute docker without requiring sudo: 
```
$ sudo usermode -a -G $USER
```

#### 1. Clone the docker geant4.10.3 repository

```bash
$ git clone https://github.com/ncastello/dockerfiles-damicm-G410.4.git
$ cd dockerfiles-damicm-G410.4
```

#### 2. To get the docker container you can either download the image from the dockerhub
   ```bash
   $ docker pull ncastello/damicm-geant4.10.4
   ```
   or alternatively build the docker image from the Dockerfile using docker-compose:

   ```bash
   # Using docker
   $ docker build github.com/ncastello/dockerfiles-damicm-G410.4
   # Using docker-compose within the repo directory
   $ docker-compose build damicm-geant4.10.4
   ```

## USAGE

The first to do is to give permissions to docker to access the X-server
```bash
$ xhost +local:docker
```

There are two ways to use this container:

#### 1. __As user__

    The recommended way to run dockerfiles-damicm-G410.4 is with docker-compose

    ```bash
    $ docker-compose run --rm <service_name>
    ```

    where <service_name> can be found in the docker-compose.yml file (i.e `damicdev` in the example below). This
    will allow you to run this container under a __production environment__.
    

#### 2. __As developer__

    However, if what you need is to develop GEBIC, i.e. to use this container in a
    __development environment__ and consequently have a link to your host-computer,
    you should then include the file __docker-compose.override.yml__ into this repository.
    This file is as follows

    ```file
    version: "3.2"
	services:
        damicdev:
            volumes:
                - type: bind
                 source: @global_path_to_some_local_folder
                 target: /workingdir
    ```
    where @global_path_to_some_local_folder is __the path in the host-computer__ to be shared with the container, 
    is the way to transfer information between your computer and the container. This means /workingdir (in the 
    container) is linked to global_path_to_some_local_folder (in the host-computer).

## Note

Note that if you have both __docker-compose.override.yml__ and __docker-compose.yml__ files, to run the container with a
__production environment__  you just run `docker-compose` as follows

```bash
$ docker-compose -f docker-compose.yml run --rm damicdev
```
By default, `docker-compose` use the override yml file.


## Usefull `docker` commands

#### 1. List containers
    ```bash
    $ docker ps
    ```

#### 2. Deleting ...
    ```bash
    $ docker image prune
    $ docker container prune
    $ docker system prune
    $ docker network prune
    ```
