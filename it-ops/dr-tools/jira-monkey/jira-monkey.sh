#!/bin/bash

# restoring JIRA backup

# variables

### DIRECTORIES
backup_source=/mnt/backup
destination_directory=/home/jira

### MYSQL
mysql_host=localhost
mysql_port=3306
mysql_username=jira
mysql_password=password
mysql_database=jira


### JIRA
jira_username=jira
jira_group=jira
jira_endpoint="https://jira-poland-dr.company.com"

### CONFLUENCE
confluence_hostname="confluence.company.com"

### SVN 
svn_hostname="svn-poland.company.com"

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
    backup_files=$( ls -lt ${backup_source} | grep jira | awk ' { print $NF } ' | grep files | head -n1 )
    backup_database=$( ls -lt ${backup_source} | grep jira | awk ' { print $NF } ' | grep database | head -n1 )

    fullpath_backup_files="${backup_source}/${backup_files}"
    fullpath_backup_database="${backup_source}/${backup_database}"
}

function cleanup
{
    decho "Cleanup of old proccesses..."
    jira_running=$( ps --no-headers -u jira | wc -l )
    if [[ "${jira_running}" -ne 0 ]]
    then
            decho "Found running process!"
            ps --no-headers -u ${jira_username} | awk '{ print $1 }' | xargs kill -9 
    fi

    decho "Wait for process to stop..."
    sleep 10

    ps --no-headers -u jira 
    jira_running=$( ps --no-headers -u jira | wc -l )
    if [[ "${jira_running}" -ne 0 ]]
    then
            decho "[ERROR] Found still running process!"
            ps --no-headers -u ${jira_username} | awk '{ print $1 }' 
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

    decho "Checking if group ${jira_group} exists in system..."
    grep -q "${jira_group}" /etc/group
    if [[ ${?} -eq 1 ]]
    then
            decho "Group ${jira_group} does not exist, creating..."
            groupadd ${jira_group}
    fi

    decho "Checking if user ${jira_username} exists in system..."
    grep -q "${jira_username}" /etc/passwd
    if [[ ${?} -eq 1 ]]
    then
            decho "User ${jira_username} does not exist, creating..."
            useradd ${jira_username} -g ${jira_group}
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

            backup_files=$( ls -lt ${backup_source} | grep jira | awk ' { print $NF } ' | grep files | head -n1 )
            fullpath_backup_files="${backup_source}/${backup_files}"
    fi

    file ${fullpath_backup_database} | grep -q gzip
    if [[ ${?} -eq 0 ]]
    then
            decho "Uncompressing ${fullpath_backup_database}"
            gunzip -f "${fullpath_backup_database}"

            backup_database=$( ls -lt ${backup_source} | grep jira | awk ' { print $NF } ' | grep database | head -n1 )
            fullpath_backup_database="${backup_source}/${backup_database}"
    fi

    decho "Unpacking files..."
    tar xf "${fullpath_backup_files}" -C "${destination_directory}"
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
    whereis_jira=$( find "${destination_directory}" -name "start-jira.sh" | head -n1)
    whereis_jira=$( dirname "${whereis_jira}" )
    whereis_jira=$( dirname "${whereis_jira}" )
    whereis_jira=$( dirname "${whereis_jira}" )
    jira_dirname=$( basename "${whereis_jira}" )
    decho "JIRA directory: ${whereis_jira}"
}

