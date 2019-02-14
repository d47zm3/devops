#!/bin/bash

set -u

orasid=( SID1 ) 
cluster_sid="SID"
backup_path="/mnt/backup"
mode=$1

nfs_backup_server=1.1.1.1
nfs_backup_share=/backup
nfs_backup_subshare=/
local_backup_share=/mnt/backup

old_backups=30

if [[ "${mode}" != "full" ]] && [[ "${mode}" != "inc" ]]
then
	echo "Error! Bad Backup Mode \"${mode}\"! Use \"full\" or \"inc\""
	exit 1
fi

# start databases

export ORACLE_BASE=/u01/app/oracle11
export ORACLE_HOME=/u01/app/oracle11/product/11.2.0/db_1
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:${ORACLE_HOME}/bin
export NLS_LANG=AMERICAN_AMERICA.EE8MSWIN1250
export NLS_DATE_FORMAT=DD_MON_YYYY_HH24:MI:SS

error=0

log_path="/home/oracle/backup_logs"
todayis=`date "+%d_%m_%Y_%H:%M"`
logfile_name="${log_path}/oracle_backup_${todayis}.log"

#katalog z logami, jezeli nie istnieje, utworz
if [[ ! -d "${log_path}" ]]
then
    mkdir "${log_path}"
fi

#przekieruj wyjscie do logfile
#exec > >(tee "${logfile_name}")
#exec 2>&1


function mount_nfs_dir
{
    # check if resource is mounted, do it if not
    nserver=$1
    nserver_path=$2
    local_path=$3

    mountpoint -q ${local_path}
    if [[ "$?" -eq 0  ]]
    then
        echo "[$(date +'$d/%m/%Y %H:%M:%S')] NFS ${nserver}:${nserver_path} mounted, proceed..."
    else
        echo "[$(date +'%d/%m/%Y %H:%M:%S')] NFS ${nserver}:${nserver_path} not mounted, mounting..."
        sudo mount -o rw,vers=3,hard,intr,timeo=600,actimeo=0,tcp,bg,wsize=32768,rsize=32768 ${nserver}:${nserver_path} ${local_path}
        if [[ "$?" -eq 0  ]]
        then
            echo "[$(date +'%d/%m/%Y %H:%M:%S')] Mount ${nserver}:${nserver_path} was successful."
            mountpoint -q ${local_path}
            if [[ "$?" -eq 0  ]]
            then
                echo "[$(date +'%d/%m/%Y %H:%M:%S')] Host ${nserver}:${nserver_path} mounted, proceed..."
            else
                echo "[$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Mount ${nserver}:${nserver_path} was NOT successful. EXIT!"
                exit 1
            fi
        else
            echo "[$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Mount ${nserver}:${nserver_path} was NOT successful. EXIT!"
            exit 1
        fi
    fi
}

if [[ ! -d /mnt/backup ]]
then
        mkdir -p /mnt/backup
fi


echo "[$(date +'%d/%m/%Y %H:%M:%S')] Starting Database Backups... Instances: ${orasid[@]} Mode: ${mode^^}"

mount_nfs_dir ${nfs_backup_server} ${nfs_backup_share}/${nfs_backup_subshare} ${local_backup_share}

