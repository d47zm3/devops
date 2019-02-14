#!/bin/bash

# restoring GERRIT backup

# variables

### DIRECTORIES
backup_source=/mnt/backups_git/
temporary_location=/tmp
destination_directory=/u01/gerrit_disaster_recovery

### MYSQL
mysql_host=localhost
mysql_port=3306
mysql_username=gerrit
mysql_password=gerrit
mysql_database=gerrit

### GERRIT
gerrit_project=$1
gerrit_username=gerrit
gerrit_group=gerrit
gerrit_endpoint="http://gerrit-dr-test.company.com/"

### GENERAL
error_code=0

# tracking time
SECONDS=0

### FUNCTIONS

function decho
{
        string=$1
        echo "[$( date +'%H:%M:%S' )] ${string}"
}

function get_files
{
        backup_files=$( ls -lt ${backup_source} | grep ${gerrit_project} | awk ' { print $NF } ' | grep files | head -n1 )
        backup_database=$( ls -lt ${backup_source} | grep ${gerrit_project} | awk ' { print $NF } ' | grep database | head -n1 )

        fullpath_backup_files="${backup_source}/${backup_files}"
        fullpath_backup_database="${backup_source}/${backup_database}"
}

function prerequisites
{
        decho "Filesystem BACKUP: ${backup_files}"
        decho "Database BACKUP: ${backup_database}"
        decho "Checking if destination ${destination_directory} exists..."
        if [[ ! -d "${destination_directory}" ]]
        then
                decho "Destination does not exist, creating..."
                mkdir -p "${destination_directory}"
        fi

        decho "Checking if group ${gerrit_group} exists in system..."
        grep -q "${gerrit_group}" /etc/group
        if [[ ${?} -eq 1 ]]
        then
                decho "Group ${gerrit_group} does not exist, creating..."
                groupadd ${gerrit_group}
        fi

        decho "Checking if user ${gerrit_username} exists in system..."
        grep -q "${gerrit_username}" /etc/passwd
        if [[ ${?} -eq 1 ]]
        then
                decho "User ${gerrit_username} does not exist, creating..."
                useradd ${gerrit_username} -g ${gerrit_group}
        fi
}

function unpack
{
        decho "Checking if backup needs uncompressing..."
        file ${fullpath_backup_files} | grep -q gzip
        if [[ ${?} -eq 0 ]]
        then
                decho "Uncompressing ${fullpath_backup_files}"
                gunzip -f "${fullpath_backup_files}"
                backup_files=$( ls -lt "${temporary_location}" | grep "${gerrit_project}" | awk ' { print $NF } ' | grep files | head -n1 )
                fullpath_backup_files="${temporary_location}/${backup_files}"
        fi

        file ${fullpath_backup_database} | grep -q gzip
        if [[ ${?} -eq 0 ]]
        then
                decho "Uncompressing ${fullpath_backup_database}"
                gunzip -f "${fullpath_backup_database}"
                backup_database=$( ls -lt "${temporary_location}" | grep "${gerrit_project}" | awk ' { print $NF } ' | grep database | head -n1 )
                fullpath_backup_database="${temporary_location}/${backup_database}"
        fi

        decho "Unpacking files..."
        tar xf "${fullpath_backup_files}" -C "${destination_directory}"
}

function copy_to_temp
{
        decho "Copying backup files to ${temporary_location}..."
        cp "${fullpath_backup_files}" "${temporary_location}"
        cp "${fullpath_backup_database}" "${temporary_location}"

        fullpath_backup_files="${temporary_location}/${backup_files}"
        fullpath_backup_database="${temporary_location}/${backup_database}"
}

function clean_exit
{
        decho "Cleanup..."
        if [[ "${error_code}" -eq 0 ]]
        then
                decho "RESTORE HAS SUCCEDDED [!]"
        else
                decho "RESTORE HAS FAILED [!]"
        fi
        duration=$SECONDS
        decho "Restore took $(($duration / 60)) minutes and $(($duration % 60)) seconds."
        rm -f "${fullpath_backup_database}"
        rm -f "${fullpath_backup_files}"
        rm -rf "${destination_directory}/*"
        rm -f ./index.html*

        exit ${error_code}
}

function verify_restore
{
        decho "Verifying restore..."
        wget -q -H --no-proxy "${gerrit_endpoint}" --user=gerrit --password=gerrit
        if [[ ${?} -eq 0 ]]
        then
                decho "Webcheck was successful!"
        else
                decho "[ERROR] Webcheck was not successful!"
                error_code=1
        fi

        tail -n10 "${whereis_gerrit}/logs/error_log" | grep -q ready 
        if [[ ${?} -eq 0 ]]
        then
                decho "[LOG] $( tail -n10 "${whereis_gerrit}/logs/error_log" | grep ready )"
                decho "Logcheck was successful!"
        else
                decho "[ERROR] Logcheck was not successful!"
                error_code=1
        fi
}

