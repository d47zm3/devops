#!/bin/bash

oracle_sid=$1
backup_location=$2

oracle_base=/u01/app/oracle
oracle_home=/u01/app/oracle/product/db_1
path=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:${oracle_home}/bin
nls_lang=AMERICAN_AMERICA.EE8MSWIN1250
nls_date_format=DD_MON_YYYY_HH24:MI:SS

grid_profile_script=/home/oracle/.grid_profile

export ORACLE_BASE=${oracle_base}
export ORACLE_HOME=${oracle_home}
export PATH=${path}
export NLS_LANG=${nls_lang}
export NLS_DATE_FORMAT=${nls_date_format}

if [[ -z "${oracle_sid}" ]] || [[ -z "${backup_location}" ]]
then
	echo "Missing parameters! Usage: $0 ORACLE_SID BACKUP_LOCATION"
	exit
fi

cfname=""
error=0

function get_controlfile
{
	cfname=$(ls -alt ${backup_location} | grep cf_c | tail -n1 | awk '{ print $NF }')
	if [[ -z "${cfname// }" ]]
	then
		echo "Error! Could not find Control File!"
		exit 1
	fi
}

function prepare_rman_restore
{
cat > /home/oracle/restore_${oracle_sid}.01.rman << EOF
startup nomount force;
restore controlfile from '${backup_location}/${cfname}';
restore spfile from '${backup_location}/${cfname}';
exit;
EOF

cat > /home/oracle/restore_${oracle_sid}.02.rman << EOF
restore controlfile from '${backup_location}/${cfname}';
exit;
EOF

cat > /home/oracle/restore_${oracle_sid}.03.rman << EOF
catalog start with '${backup_location}' noprompt;
exit;
EOF


}

function prepare_sql_restore
{
cat > /home/oracle/restore_${oracle_sid}.01.sql << EOF
create pfile='/home/oracle/${oracle_sid}.pfile' from spfile;
shutdown immediate;
exit;
EOF

cat > /home/oracle/restore_${oracle_sid}.02.sql << EOF
create spfile from pfile='/home/oracle/${oracle_sid}.pfile';
exit;
EOF

cat > /home/oracle/restore_${oracle_sid}.03.sql << EOF
startup nomount;
exit;
EOF

cat > /home/oracle/restore_${oracle_sid}.04.sql << EOF
alter database mount;
exit;
EOF

cat > /home/oracle/restore_${oracle_sid}.05.sql << EOF
alter database mount;
exit;
EOF


}

function prepare_sql_restore_after
{
    export ORACLE_SID=${oracle_sid}
    echo "select member from v\$logfile;" | sqlplus -S / as sysdba | grep "\/" | sed "s/^/alter database rename file '/g" | sed "s/$/' to '+DATA';/g" > /home/oracle/restore_${oracle_sid}.06.sql 
    echo "alter database open resetlogs;" >> /home/oracle/restore_${oracle_sid}.06.sql
    echo "exit;" >> /home/oracle/restore_${oracle_sid}.06.sql
}

function prepare_rman_restore_after
{
    echo "run {" > /home/oracle/restore_${oracle_sid}.06.rman
    export ORACLE_SID=${oracle_sid}
    echo "select 'set newname for datafile '||file#||' to ''+DATA'';' from v\$datafile union all select 'set newname for tempfile '||file#||' to ''+DATA'';' from v\$tempfile;" | sqlplus -S / as sysdba | grep "set newname" >> /home/oracle/restore_${oracle_sid}.06.rman
    echo "
    restore database;
    switch datafile all;
    switch tempfile all;
    recover database;
    }" >> /home/oracle/restore_${oracle_sid}.06.rman

}

