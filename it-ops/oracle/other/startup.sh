#!/bin/bash

orasid=( )

export ORACLE_BASE=/u01/app/grid
export ORACLE_HOME=/u01/app/grid/product/asm
export ORACLE_SID=+ASM
export NLS_LANG=AMERICAN_AMERICA.EE8MSWIN1250
export NLS_DATE_FORMAT=DD_MON_YYYY_HH24:MI:SS
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/u01/app/grid/product/asm/bin

nowis=$(date +'%d/%m/%Y %H:%M')
echo "[${nowis}] Starting database services..."

# start ASM
nowis=$(date +'%d/%m/%Y %H:%M')
echo "[${nowis}] Starting ASM..."
srvctl start asm
if [[ $? -eq 0 ]]
then
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Successfully started ASM!"
else
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Could not start ASM! Is it running?"
fi

# possibly ASM is running already

srvctl status asm | grep -q "ASM is running"
if [[ $? -eq 0 ]]
then
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Successfully started ASM!"
else
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Could not start ASM!"
	exit 1
fi



# start databases

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/db_1
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/u01/app/oracle/product/db_1/bin
export NLS_LANG=AMERICAN_AMERICA.EE8MSWIN1250
export NLS_DATE_FORMAT=DD_MON_YYYY_HH24:MI:SS

error=0
nowis=$(date +'%d/%m/%Y %H:%M')
echo "[${nowis}] Starting databases..."

for sid in "${orasid[@]}"
do
	export ORACLE_SID=${sid}
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Starting database ${sid}..."
	#srvctl start database -d ${orasid}
    echo "startup;" | sqlplus / as sysdba > /home/oracle/startup_ora_${sid}.log
    grep -iq "Database opened." /home/oracle/startup_ora_${sid}.log
	if [[ $? -eq 0 ]]
	then
		nowis=$(date +'%d/%m/%Y %H:%M')
		echo "[${nowis}] Successfully started database ${sid}!"
		# verify database
		echo "select username from dba_users where username='G15' or username='GURIK15';" | sqlplus -S / as sysdba | egrep -q "G15|GURIK15"
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
done
if [[ ${error} -eq 0 ]]
then
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Successfully started database services!"
else
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Found ERRORS during starting database services!"
fi

exit ${error}
