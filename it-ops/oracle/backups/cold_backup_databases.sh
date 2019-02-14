#!/bin/bash

orasid=( SID1 SID2 )

# start databases

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/db_1
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/u01/app/oracle/product/db_1/bin
export NLS_LANG=AMERICAN_AMERICA.EE8MSWIN1250
export NLS_DATE_FORMAT=DD_MON_YYYY_HH24:MI:SS

error=0

echo "[$(date +'%d/%m/%Y %H:%M')] Starting Database Backups... Instances: ${orasid[@]}"
mount | grep -q "mnt\/backup"
if [[ "$?" -eq 0 ]]
then
	echo "[$(date +'%d/%m/%Y %H:%M')] Location /mnt/backup is mounted... continue!"
else
	echo "[$(date +'%d/%m/%Y %H:%M')] Location /mnt/backup is not mounted... exit!"
	exit 1
fi

nowis=$(date +'%d/%m/%Y %H:%M')
echo "[${nowis}] Stopping databases..."

for sid in "${orasid[@]}"
do

        nowis=$(date +'%d/%m/%Y %H:%M')
        echo "[${nowis}] Preparing RMAN scripts for ${sid}..."
	orasid=${sid}
	orasidbig=${orasid^^}
	oradate=$( date +'%d_%m_%Y' )
	oradatesuffix=$( date +'%d%m%Y' )
	sed -e "s/ORASID/${orasid}/g" -e "s/ORADATE/${oradate}/g" -e "s/ORATAG/${orasidbig}/g" -e "s/ORATDATE/${oradatesuffix}/g" /home/oracle/rman.backup.template > rman.backup.${orasid}
        export ORACLE_SID=${sid}
        nowis=$(date +'%d/%m/%Y %H:%M')
        echo "[${nowis}] Stopping database ${sid}..."
        echo "shutdown immediate;" | sqlplus / as sysdba > /home/oracle/shutdown_ora_${sid}.log
        grep -iq "ORACLE instance shut down." /home/oracle/shutdown_ora_${sid}.log
        if [[ $? -eq 0 ]]
        then
                nowis=$(date +'%d/%m/%Y %H:%M')
                echo "[${nowis}] Successfully stopped database ${sid}!"
        else
                nowis=$(date +'%d/%m/%Y %H:%M')
                echo "[${nowis}] Could not stop database ${sid}!"
		error=1
        fi
done
if [[ ${error} -eq 0 ]]
then
        nowis=$(date +'%d/%m/%Y %H:%M')
        echo "[${nowis}] Successfully stopped database services!"
else
        nowis=$(date +'%d/%m/%Y %H:%M')
        echo "[${nowis}] Found ERRORS during stopping database services! Exit!"
        exit 1
fi

nowis=$(date +'%d/%m/%Y %H:%M')
echo "[${nowis}] Mounting databases..."

for sid in "${orasid[@]}"
do
        export ORACLE_SID=${sid}
        nowis=$(date +'%d/%m/%Y %H:%M')
        echo "[${nowis}] Mounting database ${sid}..."
        echo "startup mount;" | sqlplus / as sysdba > /home/oracle/startup_ora_${sid}.log
        grep -iq "Database mounted" /home/oracle/startup_ora_${sid}.log
        if [[ $? -eq 0 ]]
        then
                nowis=$(date +'%d/%m/%Y %H:%M')
                echo "[${nowis}] Successfully mounted database ${sid}!"
                echo 'select open_mode from v$database;' | sqlplus -S / as sysdba | egrep -q "MOUNTED"
                openmode=$?
                if [[ ${openmode} -eq 0 ]]
                then
                        echo "Database verified and mounted!"
			nowis=$(date +'%d/%m/%Y %H:%M')
			echo "[${nowis}] Starting database backup..."
			rman target / @rman.backup.${sid}
			if [[ $? -eq 0 ]]
			then
				nowis=$(date +'%d/%m/%Y %H:%M')
				echo "[${nowis}] Successful ${sid} database backup... opening database"
				echo "alter database open;" | sqlplus / as sysdba > /home/oracle/startup_ora_${sid}.log
				grep -iq "Database altered." /home/oracle/startup_ora_${sid}.log
				if [[ $? -eq 0 ]]
				then
					nowis=$(date +'%d/%m/%Y %H:%M')
					echo "[${nowis}] Successfully started database ${sid}!"
					# verify database
					echo "select username from dba_users where username='ZABBIX';" | sqlplus -S / as sysdba | egrep -q "ZABBIX"
					userfound=$?
					echo 'select open_mode from v$database;' | sqlplus -S / as sysdba | egrep -q "READ WRITE"
					openmode=$?
					lsnrctl status | grep -q "Instance \"${sid}\", status READY"
					listenerok=$?
					if [[ ${userfound} -eq 0 ]] && [[ ${openmode} -eq 0 ]]
					then
						echo "Database verified and opened!"
					else
						error=1
						echo "ERROR! Database not verified as open!"
					fi
					if [[ ${listenerok} -eq 0 ]]
					then
						echo "Checking listener... OK!"
					else
						error=1
						echo "ERROR! Problem with listener!"
					fi
				else
					nowis=$(date +'%d/%m/%Y %H:%M')
					echo "[${nowis}] Could not start database ${sid}!"
				fi

			fi
                else
                        error=1
                        echo "ERROR! Database not verified as mounted!"
                fi
        else
                nowis=$(date +'%d/%m/%Y %H:%M')
                echo "[${nowis}] Could not mount database ${sid}!"
        fi
done

exit ${error}

