# this assumes you have my repo stored in
# /var/docker/weewx/git/docker-weewx
# and that your main install is under /var/docker/weewx
docker stop weewx
docker rm weewx
docker rmi -f weewx:4.8.0
cd git/docker-weewx
./build.sh
cd ../../
./run.sh
docker image prune
