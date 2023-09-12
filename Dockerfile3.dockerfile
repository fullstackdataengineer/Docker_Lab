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