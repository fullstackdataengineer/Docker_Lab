# Installing Two Web Servers  

## Web Server 1:  

```
    docker run -d -p 8080:80 nginx
```  
## Web Server 2:  
```  
    docker run -d -p 8081:80 nginx
```  
Navigate to http://host:8080 and http://host:8081  

To list running containers, type:  
```  
    docker ps
```  
The images in your docker engine can be listed using:  
```  
    docker images
```  
Finally, containers and images can be removed using docker rm and docker rmi, respectively:  
```  
    docker rm container_name
    docker rmi image_name
```  

# Docker Pull  

```  
docker pull hello-world
```  

```  
docker login -u username -p password myregistry.azurecr.io
```  

```  
  docker pull redis  
  docker pull redis:6.2.7  
  docker inspect redis:latest
```  

# PRACTICE: CREATE A CUSTOM DOCKERFILE  


Create directory myfirstimage  

```  
    mkdir myfirstimage
```  
Change to directory myfirstimage  
```  
    cd myfirstimage
```  
Create an empty file called Dockerfile  
```  
    touch Dockerfile
```  

Use a text editor to edit Dockerfile. For example vim, nano or code (if you use Visual Studio Code)

## Basic Dockerfile with Alpine as base image and vim editor


```  
FROM alpine

LABEL maintainer "Eduardo Rodriguez"

RUN apk -U add vim
```  

## Building your first Dockerfile  
```  
docker build .  
docker images 
```  

Notice your image has an ID but not a Repository or Tag, as these were not specified in the build command.  
Notice also the base image (alpine) in the FROM command is now available locally.  
Now try:  

```  
docker build . -t myfirstimage:1.0  
```  

List the commands that were used to build your image (each line is a corresponding Layer):   

```  
docker history myfirstimage:1.0
```  

Display additional information on your Docker image:  
```  
docker inspect [id|name] 
```  

## Push custom image to Azure Container Registry  

Browse to your targer Azure Container Registry and click "Quick Start" to get help on commands  
Click on Access keys and gather username and password. You will use these with docker login command  

```  
docker login mycr.azurecr.io 
docker tag myfirstimage:1.0 mycr.azurecr.io/myfirstimage:1.0
docker images
docker push mycr.azurecr.io/myfirstimage:1.0
```  

To check your image was pushed, click on repository and click on your image name (myfirstimage).  
You should now see the tag name you used when pushing your local image  

# Dockerfile with Environment Variables  

Consider Dockerfile:  

```  
# Web Server with nginx and PHP  
FROM ubuntu:20.04

LABEL maintainer "Eduardo Rodriguez" 

ARG JQUERY_VERSION=3.6.0
ARG DEBIAN_FRONTEND=noninteractive

ENV DOC_ROOT /var/www/mysite-dev
ENV JQUERY_VERSION ${JQUERY_VERSION}

RUN apt update \
&& apt upgrade -y \
&& apt install -y \
nginx \
php7.4 \
&& rm -rf /var/lib/apt/lists/*

COPY code/site/mysite ${DOC_ROOT}
ADD https://code.jquery.com/jquery-${JQUERY_VERSION}.min.js ${DOC_ROOT}/js
```  

${DOC_ROOT}/js will be created by ADD if it does not exist, however COPY requires that target directory exists:  

```  
mkdir -p code/site/mysite  
touch code/site/mysite/index.html  
```  

The ARG instruction ensure default JQUERY version is 3.6.0, but an alternative value can be passed as a build-arg to the docker build command.  

Build the Dockerfile above running:  
```  
docker build . -t envimage
```  
Check what happened to ARG and ENV layers:  
```  
docker history envimage
```  
docker build --build-arg JQUERY_VERSION=3.0.0 .
```  

Check what happend to ARG and ENV layers:  
```  
docker history envimage
```  

Notice that with --build-arg, docker must rebuild all layers below the ARG instruction.  


# Manage a Webserver Container  

Create Dockerfile:  
```  
# Web Server with nginx and PHP  
FROM ubuntu:20.04

LABEL maintainer "Eduardo Rodriguez" 

ARG JQUERY_VERSION=3.6.0
ARG DEBIAN_FRONTEND=noninteractive

ENV DOC_ROOT /var/www/mysite-dev
ENV JQUERY_VERSION ${JQUERY_VERSION}

RUN apt update \
&& apt upgrade -y \
&& apt install -y \
nginx \
php7.4 \
&& rm -rf /var/lib/apt/lists/*

COPY code/site/mysite ${DOC_ROOT}
ADD https://code.jquery.com/jquery-${JQUERY_VERSION}.min.js ${DOC_ROOT}/js
```  

```  
mkdir -p code/site/mysite  
touch code/site/mysite/index.html  
```  

```  
docker build -t webserver .  
```  

```  
docker run -it --name webserver1 webserver php -a  
```  

Type exit and then:  
```  
docker ps -a  
```  

Start the container again:  

```  
docker start webserver1
```  

Make sire the container is up:  
```  
docker ps -a  
```  

Finally, launch a bash shell on the running container:  

```  
docker exec -it webserver1 bash  
```  

# Managing Docker Volumes  

A docker volume is a docker object, and thus it has an ID, can be created, listed, and removed. 

```  
docker volume create vol1
docker run --name vol1-test -v vol1:/webvol1 -it webserver bash
```  

Inside the container, create a file inside the volume:  
```  
touch /webvol1/file1.txt  
```  

Exit the container.  
Create another container and check that /webvol1/file1.txt exists:  

```  
docker run --name vol2-test -v vol1:/webvol1 -it webserver bash
ls /webvol1/
```  

The name of the container directory is arbitrary:  
```  
docker run --name vol3-test -v vol1:/anothername -it webserver bash
ls /anothername
```  


This Exercise can easily be adapted to Bind Mounts, by replacing vol1 by a local directory  
