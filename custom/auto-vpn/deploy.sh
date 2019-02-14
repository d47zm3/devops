#!/bin/bash

function decho
{
  string=$1
  echo "[$( date +'%H:%M:%S' )] ${string}"
}

action=${1}

if [[ -z "${action}" ]] || ( [[ ${action} != "create" ]] && [[ ${action} != "destroy" ]] && [[ ${action} != "status" ]] )
then
  decho "[error] usage: ${0} <create|destroy|status> - remember to update vars.sh before!"
fi

if [[ ! -f "vars.sh" ]]
then
  decho "[error] vars.sh file not found!"
  exit 1
fi

. vars.sh
. providers/${provider}.sh ${action}
