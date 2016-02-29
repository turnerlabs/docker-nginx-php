#!/bin/bash

PROJECT_NAME=docker-nginx-php
PROJECT_VERSION=0.0.2
docker build -t project.build -f Dockerfile.build .
docker run project.build > build.tar.gz
docker build -t registry.services.dmtio.net/$PROJECT_NAME:$PROJECT_VERSION -f Dockerfile.dist .
rm build.tar.gz
