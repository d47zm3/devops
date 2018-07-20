#!/bin/bash

function decho
{
  string=$1
  echo "[$( date +'%H:%M:%S' )] ${string}"
}

# pass -d for dry-run


project="project"
repository="eu.gcr.io/project"

excluded="important|secret"
todayis=$( date +'%Y-%m-%d' )

decho "[*] Cleaning up Google Cloud Image Registry... day ${todayis}"

if [[ "${1}" == "-d" ]]
then
  decho "[*] THIS IS DRY RUN!"
fi

for image in $( gcloud container images list --repository "${repository}" --format='[no-heading]' | egrep -v "${excluded}")
do
  decho "Purging ${image} repository..."
  gcloud container images list-tags ${image} --sort-by=TIMESTAMP  --format='[box]'
  count=$( gcloud container images list-tags ${image} --sort-by=TIMESTAMP  --format='[no-heading]' | wc -l | xargs)
  decho "[*] Found ${count} images..."
  if [[ ${count} -gt 5 ]]
  then
    decho "[*] Found more than 5 images, purging..."
    difference=$((count-5))
    decho "[*] These images will be PURGED!"
    gcloud container images list-tags ${image} --sort-by=TIMESTAMP  --format='[no-heading]' | head -n ${difference}
    for tag in $( gcloud container images list-tags ${image} --sort-by=TIMESTAMP --format='get(digest)' | head -n ${difference})
    do
      decho "[*] Deleting image ${image}@${tag}..."
      if [[ "${1}" != "-d" ]]
      then
        gcloud container images delete -q --force-delete-tags "${image}@${tag}"
      fi

      if [[ ${?} -ne 0 ]]
      then
        decho "[ERROR] There was an error deleting image ${image}@${tag}, exit!"
        exit 1
      fi
    done
  fi
done
