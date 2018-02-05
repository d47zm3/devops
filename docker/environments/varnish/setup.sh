#!/bin/bash

# include my bash framework
. ~/.bash_framework

apache_container="apache"
varnish_container="varnish"

decho "Stopping and removing all containers..."
# stop all containers and remove them (except my pentest container!)
docker stop $(docker ps -a | egrep -v "CONTAINER|h4ck3r" | awk '{print $1}') > /dev/null
docker rm $(docker ps -a | egrep -v "CONTAINER|h4ck3r" | awk '{print $1}') > /dev/null

decho "Running new set of containers..."
docker run --name "${apache_container}" -d  eboraas/apache-php > /dev/null
docker run -itd --link ${apache_container}:apache-web --name "${varnish_container}" million12/varnish > /dev/null

decho "Put Varnish config file in place..."
docker cp default.vcl ${varnish_container}:/etc/varnish/default.vcl
decho "Restart Varnish to refresh settings..."
docker restart ${varnish_container} > /dev/null

decho "Testing..."
apache_ip=$( docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${apache_container} )
varnish_ip=$( docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${varnish_container} )
sleep 5
decho "Apache..."
curl -s -i "http://${apache_ip}" | grep "HTTP/"
decho "Varnish..."
curl -s -i "http://${varnish_ip}" | grep "HTTP/"