function move_dirs
{
    decho "Moving..."
    mv "${whereis_jira}"/* "${destination_directory}"
    whereis_jira="${destination_directory}"
    decho "JIRA directory: ${whereis_jira}"
}

function load_database
{
    decho "Preparing database..."
    mysql -u${mysql_username} -p${mysql_password} -P${mysql_port} -h${mysql_host} -e "drop database if exists ${mysql_database};"
    decho "Re-create database..."
    mysql -u${mysql_username} -p${mysql_password} -P${mysql_port} -h${mysql_host} -e "create database ${mysql_database} CHARACTER SET utf8 COLLATE utf8_polish_ci;"
    decho "Load database..."
    decho "${fullpath_backup_database}"
    mysql -u${mysql_username} -p${mysql_password} -P${mysql_port} -h${mysql_host} ${mysql_database} < "${fullpath_backup_database}"
}

function configure_jira
{
    decho "Fixing database location..."

    sed -i -e "s,<url>.*</url>,<url>jdbc:mysql://${mysql_host}:${mysql_port}/${mysql_database}?autoReconnect=true\&amp;useUnicode=true\&amp;characterEncoding=UTF8\&amp;sessionVariables=storage_engine=InnoDB</url>," "${whereis_jira}/home_dir/dbconfig.xml"
    sed -i "s#<username>.*</username>#<username>${mysql_username}</username>#g" "${whereis_jira}/home_dir/dbconfig.xml"
    sed -i "s#<password>.*</password>#<password>${mysql_password}</password>#g" "${whereis_jira}/home_dir/dbconfig.xml"

    decho "Fixing JAVA options..."
    whereis_setenv=$( find ${whereis_jira} -name "setenv.sh" )   
    jvm_options="JVM_SUPPORT_RECOMMENDED_ARGS=\"-Dhttp.proxyHost=proxy.gdynia.asseco.pl \
-Dhttp.proxyPort=8080 \
-Dfile.encoding=UTF8 \
-Dhttp.nonProxyHosts=*.company.com|127.0.0.1|localhost|*.company.com\""

    jvm_min_mem="JVM_MINIMUM_MEMORY=\"2192m\""
    jvm_max_mem="JVM_MAXIMUM_MEMORY=\"4384m\""


    sed -i "s#^JVM_SUPPORT_RECOMMENDED_ARGS.*#${jvm_options}#g" "${whereis_setenv}"
    sed -i "s#^JVM_MINIMUM_MEMORY.*#${jvm_min_mem}#g" "${whereis_setenv}"
    sed -i "s#^JVM_MAXIMUM_MEMORY.*#${jvm_max_mem}#g" "${whereis_setenv}"

    decho "Adding Confluence HTTPS certificate to local keystore..."
    openssl s_client -connect ${confluence_hostname}:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > confluence_public.crt

    whereis_java=$( which java ) 
    whereis_java=$( dirname $( dirname ${whereis_java} ) ) 
    echo ${whereis_java}
    keystore=$( find ${whereis_java}/ -name cacerts )
    keytool -import -alias confluence_${RANDOM} -keystore ${keystore} -storepass ${java_keystore_password} -noprompt -file confluence_public.crt
    rm -f confluence_public.crt

    decho "Adding SVN HTTPS certificate to local keystore..."
    openssl s_client -connect ${svn_hostname}:443 < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > svn_public.crt

    whereis_java=$( which java ) 
    whereis_java=$( dirname $( dirname ${whereis_java} ) ) 
    echo ${whereis_java}
    keystore=$( find ${whereis_java}/ -name cacerts )
    keytool -import -alias svn_${RANDOM} -keystore ${keystore} -storepass ${java_keystore_password} -noprompt -file svn_public.crt
    rm -f svn_public.crt


    decho "Setting up new JIRA homedir..."
    whereis_jira_init=$( find ${whereis_jira} -name "jira-application.properties" )
    sed -i "s#jira.home=.*#jira.home=${whereis_jira}/home_dir#g" "${whereis_jira_init}"

    decho "Set JIRA user to run with..."
    whereis_user=$( find ${whereis_jira} -name "user.sh" )
    sed -i "s#JIRA_USER.*#JIRA_USER=\"${jira_username}\"#g" ${whereis_user}

    decho "Set permissions..."
    chown -R ${jira_username}:${jira_group} ${whereis_jira}
}

function start_process
{
    decho "Starting JIRA"
    cd ${whereis_jira}
    start_script=$( find ${whereis_jira}/ -name "start-jira.sh" )
    su - ${jira_user} -c "cd ${whereis_jira}; ${start_script}"
    decho "Wait up to 90 seconds..."
    jira_log_file=$( find ${whereis_jira}/ -name "catalina.out" )
    timeout 90 tail -f ${jira_log_file}
}

function verify_restore
{

    whereis_jira=/home/jira
    decho "Verifying restore..."
    wget -q --no-proxy --no-check-certificate ${jira_endpoint} -O jira.test && grep -q "JIRA PUK" jira.test
    if [[ ${?} -eq 0 ]]
    then
            decho "Webcheck was successful!"
    else
            decho "[ERROR] Webcheck was not successful!"
            error_code=1
    fi
    #rm -f jira.test
    tail -n5000 "${whereis_jira}/home_dir/log/atlassian-jira.log" | grep -q ready 
    if [[ ${?} -eq 0 ]]
    then
            decho "[LOG] $( tail -n5000 "${whereis_jira}/home_dir/log/atlassian-jira.log" | grep ready )"
            decho "Logcheck was successful!"
    else
            decho "[ERROR] Logcheck was not successful!"
            error_code=1
    fi
}

### MAIN

decho "[*] Starting recovery of JIRA process..."
get_files
cleanup
prerequisites
unpack
organize_dirs
move_dirs
load_database
configure_jira
start_process
verify_restore
clean_exit
