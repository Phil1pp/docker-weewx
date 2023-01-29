# start weewx 
# This assumes you create your weewx space in /var/docker/weewx
mkdir -p skins data html user archive
docker run -d --restart unless-stopped --name weewx -v /var/docker/weewx/skins:/home/weewx/skins -v /var/docker/weewx/data:/data -v /var/docker/weewx/html:/home/weewx/public_html
 -v /var/docker/weewx/user:/home/weewx/bin/user -v /var/docker/weewx/archive:/home/weewx/archive weewx:4.8.0

# Start nginx
docker run -d --restart unless-stopped --name nginx-weewx -p 8888:80 -v /var/docker/weewx/html:/var/www/html -e REMOVE_FILES=0 -e SKIP_COMPOSER=1 -e SKIP_CHOWN=1 -e SKIP_CHMOD=1
-e PHP_ERRORS_STDERR=1 richarvey/nginx-php-fpm:latest
