#!/bin/bash

oracle_sid=$1
oracle_new_sid=$2

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/db_1
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/u01/app/oracle/product/db_1/bin
export NLS_LANG=AMERICAN_AMERICA.EE8MSWIN1250
export NLS_DATE_FORMAT=DD_MON_YYYY_HH24:MI:SS

if [[ -z "${oracle_sid}" ]] || [[ -z "${oracle_new_sid}" ]]
then
        echo "Missing parameters! Usage: $0 ORACLE_SID ORACLE_NEW_SID"
        exit
fi

export ORACLE_SID=${oracle_sid}

echo "shutdown immediate;" | sqlplus / as sysdba
echo "startup mount;" | sqlplus / as sysdba
nid TARGET="sys@${oracle_sid} / as sysdba" DBNAME=${oracle_new_sid} LOGFILE=/home/oracle/rename_db_${oracle_sid}_to_${oracle_new_sid}.log
echo "startup mount;" | sqlplus / as sysdba
echo "alter system set db_name=${oracle_new_sid} scope=spfile;" | sqlplus / as sysdba
cp /u01/app/oracle/product/db_1/dbs/spfile${oracle_sid}.ora /u01/app/oracle/product/db_1/dbs/spfile${oracle_new_sid}.ora
export ORACLE_SID=${oracle_new_sid}
echo "Modify tnsnames!"
echo "startup mount;" | sqlplus / as sysdba
echo "alter database open resetlogs;" | sqlplus / as sysdba
orapwd file=${ORACLE_HOME}/dbs/orapw${oracle_new_sid} password=SYSPASSWORD entries=5 force=y
