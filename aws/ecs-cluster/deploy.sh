#!/bin/bash

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

cluster_name="ecs-example"
service_name="${cluster_name}-service"
profile_name="ecs-example"

ecs-cli compose --verbose --file docker-compose.yml --cluster-config ${profile_name} --project-name ${service_name}  service up --timeout 10