echo "[$(date +'%d/%m/%Y %H:%M:%S')] Setting ownership..."
sudo chown oracle:oinstall ${local_backup_share}/*


mount | grep -q "mnt\/backup"
if [[ "$?" -eq 0 ]]
then
	echo "[$(date +'%d/%m/%Y %H:%M:%S')] Location /mnt/backup is mounted... continue!"
else
	echo "[$(date +'%d/%m/%Y %H:%M:%S')] Location /mnt/backup is not mounted... exit!"
	exit 1
fi

echo "[$(date +'%d/%m/%Y %H:%M:%S')] Stopping databases..."

for sid in "${orasid[@]}"
do

        echo "[$(date +'%d/%m/%Y %H:%M:%S')] Preparing RMAN scripts for ${sid}..."
	orasid=${sid}
	orasidbig=${orasid^^}
	oradate=$( date +'%d_%m_%Y' )
	oradatesuffix=$( date +'%d%m%Y' )
	oramode=${mode^^}
	if [[ "${mode}" == "full" ]]
	then
		oralevel=0
		sed -e "s/ORASID/${orasid}/g" -e "s/ORADATE/${oradate}/g" -e "s/ORATAG/${orasidbig}/g" -e "s/ORATDATE/${oradatesuffix}/g" -e "s/ORAMODE/${oramode}/g" -e "s/ORALEVEL/${oralevel}/g" -e "s/cumulative//g" /home/oracle/rman.backup.template > rman.backup.${orasid}
	fi
	if [[ "${mode}" == "inc" ]]
	then
		oralevel=1
		sed -e "s/ORASID/${orasid}/g" -e "s/ORADATE/${oradate}/g" -e "s/ORATAG/${orasidbig}/g" -e "s/ORATDATE/${oradatesuffix}/g" -e "s/ORAMODE/${oramode}/g"  -e "s/ORALEVEL/${oralevel}/g" /home/oracle/rman.backup.template > rman.backup.${orasid}
	fi

	if [[ "${mode}" == "full" ]]
	then
		echo "[$(date +'%d/%m/%Y %H:%M:%S')] Full backup mode, stopping ${sid}..."
		export ORACLE_SID=${sid}
		echo "[$(date +'%d/%m/%Y %H:%M:%S')] Stopping database ${sid}..."
		echo "shutdown immediate;" | sqlplus / as sysdba > /home/oracle/shutdown_ora_${sid}.log
		grep -iq "ORACLE instance shut down." /home/oracle/shutdown_ora_${sid}.log
		if [[ $? -eq 0 ]]
		then
			echo "[$(date +'%d/%m/%Y %H:%M:%S')] Successfully verified stopped database ${sid}!"
		else
			echo "[$(date +'%d/%m/%Y %H:%M:%S')] Could not stop database ${sid}!"
			 error=1
		fi
	fi
done
if [[ ${error} -eq 0 ]] && [[ "${mode}" == "full" ]]
then
        echo "[$(date +'%d/%m/%Y %H:%M:%S')] Successfully stopped database services!"
elif [[ ${error} -ne 0 ]] && [[ "${mode}" == "full" ]] 
then
        echo "[$(date +'%d/%m/%Y %H:%M:%S')] Found ERRORS during stopping database services! Exit!"
        exit 1
fi

if [[ "${mode}" == "full" ]]
then
	echo "[$(date +'%d/%m/%Y %H:%M:%S')] Mounting databases..."
	for sid in "${orasid[@]}"
	do
		export ORACLE_SID=${sid}
		echo "[$(date +'%d/%m/%Y %H:%M:%S')] Mounting database ${sid}..."
		echo "startup mount;" | sqlplus / as sysdba > /home/oracle/startup_ora_${sid}.log
		grep -iq "Database mounted" /home/oracle/startup_ora_${sid}.log
		if [[ $? -eq 0 ]]
		then
			echo "[$(date +'%d/%m/%Y %H:%M:%S')] Successfully mounted database ${sid}!"
			echo 'select open_mode from v$database;' | sqlplus -S / as sysdba | egrep -q "MOUNTED"
			openmode=$?
			if [[ ${openmode} -eq 0 ]]
			then
				echo "Database verified and mounted!"
				echo "[$(date +'%d/%m/%Y %H:%M:%S')] Starting database backup..."
				oradate=$( date +'%d_%m_%Y' )
				oramode=${mode^^}
				if [[ ! -d "${backup_path}/${sid}/${oradate}_${oramode}" ]]
				then
				    echo "[$(date +'%d/%m/%Y %H:%M:%S')] Creating new backup directory..."
				    mkdir "${backup_path}/${sid}/${oradate}_${oramode}"
				fi
				rman target / @rman.backup.${sid}
                rman_exit_code=$?
				if [[ ${rman_exit_code} -eq 0 ]]
				then
					echo "[$(date +'%d/%m/%Y %H:%M:%S')] Successful ${sid} database backup... opening database"
					echo "alter database open;" | sqlplus / as sysdba > /home/oracle/startup_ora_${sid}.log
					grep -iq "Database altered." /home/oracle/startup_ora_${sid}.log

					if [[ $? -eq 0 ]]
					then
						echo "[$(date +'%d/%m/%Y %H:%M:%S')] Successfully started database ${sid}!"
						# verify database
						echo "select username from dba_users where username='ZABBIX';" | sqlplus -S / as sysdba | egrep -q "ZABBIX"
						userfound=$?
						echo 'select open_mode from v$database;' | sqlplus -S / as sysdba | egrep -q "READ WRITE"
						openmode=$?
						lsnrctl status | grep -q "Instance \"${sid}\", status READY"
						listenerok=$?
						if [[ ${userfound} -eq 0 ]] && [[ ${openmode} -eq 0 ]]
						then
							echo " [$(date +'%d/%m/%Y %H:%M:%S')] Database verified and opened!"
						else
							error=1
							echo " [$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Database not verified as open!"
						fi
						if [[ ${listenerok} -eq 0 ]]
						then
							echo " [$(date +'%d/%m/%Y %H:%M:%S')] Checking listener... OK!"
						else
							error=1
							echo " [$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Problem with listener!"
						fi
					else
						echo "[$(date +'%d/%m/%Y %H:%M:%S')] Could not start database ${sid}!"
					fi
                else
                    echo "[$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Failed ${sid} database backup... opening database"
                    error=1
					echo "alter database open;" | sqlplus / as sysdba > /home/oracle/startup_ora_${sid}.log
					grep -iq "Database altered." /home/oracle/startup_ora_${sid}.log
					if [[ $? -eq 0 ]]
					then
						echo "[$(date +'%d/%m/%Y %H:%M:%S')] Successfully started database ${sid}!"
						# verify database
						echo "select username from dba_users where username='ZABBIX';" | sqlplus -S / as sysdba | egrep -q "ZABBIX"
						userfound=$?
						echo 'select open_mode from v$database;' | sqlplus -S / as sysdba | egrep -q "READ WRITE"
						openmode=$?
						lsnrctl status | grep -q "Instance \"${sid}\", status READY"
						listenerok=$?
						if [[ ${userfound} -eq 0 ]] && [[ ${openmode} -eq 0 ]]
						then
							echo " [$(date +'%d/%m/%Y %H:%M:%S')] Database verified and opened!"
						else
							error=1
							echo " [$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Database not verified as open!"
						fi
						if [[ ${listenerok} -eq 0 ]]
						then
							echo " [$(date +'%d/%m/%Y %H:%M:%S')] Checking listener... OK!"
						else
							error=1
							echo " [$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Problem with listener!"
						fi
					else
						echo "[$(date +'%d/%m/%Y %H:%M:%S')] Could not start database ${sid}!"
					fi
				fi
			else
				error=1
				echo " [$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Database not verified as mounted!"
			fi
		else
			echo "[$(date +'%d/%m/%Y %H:%M:%S')] Could not mount database ${sid}!"
		fi
	done
fi

if [[ "${mode}" == "inc" ]]
then
	for sid in "${orasid[@]}"
	do
		export ORACLE_SID=${sid}
		echo 'select open_mode from v$database;' | sqlplus -S / as sysdba | egrep -q "READ WRITE"
		openmode=$?
		if [[ ${openmode} -eq 0 ]]
		then
			echo "Database verified and opened!"
			echo "[$(date +'%d/%m/%Y %H:%M:%S')] Starting database backup..."
			oradate=$( date +'%d_%m_%Y' )
			oramode=${mode^^}
			if [[ ! -d "${backup_path}/${sid}/${oradate}_${oramode}" ]]
			then
			    echo "[$(date +'%d/%m/%Y %H:%M:%S')] Creating new backup directory..."
			    mkdir "${backup_path}/${sid}/${oradate}_${oramode}"
			fi
			rman target / @rman.backup.${sid}
            rman_exit_code=$?
			if [[ ${rman_exit_code} -eq 0 ]]
			then
				echo "[$(date +'%d/%m/%Y %H:%M:%S')] Successful ${sid} database backup..."
				# verify database
				echo "select username from dba_users where username='ZABBIX';" | sqlplus -S / as sysdba | egrep -q "ZABBIX"
				userfound=$?
				echo 'select open_mode from v$database;' | sqlplus -S / as sysdba | egrep -q "READ WRITE"
				openmode=$?
				lsnrctl status | grep -q "Instance \"${sid}\", status READY"
				listenerok=$?
				if [[ ${userfound} -eq 0 ]] && [[ ${openmode} -eq 0 ]]
				then
					echo " [$(date +'%d/%m/%Y %H:%M:%S')] Database verified and opened!"
				else
					error=1
					echo "ERROR! Database not verified as open!"
				fi
				if [[ ${listenerok} -eq 0 ]]
				then
					echo "[$(date +'%d/%m/%Y %H:%M:%S')] Checking listener... OK!"
				else
					error=1
					echo "[$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Problem with listener!"
				fi
            else
				echo "[$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Failed ${sid} database backup..."
                error=1
                # verify database
				echo "select username from dba_users where username='ZABBIX';" | sqlplus -S / as sysdba | egrep -q "ZABBIX"
				userfound=$?
				echo 'select open_mode from v$database;' | sqlplus -S / as sysdba | egrep -q "READ WRITE"
				openmode=$?
				lsnrctl status | grep -q "Instance \"${sid}\", status READY"
				listenerok=$?
				if [[ ${userfound} -eq 0 ]] && [[ ${openmode} -eq 0 ]]
				then
					echo " [$(date +'%d/%m/%Y %H:%M:%S')] Database verified and opened!"
				else
					error=1
					echo "ERROR! Database not verified as open!"
				fi
				if [[ ${listenerok} -eq 0 ]]
				then
					echo "[$(date +'%d/%m/%Y %H:%M:%S')] Checking listener... OK!"
				else
					error=1
					echo "[$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Problem with listener!"
				fi
			fi
		else
			error=1
			echo " [$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Database not verified as opened!"
		fi
	done
fi

if [[ "${error}" -eq 0 ]]
then
    echo " [$(date +'%d/%m/%Y %H:%M:%S')] Backup was successful, removing old backups, older than ${old_backups} days!"
    orasidbig=${orasid^^}
    find ${local_backup_share}/${orasidbig} -mtime +${old_backups} -exec rm -r "{}" \;
else
    echo " [$(date +'%d/%m/%Y %H:%M:%S')] ERROR! Backup was not successful, not removing old backups..."
fi

exit ${error}

