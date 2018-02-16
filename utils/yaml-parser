#!/bin/bash

# sudo pip install PyYAML - requirement

path=${1}
if [[ -z "${path}" ]]
then
  echo "please provide path to yaml file!"
  exit 1
fi

python -c "from yaml import load, Loader; load(open('${path}'), Loader=Loader)"
if [[ ${?} -eq 0 ]]
then
  echo "ok!"
fi
