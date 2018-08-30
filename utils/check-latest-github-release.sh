#!/bin/bash

repo_name=${1}
current_version=${2}

if [[ -z ${repo_name} ]] || [[ -z ${current_version} ]]
then
  echo "[*] repository name and current version required, usage: ${0} <repository name> <current version>"
  exit 1
fi

get_latest_release() {
  curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                            # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                    # Pluck JSON value
}

latest=$( get_latest_release "${repo_name}" )

if [[ "${current_version}" != "${latest}" ]]
then
  echo "[*] ${repo_name} is not is latest version, latest one is ${latest} and installed is ${current_version}!"
  exit 1
else
  echo "[*] ${repo_name} is in latest version!"
fi
