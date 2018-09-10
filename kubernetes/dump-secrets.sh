#!/bin/bash

# dump all values from installed releases using helm and encrypt them

# local production context name
context_name="production"
secrets_path="secrets/"

kube="kubectl --context ${context_name}"
helm="helm --kube-context ${context_name}"

if [ -L $0 ] ; then
    DIR=$(dirname $(readlink -f $0)) ;
else
    DIR=$(dirname $0) ;
fi ;

cd ${DIR}/../../

for release in $( ${helm} ls | grep -i "DEPLOYED" | awk ' { print $1 } ' )
do
  echo "[*] Updating values for ${release} release..."
  ${helm} get values -a "${release}" > "${secrets_path}/${release}/secrets.yaml"
  sops -i -e "${secrets_path}/${release}/secrets.yaml"
done

# small test to ensure everything works
sops -i -d "${secrets_path}/addons/secrets.yaml"
grep -i -q "loadBalancerIP: 1.1.1.1" "${secrets_path}/addons/secrets.yaml"
if [[ ${?} -eq 0 ]]
then
  echo "[*] OK, test passed!"
fi

sops -i -e "${secrets_path}/addons/secrets.yaml"
