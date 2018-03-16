#!/bin/bash

# to get ecs-cli client, go to https://github.com/aws/amazon-ecs-cli

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

VERSION=${1}

if [[ -z ${VERSION} ]]
then
  echo "error, version tag was not provided, usage: ${0} <version tag>"
  exit 1
fi

CLUSTER_NAME="ecs-cluster"

echo "[*] [$( date +'%H:%M:%S')] configuring profile..."
ecs-cli configure profile --profile-name default --access-key ${AWS_ACCESS_KEY_ID} --secret-key ${AWS_SECRET_ACCESS_KEY}
ecs-cli configure --cluster ${CLUSTER_NAME} --region eu-west-1 --config-name default --default-launch-type EC2
echo "[*] [$( date +'%H:%M:%S')] set new tag on image..."
sed "s/TAG_VERSION/${VERSION}/g" docker-compose-template.yml > docker-compose.yml
ecs-cli compose up
echo "[*] [$( date +'%H:%M:%S')] current status..."
ecs-cli compose ps
ip_address=$( ecs-cli ps | grep RUNNING | head -n1 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" )
echo "[*] [$( date +'%H:%M:%S')] you can access your instance at http://${ip_address}/..."
