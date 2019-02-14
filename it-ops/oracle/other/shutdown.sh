#!/bin/bash

orasid=( )
nowis=$(date +'%d/%m/%Y %H:%M')
echo "[${nowis}] Stopping database services..."

# stop databases

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/db_1
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/u01/app/oracle/product/db_1/bin
export NLS_LANG=AMERICAN_AMERICA.EE8MSWIN1250
export NLS_DATE_FORMAT=DD_MON_YYYY_HH24:MI:SS

error=0
nowis=$(date +'%d/%m/%Y %H:%M')
echo "[${nowis}] Stopping databases..."

for sid in "${orasid[@]}"
do
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


export ORACLE_BASE=/u01/app/grid
export ORACLE_HOME=/u01/app/grid/product/asm
export ORACLE_SID=+ASM
export NLS_LANG=AMERICAN_AMERICA.EE8MSWIN1250
export NLS_DATE_FORMAT=DD_MON_YYYY_HH24:MI:SS
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/u01/app/grid/product/asm/bin

# stop ASM
nowis=$(date +'%d/%m/%Y %H:%M')
echo "[${nowis}] Stopping ASM..."
srvctl stop dg -g DATA
if [[ $? -eq 0 ]]
then
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Successfully stopped diskgroup DATA!"
else
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Could not stop diskgroup DATA! Exit!"
	exit 1
fi

srvctl stop asm
if [[ $? -eq 0 ]]
then
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Successfully stopped ASM!"
else
	nowis=$(date +'%d/%m/%Y %H:%M')
	echo "[${nowis}] Could not stop ASM! Exit!"
	exit 1
fi

exit ${error}
