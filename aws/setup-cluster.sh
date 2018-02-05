#!/bin/bash

USER=
GROUP=
CLUSTER=

function decho
{
  string=$1
  echo "[$( date +'%H:%M:%S' )] ${string}"
}

decho "Make bucket for KOPS state store..."
aws s3 mb s3://kops-${CLUSTER}

decho "Make IAM group for KOPS..."
aws iam create-group --group-name ${GROUP}

export arns="
arn:aws:iam::aws:policy/AmazonEC2FullAccess
arn:aws:iam::aws:policy/AmazonRoute53FullAccess
arn:aws:iam::aws:policy/AmazonS3FullAccess
arn:aws:iam::aws:policy/IAMFullAccess
arn:aws:iam::aws:policy/AmazonVPCFullAccess"

decho "Attach right policies to IAM group..."
for arn in $arns; do aws iam attach-group-policy --policy-arn "$arn" --group-name ${GROUP}; done

decho "Create IAM user..."
aws iam create-user --user-name ${USER}

decho "Add IAM user to KOPS group..."
aws iam add-user-to-group --user-name ${USER} --group-name ${GROUP}

decho "Create Access Key for IAM user..."
aws iam create-access-key --user-name ${USER}