function organize_dirs
{
        decho "Organizing dirs..."
        whereis_gerrit=$( find "${destination_directory}" -name "gerrit.sh" )
        whereis_gerrit=$( dirname "${whereis_gerrit}" )
        whereis_gerrit=$( dirname "${whereis_gerrit}" )
        decho "GERRIT directory: ${whereis_gerrit}"
        gerrit_dirname=$( basename "${whereis_gerrit}" )

        whereis_git=$( find "${destination_directory}" -name "All-Projects.git" )
        whereis_git=$( dirname "${whereis_git}" )
        git_dirname=$( basename "${whereis_git}" )

        decho "GERRIT directory: ${whereis_gerrit}"
        decho "GIT directory: ${whereis_git}"
}

function move_dirs
{
        decho "Moving..."
        mv "${whereis_git}" "${destination_directory}"
        mv "${whereis_gerrit}" "${destination_directory}"
        whereis_gerrit="${destination_directory}/${gerrit_dirname}"
        whereis_git="${destination_directory}/${git_dirname}"

        decho "GERRIT directory: ${whereis_gerrit}"
        decho "GIT directory: ${whereis_git}"
}

function cleanup
{
    decho "Cleanup of old proccesses..."
    gerrit_running=$( ps --no-headers -u ${gerrit_username} | wc -l )
    if [[ "${gerrit_running}" -ne 0 ]]
    then
            decho "Found running process!"
            $( ps --no-headers -u ${gerrit_username} | awk '{ print $1 }' | xargs kill -9 )
    fi

    decho "Cleaning up ${destination_directory}"
    rm -rf "${destination_directory}"/*
}

function load_database
{
        decho "Preparing database..."
        mysql -u${mysql_username} -p${mysql_password} -P${mysql_port} -h${mysql_host} -e "drop database if exists ${mysql_database};"
        decho "Re-create database..."
        mysql -u${mysql_username} -p${mysql_password} -P${mysql_port} -h${mysql_host} -e "create database ${mysql_database} CHARACTER SET utf8 COLLATE utf8_general_ci;"
        decho "Load database..."
        mysql -u${mysql_username} -p${mysql_password} -P${mysql_port} -h${mysql_host} ${mysql_database} < "${fullpath_backup_database}"
}

function configure_gerrit
{
        decho "Setting up gerrit.config..."
        sed -i "s/hostname = .*/hostname = ${mysql_host}/g" "${whereis_gerrit}/etc/gerrit.config"
        sed -i "s/port = .*/port = ${mysql_port}/g" "${whereis_gerrit}/etc/gerrit.config"
        sed -i "s/database = .*/database = ${mysql_database}/g" "${whereis_gerrit}/etc/gerrit.config"
        sed -i "s/username = .*/username = ${mysql_username}/g" "${whereis_gerrit}/etc/gerrit.config"
        sed -i "s#basePath = .*#basePath = ${whereis_git}#g" "${whereis_gerrit}/etc/gerrit.config"
        sed -i "s#canonicalWebUrl = .*#canonicalWebUrl = ${gerrit_endpoint}#g" "${whereis_gerrit}/etc/gerrit.config"
        sed -i "s#listenUrl =.*#listenUrl = proxy-http://*:8080/#g" "${whereis_gerrit}/etc/gerrit.config"
        sed -i "s/password = .*/password = ${mysql_password}/g" "${whereis_gerrit}/etc/secure.config"

        decho "Setting up permissions..."
        chown ${gerrit_username}:${gerrit_group} -R "${whereis_gerrit}"
        chown ${gerrit_username}:${gerrit_group} -R "${whereis_git}"

        decho "Clearing log file..."
        echo "" > "${whereis_gerrit}/logs/error_log"
}

function start_process
{
        decho "Starting GERRIT..."
        ${whereis_gerrit}/bin/gerrit.sh start

        if [[ ${?} -ne 0 ]]
        then
                decho "GERRIT could not start!"
                exit 1
        fi

        decho "Wait for GERRIT to get up..."
        sleep 10
}

### MAIN

if [[ -z "${gerrit_project}" ]]
then
        echo "Usage: ./${0} <PROJECTNAME> - make sure rest of parameters is set inside script"
        exit 1
fi

set -u

decho "[${gerrit_project^^}] Starting recovery of GERRIT/GIT repository process..."
get_files
cleanup
prerequisites
copy_to_temp
unpack
organize_dirs
move_dirs
load_database
configure_gerrit
start_process
verify_restore
clean_exit
