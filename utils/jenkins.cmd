#!/bin/bash

# ignored plugins because update breaks it
ignored=""

if [[ -z ${ignored} ]]
then
  ignored="^$"
fi

echo "Listing plugins to update..."

/root/tools/jenkins list-plugins | egrep -v "${ignored}" | egrep "\([0-9\.]*\)"
count=$( /root/tools/jenkins list-plugins | egrep -v "${ignored}" | egrep "\([0-9\.]*\)" | wc -l )

# if it's not fake string
if [[ ${ignored} != "^$" ]]
then
  echo "These plugins are ignored (breaking changes)..."
  echo "${ignored}"
fi

if [[ "${count}" -eq 0 ]]
then
  echo "No plugins to update, exit!"
  exit 0
fi

for plugin in $( /root/tools/jenkins list-plugins | egrep -v "${ignored}" | egrep "\([0-9\.]*\)" | awk ' { print $1 } ' )
do
  echo "Updating ${plugin}..."
  /root/tools/jenkins "install-plugin ${plugin}"
done

/root/tools/jenkins "safe-restart"

# cat /root/tools/jenkins
#!/bin/bash

command=${1}

if [[ -z "${command}" ]]
then
  echo "Usage: ${0} command"
  exit 1
fi

ssh -l <user_login> -p <fixed ssh port>  localhost ${command}

