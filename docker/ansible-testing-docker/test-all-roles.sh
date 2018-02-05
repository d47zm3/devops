#!/bin/bash

function decho
{
		string=$1
    echo "[$( date +'%H:%M:%S' )] ${string}"
}

# test all ansible roles on chosen distributions and present results

. ./env.sh
cd ${git_repo_testing_path} 

exit_code=0

for role in $( ls ${git_repo_roles_path} | grep -v README )
do
	for container_os in "${container_distributions[@]}"
	do
		decho "Testing Role ${role} on OS ${container_os}"
		./full-run.sh "${role}" "${container_os}"
		result=$?
		if [[ "${result}" -ne 0 ]]
		then
			exit_code=1
		fi
	done
done

if [[ "${exit_code}" -ne 0 ]]
then
	decho "[FAILURE] Detected error while testing Ansible playbooks, please review log file!"
fi
exit ${exit_code}
