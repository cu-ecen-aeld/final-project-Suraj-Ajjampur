#!/bin/bash
pushd $(dirname $0)
pushd ..

# Default docker file
dockerfile=docker/Dockerfile.dGPU


# Check for ARM architecture on target 
uname -m | grep aarch64 > /dev/null

# Dockerfile used on Jetson nano
if [ $? -eq 0 ]; then
    dockerfile=docker/Dockerfile.Jetson
fi

# deepstream-nvdsanalytics-docker is the Docker image name which uses "dockerfile" in the source files
# in src directory needed to build the docker image
docker build -t deepstream-nvdsanalytics-docker -f ${dockerfile} src
