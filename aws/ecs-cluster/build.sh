#!/bin/bash

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=

# to get ecs-cli client, go to https://github.com/aws/amazon-ecs-cli
which -s jq
if [[ ${?} -ne 0 ]]
then
  echo "Install jq first! brew install jq"
  exit 1
fi

which -s ecs-cli
if [[ ${?} -ne 0 ]]
then
  echo "Install ecs-cli first! https://github.com/aws/amazon-ecs-cli"
  exit 1
fi

which -s aws
if [[ ${?} -ne 0 ]]
then
  echo "Install aws-cli first! https://docs.aws.amazon.com/cli/latest/userguide/cli-install-macos.html"
  exit 1
fi

cluster_name="ecs-medium"
# where cluster will store logs, can take name off cluster or application
log_group_name="${cluster_name}-log-group"
region="eu-west-2"
# keypair if you want to SSH into instances
keypair="d47zm3"
service_name="${cluster_name}-service"

# on what port on container your application listens
target_port=80

# on what port will loadbalancer listen
listener_port=80

# how container (task) should be named in ecs, web, api, proxy?
container_name="web"

name="ECSExample"
vpc_name="${name} VPC"

profile_name="ecs-example"
loadbalancer_name="${cluster_name}-loadbalancer"
loadbalancer_targets_name="${cluster_name}-targets"

role_name="ECSExampleRole"
tier_class="t2.small"

availability_zone_1="eu-west-2a"
availability_zone_2="eu-west-2b"

subnet_name_1="${name} Subnet 1"
subnet_name_2="${name} Subnet 2"

gateway_name="${name} Gateway"
route_table_name="${name} Route Table"
security_group_name="${name} Security Group"
vpc_cidr_block="10.0.0.0/16"
subnet_cidr_block_1="10.0.1.0/24"
subnet_cidr_block_2="10.0.2.0/24"

# allow traffic on these ports from anywhere
port_cidr_block_22="0.0.0.0/0"
port_cidr_block_80="0.0.0.0/0"
port_cidr_block_443="0.0.0.0/0"

# allow traffic out anywhere
destination_cidr_block="0.0.0.0/0"

# creating VPC part comes from here! https://medium.com/@brad.simonin/create-an-aws-vpc-and-subnet-using-the-aws-cli-and-bash-a92af4d2e54b
# it was modified to support multiple ports/zones

echo "[*] [$( date +'%H:%M:%S')] Creating VPC..."
aws_response=$(aws --region ${region} ec2 create-vpc  --cidr-block "$vpc_cidr_block"  --output json)
vpc_id=$(echo -e "$aws_response" |  jq '.Vpc.VpcId' | tr -d '"')
aws --region ${region} ec2 create-tags  --resources "${vpc_id}" --tags Key=Name,Value="${vpc_name}"
modify_response=$(aws --region ${region} ec2 modify-vpc-attribute --vpc-id "${vpc_id}" --enable-dns-support "{\"Value\":true}")
modify_response=$(aws --region ${region} ec2 modify-vpc-attribute --vpc-id "${vpc_id}" --enable-dns-hostnames "{\"Value\":true}")
gateway_response=$(aws --region ${region} ec2 create-internet-gateway --output json)
gateway_id=$(echo -e "${gateway_response}" |  jq '.InternetGateway.InternetGatewayId' | tr -d '"')
aws --region ${region} ec2 create-tags --resources "${gateway_id}" --tags Key=Name,Value="${gateway_name}"
attach_response=$(aws --region ${region} ec2 attach-internet-gateway --internet-gateway-id "${gateway_id}" --vpc-id "${vpc_id}")

subnet_response_1=$(aws --region ${region} ec2 create-subnet --cidr-block "${subnet_cidr_block_1}" --availability-zone "${availability_zone_1}" --vpc-id "${vpc_id}"  --output json)
subnet_id_1=$(echo -e "$subnet_response_1" |  jq '.Subnet.SubnetId' | tr -d '"')
aws --region ${region} ec2 create-tags --resources "${subnet_id_1}" --tags Key=Name,Value="${subnet_name_1}"
modify_response=$(aws --region ${region} ec2 modify-subnet-attribute --subnet-id "${subnet_id_1}" --map-public-ip-on-launch)

subnet_response_2=$(aws --region ${region} ec2 create-subnet --cidr-block "${subnet_cidr_block_2}" --availability-zone "${availability_zone_2}" --vpc-id "${vpc_id}"  --output json)
subnet_id_2=$(echo -e "${subnet_response_2}" |  jq '.Subnet.SubnetId' | tr -d '"')
aws --region ${region} ec2 create-tags --resources "${subnet_id_2}" --tags Key=Name,Value="${subnet_name_2}"
modify_response=$(aws --region ${region} ec2 modify-subnet-attribute --subnet-id "${subnet_id_2}" --map-public-ip-on-launch)

security_response=$(aws --region ${region} ec2 create-security-group  --group-name "${security_group_name}"  --description "Private: ${security_group_name}"  --vpc-id "${vpc_id}" --output json)
group_id=$(echo -e "${security_response}" |  jq '.GroupId' | tr -d '"')
aws --region ${region} ec2 create-tags --resources "${group_id}" --tags Key=Name,Value="${security_group_name}"

# enable port 22,80,443
security_response_1=$(aws --region ${region} ec2 authorize-security-group-ingress --group-id "${group_id}" --protocol tcp --port 22 --cidr "$port_cidr_block_22")
security_response_2=$(aws --region ${region} ec2 authorize-security-group-ingress --group-id "${group_id}" --protocol tcp --port 80 --cidr "$port_cidr_block_80")
security_response_3=$(aws --region ${region} ec2 authorize-security-group-ingress --group-id "${group_id}" --protocol tcp --port 443 --cidr "$port_cidr_block_443")

