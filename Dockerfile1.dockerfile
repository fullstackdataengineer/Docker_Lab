# Ubuntu image with vim
FROM ubuntu:20.04

LABEL maintainer "Eduardo Rodriguez"

RUN apt update && apt upgrade -y

RUN apt install -y vim





