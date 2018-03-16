#!/bin/bash

# to get ecs-cli client, go to https://github.com/aws/amazon-ecs-cli

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

CLUSTER_NAME="ecs-cluster"

echo "[*] [$( date +'%H:%M:%S')] configuring profile..."
ecs-cli configure profile --profile-name default --access-key ${AWS_ACCESS_KEY_ID} --secret-key ${AWS_SECRET_ACCESS_KEY}
ecs-cli configure --cluster ${CLUSTER_NAME} --region eu-west-1 --config-name default --default-launch-type EC2
echo "[*] [$( date +'%H:%M:%S')] bring up ec2 instance..."
ecs-cli up --capability-iam --size 1 --instance-type t2.micro
echo "[*] [$( date +'%H:%M:%S')] wait for ec2 instance to be registered... run docker compose..."
sleep 60
ecs-cli compose up
ecs-cli compose ps
ip_address=$( ecs-cli ps | grep RUNNING | head -n1 | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" )
echo "[*] [$( date +'%H:%M:%S')] you can access your instance at http://${ip_address}/..."
echo "[*] [$( date +'%H:%M:%S')] to bring cluster down issue:"
echo "[*] ecs-cli down"
