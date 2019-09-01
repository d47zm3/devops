#!/usr/bin/env bash

for pod in $( kubectl get pods | grep -v NAME | awk ' { print $1 } ' )
do
  echo $pod
  kubectl get pod $pod -o json | jq '.spec.containers[].resources.requests.cpu'
  kubectl get pod $pod -o json | jq '.spec.containers[].resources.requests.memory'
done
