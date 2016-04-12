#!/bin/bash

PROJECT_NAME=docker-nginx-php
PROJECT_VERSION=0.0.7
docker build -t project.build -f Dockerfile.build .
echo "build done"
docker run project.build > build.tar.gz
echo "retreived package $(ls build.tar.gz)"
docker build -t registry.services.dmtio.net/$PROJECT_NAME:$PROJECT_VERSION -f Dockerfile.dist .
rm build.tar.gz
