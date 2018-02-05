#!/bin/bash

USER=
GROUP=
CLUSTER=

function decho
{
  string=$1
  echo "[$( date +'%H:%M:%S' )] ${string}"
}

decho "Remove IAM user from group..."
aws iam remove-user-from-group --user-name ${USER} --group-name ${GROUP}

decho "Delete IAM user..."
aws iam delete-user --user-name ${USER}

decho "Delete IAM group..."
aws iam delete-group --group-name ${GROUP}

decho "Remove Bucket..."
aws s3 rb s3://kops-${CLUSTER}