# authorize traffic from same security group (registering ecs)
security_response4=$(aws --region ${region} ec2 authorize-security-group-ingress --group-id "${group_id}" --protocol tcp --port 0-65535 --source-group ${group_id})

route_table_response=$(aws --region ${region} ec2 create-route-table --vpc-id "${vpc_id}" --output json)
route_table_id=$(echo -e "${route_table_response}" | jq '.RouteTable.RouteTableId' | tr -d '"')
aws --region ${region} ec2 create-tags --resources "${route_table_id}"  --tags Key=Name,Value="${route_table_name}"

#add route for the internet gateway
route_response=$(aws --region ${region} ec2 create-route  --route-table-id "${route_table_id}"  --destination-cidr-block "${destination_cidr_block}"  --gateway-id "${gateway_id}")
associate_response_1=$(aws --region ${region} ec2 associate-route-table --subnet-id "${subnet_id_1}" --route-table-id "${route_table_id}")
associate_response_2=$(aws --region ${region} ec2 associate-route-table --subnet-id "${subnet_id_2}" --route-table-id "${route_table_id}")
echo " "
echo "[*] [$( date +'%H:%M:%S')] VPC created, VPC ID: ${vpc_id}"
echo "[*] [$( date +'%H:%M:%S')] Use Subnet ID $subnet_id_1 and $subnet_id_2, for Security Group ID ${group_id}"
echo "[*] [$( date +'%H:%M:%S')] AWS resources will be created in $region, and in these AZs: $availability_zone_1, $availability_zone_2"

echo "[*] [$( date +'%H:%M:%S')] Dumping values for future usage to ecs.values file..."
echo "vpc_id=${vpc_id}" > ecs.values
echo "region=$region" >> ecs.values
echo "subnet_id_1=$subnet_id_1" >> ecs.values
echo "subnet_id_2=$subnet_id_2" >> ecs.values
echo "group_id=${group_id}" >> ecs.values

echo "[*] [$( date +'%H:%M:%S')] Creating IAM role for ECS instances... (gives you possibility to use your ECR - AWS private registry for example"
create_role_response=$( aws iam create-role --role-name ${role_name} --assume-role-policy-document file://ecs-policy.json --description "ECS Cluster default role" )
put_role_policy_response=$( aws iam put-role-policy --role-name ${role_name} --policy-name ecsMediumRolePolicy --policy-document file://ecs-role.json ) 

create_instance_profile_response=$( aws iam create-instance-profile --instance-profile-name ecsInstanceProfileMedium )
add_role_to_instance_response=$( aws iam add-role-to-instance-profile --instance-profile-name ecsInstanceProfileMedium --role-name ${role_name} )

echo "[*] [$( date +'%H:%M:%S')] Configure ECS profile..."
ecs-cli configure profile --profile-name ${profile_name} --access-key ${AWS_ACCESS_KEY_ID} --secret-key ${AWS_SECRET_ACCESS_KEY}

echo "[*] [$( date +'%H:%M:%S')] Configure ECS cluster before launch..."
ecs-cli configure --cluster ${cluster_name} --region ${region} --config-name ${profile_name} --default-launch-type EC2

echo "[*] [$( date +'%H:%M:%S')] Bring up EC2 instance..."
# bring up cluster
ecs-cli up  --size 2 --instance-type ${tier_class} --vpc ${vpc_id} --cluster-config ${profile_name} --subnets ${subnet_id_1},${subnet_id_2} --security-group ${group_id} --instance-role ${role_name} --keypair ${keypair} --ecs-profile ${profile_name}

echo "[*] [$( date +'%H:%M:%S')] Wait until EC2 instances are registered..."
sleep 60

echo "[*] [$( date +'%H:%M:%S')] Create Application Load Balancer in chosen subnets..."
alb_response=$( aws elbv2 --region  ${region} create-load-balancer --name ${loadbalancer_name} --subnets ${subnet_id_1} ${subnet_id_2} --security-groups ${group_id} )
alb_arn=$( echo -e "${alb_response}" |  jq '.LoadBalancers[] | .LoadBalancerArn' | tr -d '"' )
alb_dnsname=$( echo -e "${alb_response}" |  jq '.LoadBalancers[] | .DNSName' | tr -d '"')

echo "[*] [$( date +'%H:%M:%S')] Create Target Group for ECS instances (targeting port ${target_port})..."
target_group_response=$( aws elbv2 --region ${region} create-target-group --name ${loadbalancer_targets_name} --protocol HTTP --port ${target_port} --vpc-id ${vpc_id} )
target_group_arn=$( echo -e "${target_group_response}" |  jq '.TargetGroups[] | .TargetGroupArn' | tr -d '"' )

echo "[*] [$( date +'%H:%M:%S')] Create Listener that will forward traffic to registered instances..."
listener_response=$( aws elbv2 --region ${region} create-listener --load-balancer-arn ${alb_arn}  --protocol HTTP --port ${listener_port}  --default-actions Type=forward,TargetGroupArn=${target_group_arn} )

echo "[*] [$( date +'%H:%M:%S')] Create Service in ECS cluster using created Target Group..."
ecs-cli compose --verbose --file docker-compose.yml --cluster-config ${profile_name}  --project-name ${service_name}  service up --create-log-groups --container-name ${container_name} --container-port ${target_port} --target-group-arn ${target_group_arn} 

echo "[*] [$( date +'%H:%M:%S')] Scale Service to 2 replicas..."
ecs-cli compose --verbose --file docker-compose.yml --cluster-config ${profile_name} --project-name ${service_name} service scale 2

echo "[*] [$( date +'%H:%M:%S')] Finished! Reach your service at ${alb_dnsname} !"
