#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
no_color='\033[0m'

function decho
{
  string=${1}
  echo -e "[$( date +'%H:%M:%S' )] ${string}"
}

function decho_red
{
  string=${1}
  echo -e  "${red}[$( date +'%H:%M:%S' )] ${string}${no_color}"
}

function decho_green
{
  string=${1}
  echo -e "${green}[$( date +'%H:%M:%S' )] ${string}${no_color}"
}

function show_help
{
  echo "usage:  ${0}"
  echo "        -h: show help"
  echo "        -t <target url|source code directory|remote git repository>: specify url/source code directory/repository, must be used with -m"
  echo "        -m <build|scan|source|secrets>: specify mode to run, must be used with -t for all option except 'build'"
  echo "example: "
  echo "        ${0} -m build    : build docker images with tools"
  echo "        ${0} -m scan    -t https://my.example.app.com : scan remote target for known vulnerabilities"
  echo "        ${0} -m source  -t example-app/src : scan local directory with source code for known vulnerable dependencies (js/php)"
  echo "        ${0} -m secrets -t https://github.com/vulnerable/example.git : scan remote repository for commited secrets and sensitive files"
}

function build_image
{
  decho_green "building images"
  cwd=$( pwd )
  debug="" # set to '' to show logs from build process 
  cd dockerfiles
  dwd=$( pwd )
  for dir in $( ls -d */ )
  do
    cd "${dir}"
    # if Dockerfile exists
    if [[ -e "Dockerfile" ]]
    then
      image_name=$( cat Dockerfile  | grep image_name | grep -o '".*"' | sed 's/"//g' )
      decho "building ${image_name}..."
      docker build ${debug} -t ${image_name} -f Dockerfile .
      cd ${dwd}
    fi
  done
  cd ${cwd}
  docker pull owasp/zap2docker-weekly
  docker pull owasp/dependency-check:3.3.2
}

function target_scan
{
  decho_green "scanning target ${target}"
  dns_name=$( echo "${target}" | awk -F[/:] '{print $4}' )
  docker run -i --rm security-tools:nmap nmap -F ${dns_name} | tee .nmap.output
  unusual_ports=$( cat .nmap.output | egrep -i "open" | egrep -v "80|443" | wc -l )
  if [[ ${unusual_ports} -ne 0 ]]
  then
    decho_red "found unusual ports open, application should have only ports 80 and/or 443 open, are you sure these should be exposed?"
    cat .nmap.output | egrep -i "open" | egrep -v "80|443"
  fi
  docker run -i --rm owasp/zap2docker-weekly zap-baseline.py -t ${target} | tee .owasp.zap.output
  docker run -i --rm security-tools:nikto -host ${target} | tee .nikto.output
  nikto_items=$( cat .nikto.output | egrep -i -o "[0-9]+ item\(s\) reported" | egrep -o "[0-9]+" )
  if [[ "${nikto_items}" -ne 0 ]]
  then
    decho_red "nikto found more than 0 items, please review log above!"
  fi
  
}

function source_scan
{
  decho_green "scanning source code in directory ${target}"

  cwd=$( pwd )
  OWASPDC_DIRECTORY="${cwd}/owasp-dependency-check"
  DATA_DIRECTORY="${OWASPDC_DIRECTORY}/data"
  REPORT_DIRECTORY="${OWASPDC_DIRECTORY}/reports"

  if [ ! -d "$DATA_DIRECTORY" ]; then
      echo "Initially creating persistent directories"
      mkdir -p "$DATA_DIRECTORY"
      chmod -R 777 "$DATA_DIRECTORY"

      mkdir -p "$REPORT_DIRECTORY"
      chmod -R 777 "$REPORT_DIRECTORY"
  fi

  docker run --rm \
    --volume ${cwd}/${target}:/src \
    --volume "$DATA_DIRECTORY":/usr/share/dependency-check/data \
    --volume "$REPORT_DIRECTORY":/report \
    owasp/dependency-check:3.3.2 \
    --scan /src \
    --format "ALL" \
    --project "My OWASP Dependency Check Project" \
    --out /report \
    --enableExperimental \
    --enableRetired
}

function secrets_scan
{
  decho_green "scanning repository ${target}"
  docker run -i --rm security-tools:trufflehog ${target}
  docker run -i --rm --name=gitleaks zricethezav/gitleaks -v -r ${target}
}


function parse_args
{
  if [[ -z "${mode}" ]]
  then
    show_help
    exit 1
  fi

  if [[ ! "${mode}" =~ ^(scan|source|secrets|build)$ ]]; then
    decho_red "${mode} mode is not correct choice!"
    show_help
    exit 1
  fi

  if [[ "${mode}" =~ ^(scan|source|secrets)$ ]] && [[ -z "${target}" ]]; then
    decho_red "${mode} mode needs target -t parameter!"
    show_help
    exit 1
  fi

  if [[ "${mode}" == "build" ]]
  then
    build_image
  fi

  if [[ "${mode}" == "scan" ]]
  then
    target_scan
  fi

  if [[ "${mode}" == "source" ]]
  then
    source_scan
  fi

  if [[ "${mode}" == "secrets" ]]
  then
    secrets_scan
  fi

}

function cleanup
{
  rm -f .nmap.output
  rm -f .nikto.output
}

# main

echo "[***] D.I.P. - because sauce is not everything [***]"
echo "[***]   ~Powered by Schibsted Hack Day 2018~   [***]"
echo ""

while getopts "h?t:m:" opt
do
  case "$opt" in
  h)
    show_help
    exit 0
    ;;
  t)  
    target=${OPTARG}
    ;;
  m)
    mode=${OPTARG}
    ;;
  esac
done

parse_args
cleanup