function process_pfile
{
    dump_dest=$(cat /home/oracle/${oracle_sid}.pfile | grep audit_file | cut -d \' -f2 | sed 's/[a-z]dump//g')
    mkdir -p /u01/app/oracle/admin/${oracle_sid}/adump
    mkdir -p /u01/app/oracle/admin/${oracle_sid}/bdump
    mkdir -p /u01/app/oracle/admin/${oracle_sid}/cdump
    mkdir -p /u01/app/oracle/admin/${oracle_sid}/udump
    sed -i "s/\.db_recovery_file_dest=.*/.db_recovery_file_dest='+DATA'/g" /home/oracle/${oracle_sid}.pfile
    sed -i "s/\.db_create_file_dest=.*/.db_create_file_dest='+DATA'/g" /home/oracle/${oracle_sid}.pfile
    sed -i "s/*.control_files=.*/*.control_files='+DATA'/g" /home/oracle/${oracle_sid}.pfile
    sed -i "s/*.audit_file_dest=.*/*.audit_file_dest='\/u01\/app\/oracle\/admin\/${oracle_sid}\/adump'/g" /home/oracle/${oracle_sid}.pfile
    sed -i "s/*.background_dump_dest=.*/*.background_dump_dest='\/u01\/app\/oracle\/admin\/${oracle_sid}\/bdump'/g" /home/oracle/${oracle_sid}.pfile
    sed -i "s/*.core_dump_dest=.*/*.core_dump_dest='\/u01\/app\/oracle\/admin\/${oracle_sid}\/cdump'/g" /home/oracle/${oracle_sid}.pfile
    sed -i "s/*.user_dump_dest=.*/*.user_dump_dest='\/u01\/app\/oracle\/admin\/${oracle_sid}\/udump'/g" /home/oracle/${oracle_sid}.pfile
    sed -i "s/*.diagnostic_dest=.*/*.diagnostic_dest='\/u01\/app\/oracle\/'/g" /home/oracle/${oracle_sid}.pfile

}

function verify_db
{
    echo "select username from dba_users where username='ZABBIX';" | sqlplus -S / as sysdba | egrep -q "ZABBIX"
    userfound=$?
    echo 'select open_mode from v$database;' | sqlplus -S / as sysdba | egrep -q "READ WRITE"
    openmode=$?
    lsnrctl status | grep -q "Instance \"${oracle_sid}\", status READY"
    listenerok=$?
    if [[ ${userfound} -eq 0 ]] && [[ ${openmode} -eq 0 ]]
    then
            echo "[$(date +'%H:%M:%S')] Database verified and opened!"
    else
            error=1
            echo "ERROR! Database not verified as open!"
    fi
    if [[ ${listenerok} -eq 0 ]]
    then
            echo "[$(date +'%H:%M:%S')] Checking listener... OK!"
    else
            error=1
            echo "[$(date +'%H:%M:%S')] ERROR! Problem with listener!"
    fi
}

function prepare_server
{
    echo "[$(date +'%H:%M:%S')] Starting DR process for ${oracle_sid}, backups in ${backup_location}"
    echo "[$(date +'%H:%M:%S')] Looking for last full backup in ${backup_location}..."
    last_full=$( ls -lt /mnt/backup/${oracle_sid}/ | tac | grep FULL | awk '{ print $NF }' | tail -n1)
    echo "[$(date +'%H:%M:%S')] Last full backup is ${last_full}..."
    backup_location=${backup_location}/${oracle_sid}/${last_full}
    echo "[$(date +'%H:%M:%S')] Exact backup location is ${backup_location}..."
    echo "[$(date +'%H:%M:%S')] Discovering running instances..."
    running_instance=$( ps -ef | grep ora_ | grep -v grep | awk ' { print $NF } ' | cut -d '_' -f3 | uniq )
    if [[ -z "${running_instance}" ]]
    then
        echo "[$(date +'%H:%M:%S')] No running instance found!"
    else
        echo "[$(date +'%H:%M:%S')] Running instance ${running_instance} found! Shutting down..."

        export ORACLE_BASE=${oracle_base}
        export ORACLE_HOME=${oracle_home}
        export PATH=${path}
        export NLS_LANG=${nls_lang}
        export NLS_DATE_FORMAT=${nls_date_format}
        export ORACLE_SID=${running_instance}
        echo "shutdown immediate;" | sqlplus / as sysdba
    fi

    echo "[$(date +'%H:%M:%S')] ASM cleanup..."
    . ${grid_profile_script}
    asm_empty=$( asmcmd ls DATA )
    if [[ ! -z "${asm_empty}" ]]
    then
        asmcmd rm -r DATA/*
    else
        echo "[$(date +'%H:%M:%S')] ASM is already empty!"
    fi
    asmcmd lsdg

    echo "[$(date +'%H:%M:%S')] Cleanup of previous SPFILEs and restores..."
    rm -f /u01/app/oracle/product/db_1/dbs/spfile*
    rm -f /home/oracle/restore_${oracle_sid}.*
    rm -f /home/oracle/${oracle_sid}.*

}

function export_vars
{

    export ORACLE_BASE=${oracle_base}
    export ORACLE_HOME=${oracle_home}
    export PATH=${path}
    export NLS_LANG=${nls_lang}
    export NLS_DATE_FORMAT=${nls_date_format}
    export ORACLE_SID=${oracle_sid}
}

function verify_rman_exit
{
    rman_exit=$1
    echo "[$(date +'%H:%M:%S')] [DEBUG] RMAN exit code was ${rman_exit}..."
    if [[ ${rman_exit} -ne 0 ]]
    then
        echo "[$(date +'%H:%M:%S')] [DEBUG] RMAN has non-zero exit code! Error!"
        error=1
    fi
}

# main

prepare_server
export_vars
echo "[$(date +'%H:%M:%S')] Getting name of CONTROLFILE..."
get_controlfile
echo "[$(date +'%H:%M:%S')] Preparing SQL/RMAN scripts..."
prepare_rman_restore
prepare_sql_restore
echo "[$(date +'%H:%M:%S')] Restoring CONTROFILE and PFILE..."
rman target / @/home/oracle/restore_${oracle_sid}.01.rman
verify_rman_exit $?
sqlplus / as sysdba @/home/oracle/restore_${oracle_sid}.01.sql
echo "[$(date +'%H:%M:%S')] Processing PFILE..."
process_pfile
echo "[$(date +'%H:%M:%S')] Creating new SPFILE..."
sqlplus / as sysdba @/home/oracle/restore_${oracle_sid}.02.sql
sqlplus / as sysdba @/home/oracle/restore_${oracle_sid}.03.sql
echo "[$(date +'%H:%M:%S')] Restoring CONTROLFILE to new location from SPFILE..."
rman target / @/home/oracle/restore_${oracle_sid}.02.rman
verify_rman_exit $?
echo "[$(date +'%H:%M:%S')] Mounting database..."
sqlplus / as sysdba @/home/oracle/restore_${oracle_sid}.04.sql
echo "[$(date +'%H:%M:%S')] Cataloging backup files..."
rman target / @/home/oracle/restore_${oracle_sid}.03.rman
verify_rman_exit $?
export ORACLE_SID=${oracle_sid}
echo "[$(date +'%H:%M:%S')] Preparing scripts to rename datafiles, tempfiles and logfiles..."
prepare_rman_restore_after
echo "[$(date +'%H:%M:%S')] Starting restore and recovery process..."
rman target / @/home/oracle/restore_${oracle_sid}.06.rman
echo "[$(date +'%H:%M:%S')] Skipping RMAN exit code verification, recovery might fail due to missing archive logs..."
#verify_rman_exit $?
prepare_sql_restore_after
echo "[$(date +'%H:%M:%S')] Renaming REDO logs..."
sqlplus / as sysdba @/home/oracle/restore_${oracle_sid}.06.sql
echo "[$(date +'%H:%M:%S')] Setting new ORAPW file..."
orapwd file=${ORACLE_HOME}/dbs/orapw${oracle_sid} password=SYSPASSWD entries=5 force=y
echo "[$(date +'%H:%M:%S')] Listener stop..."
lsnrctl stop
sleep 10
echo "[$(date +'%H:%M:%S')] Listener start, waiting up to 90 seconds..."
lsnrctl start
sleep 90
echo "[$(date +'%H:%M:%S')] Listener status..."
lsnrctl status
echo "[$(date +'%H:%M:%S')] Verifying database after restore..."
verify_db
converted_date=$( echo ${last_full} | sed 's/_/\//g' )
if [[ ${error} -eq 0 ]]
then
    echo "[$(date +'%H:%M:%S')] Restore of database ${oracle_sid} from backup created at ${converted_date}  was successful!"
else
    echo "[$(date +'%H:%M:%S')] ERROR! Restore of database ${oracle_sid} from backup created at ${converted_date}  was not successful!"
    error=1
fi

rm -f /home/oracle/restore_${oracle_sid}.*
rm -f /home/oracle/${oracle_sid}.*

exit ${error}
