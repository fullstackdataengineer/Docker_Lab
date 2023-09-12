# Web Server with nginx and PHP  
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer "Eduardo Rodriguez"  

RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y \
vim \
nginx \
php7.4 \
&& rm -rf /var/lib/apt/lists/*


