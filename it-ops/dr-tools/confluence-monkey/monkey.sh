#!/bin/bash

# restoring Confluence backup

# variables

### DIRECTORIES
backup_source=/mnt/backups/
temporary_location=/tmp
destination_directory=/u01/confluence

### MYSQL
mysql_host=localhost
mysql_port=3306
mysql_username=confluence
mysql_password=confluence
mysql_database=confluence


### CONFLUENCE
confluence_username=confluence
confluence_group=confluence
confluence_endpoint="https://confluence-dr-test.company.com/"

### JIRA - to import SSL cert
jira_hostname="jira.company.com"

### GENERAL
java_keystore_password="changeit"
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
    backup_files=$( ls -lt ${backup_source} | grep confluence | awk ' { print $NF } ' | grep files | head -n1 )
    backup_database=$( ls -lt ${backup_source} | grep confluence | awk ' { print $NF } ' | grep database | head -n1 )

    fullpath_backup_files="${backup_source}/${backup_files}"
    fullpath_backup_database="${backup_source}/${backup_database}"
}

function cleanup
{
    decho "Cleanup of old proccesses..."
    confluence_running=$( ps --no-headers -u confluence | wc -l )
    if [[ "${confluence_running}" -ne 0 ]]
    then
            decho "Found running process!"
            $( ps --no-headers -u ${confluence_username} | awk '{ print $1 }' | xargs kill -9 )
    fi

    decho "Wait for process to stop..."
    sleep 10

    ps --no-headers -u confluence
    confluence_running=$( ps --no-headers -u confluence | wc -l )
    if [[ "${confluence_running}" -ne 0 ]]
    then
            decho "[ERROR] Found still running process!"
            ps --no-headers -u ${confluence_username} | awk '{ print $1 }'
            error_code=1
            exit ${error_code}
    fi

    decho "Cleaning up ${destination_directory}"
    rm -rf "${destination_directory}"/*
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

    decho "Checking if group ${confluence_group} exists in system..."
    grep -q "${confluence_group}" /etc/group
    if [[ ${?} -eq 1 ]]
    then
            decho "Group ${confluence_group} does not exist, creating..."
            groupadd ${confluence_group}
    fi

    decho "Checking if user ${confluence_username} exists in system..."
    grep -q "${confluence_username}" /etc/passwd
    if [[ ${?} -eq 1 ]]
    then
            decho "User ${confluence_username} does not exist, creating..."
            useradd ${confluence_username} -g ${confluence_group}
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

function organize_dirs
{
    decho "Organizing dirs..."
    whereis_confluence=$( find "${destination_directory}" -name "start-confluence.sh" | head -n1)
    whereis_confluence=$( dirname "${whereis_confluence}" )
    confluence_dirname=$( basename "${whereis_confluence}" )
    decho "CONFLUENCE directory: ${whereis_confluence}"
}

function move_dirs
{
    decho "Moving..."
    mv "${whereis_confluence}"/* "${destination_directory}"
    whereis_confluence="${destination_directory}"
    decho "CONFLUENCE directory: ${whereis_confluence}"
}

function load_database
{
    decho "Preparing database..."
    mysql -u${mysql_username} -p${mysql_password} -P${mysql_port} -h${mysql_host} -e "drop database if exists ${mysql_database};"
    decho "Re-create database..."
    mysql -u${mysql_username} -p${mysql_password} -P${mysql_port} -h${mysql_host} -e "create database ${mysql_database} CHARACTER SET utf8 COLLATE utf8_polish_ci;"
    decho "Load database..."
    echo "${fullpath_backup_database}"
    mysql -u${mysql_username} -p${mysql_password} -P${mysql_port} -h${mysql_host} ${mysql_database} < "${fullpath_backup_database}"
}

function configure_confluence
{
    decho "Fixing database location..."
    whereis_confluence=/u01/confluence/

    sed -i "s#<property name=\"hibernate.connection.password\">.*</property>#<property name=\"hibernate.connection.password\">${mysql_password}</property>#g" "${whereis_confluence}/home_dir/confluence.cfg.xml"
    sed -i "s#<property name=\"hibernate.connection.url\">jdbc.*</property>#<property name=\"hibernate.connection.url\">jdbc:mysql://${mysql_host}:${mysql_port}/${mysql_database}?sessionVariables=storage_engine%3DInnoDB</property>#g" "${whereis_confluence}/home_dir/confluence.cfg.xml"
    sed -i "s#<property name=\"hibernate.connection.username\">.*</property>#<property name=\"hibernate.connection.username\">${mysql_username}</property>#g" "${whereis_confluence}/home_dir/confluence.cfg.xml"

    decho "Fixing JAVA options..."
    whereis_setenv=$( find ${whereis_confluence} -name "setenv.sh" )   
    java_options="JAVA_OPTS=\"-Xms1024m\
 -Xmx4096m\
 -XX:MaxPermSize=1024m\
 -XX:+UseConcMarkSweepGC\
 $JAVA_OPTS\
 -Dconfluence.html.diff.timeout=300000\
 -Djava.awt.headless=true\
 -Dhttp.proxyHost=proxy.company.com\
 -Dhttp.proxyPort=8080\
 -Dhttps.proxyHost=proxy.company.com\
 -Dhttps.proxyPort=8080\
 -Dhttp.nonProxyHosts=jira.company.com|*.company.com|127.0.0.1|localhost\""

    sed -i "s#^JAVA_OPTS.*#${java_options}#g" "${whereis_setenv}"

    decho "Adding JIRA HTTPS certificate to local keystore..."
    openssl s_client -connect ${jira_hostname}:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > jira_public.crt

    whereis_java=$( which java ) 
    whereis_java=$( dirname $( dirname ${whereis_java} ) ) 
    echo ${whereis_java}
    keystore=$( find ${whereis_java}/ -name cacerts )
    keytool -import -alias jira_${RANDOM} -keystore ${keystore} -storepass ${java_keystore_password} -noprompt -file jira_public.crt
    rm -f jira_public.crt

    decho "Setting up new Confluence homedir..."
    whereis_confluence_init=$( find ${whereis_confluence} -name "confluence-init.properties" )
    sed -i "s#confluence.home=.*#confluence.home=${whereis_confluence}/home_dir#g" "${whereis_confluence_init}"

    decho "Set Confluence user to run with..."
    whereis_user=$( find ${whereis_confluence} -name "user.sh" )
    sed -i "s#CONF_USER.*#CONF_USER=\"${confluence_username}\"#g" ${whereis_user}

    decho "Set permissions..."
    chown -R ${confluence_username}:${confluence_group} ${whereis_confluence}
}

function start_process
{

    whereis_confluence=/u01/confluence/
    decho "Starting Confluence"
    start_script=$( find ${whereis_confluence}/app -name "start-confluence.sh" )
    su - ${confluence_username} -c "${start_script}"
    decho "Wait up to 90 seconds..."
    confluence_log_file=$( find ${whereis_confluence}/app/ -name "catalina.out" )
    timeout 90 tail -f ${confluence_log_file}
}

function verify_restore
{


    whereis_confluence=/u01/confluence/
    decho "Verifying restore..."
    wget -q --no-proxy --no-check-certificate ${confluence_endpoint} -O confluence.test && grep -q "Confluence" confluence.test
    if [[ ${?} -eq 0 ]]
    then
            decho "Webcheck was successful!"
    else
            decho "[ERROR] Webcheck was not successful!"
            error_code=1
    fi
    rm -f confluence.test
    tail -n5000 "${whereis_confluence}/home_dir/logs/atlassian-confluence.log" | grep -q ready 
    if [[ ${?} -eq 0 ]]
    then
            decho "[LOG] $( tail -n5000 "${whereis_confluence}/home_dir/logs/atlassian-confluence.log" | grep ready )"
            decho "Logcheck was successful!"
    else
            decho "[ERROR] Logcheck was not successful!"
            error_code=1
    fi
}

### MAIN

decho "[*] Starting recovery of Confluence process..."
get_files
cleanup
prerequisites
copy_to_temp
unpack
organize_dirs
move_dirs
load_database
configure_confluence
start_process
verify_restore
clean_exit

