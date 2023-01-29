#!/usr/bin/env bash
VERSION=4.8.0

docker build -t phil1pp/weewx:$VERSION .
docker push phil1pp/weewx:$VERSION
docker tag phil1pp/weewx:$VERSION phil1pp/weewx:latest
docker push phil1pp/weewx:latest

#docker build -t weewx:$VERSION .
