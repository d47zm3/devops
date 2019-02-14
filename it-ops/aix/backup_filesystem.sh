#!/bin/bash

function usage
{
        echo "Usage: $0 PATH_TO_BACKUP LEVEL (0 or 1)"
        exit 1
}

if [[ -z $1  ]] || [[ -z $2 ]]
then
        usage
fi

set -u

exit_code=0
path=$1
level=$2
filename="${HOSTNAME}_backup$( echo ${path} | sed "s/\//_/g" )_$(date +'%d_%m_%Y')_level_${level}.backup"

echo "[$(date +'%H:%M')] Starting backup, Host: ${HOSTNAME}, Path: ${path}, Level: ${level}"
mount | grep -q backup
if [[ "$?" -ne 0 ]]
then
        echo "[$(date +'%H:%M')] NFS /backup not mounted, trying to mount... "
        mount 172.16.4.147:/volume2/backups/${HOSTNAME} /backup
        if [[ "$?" -ne 0 ]]
        then
                echo "[$(date +'%H:%M')] Mount NFS has failed, exit!"
                exit_code=1
                exit ${exit_code}
        fi
        echo "[$(date +'%H:%M')] Checking /backup again..."
        mount | grep -q /backup
        if [[ "$?" -ne 0 ]]
        then
                echo "[$(date +'%H:%M')] Mount NFS has failed, exit!"
                exit_code=1
                exit ${exit_code}
        fi
fi

echo "[$(date +'%H:%M')] NFS /backup mounted, continue..."

echo "[$(date +'%H:%M')] Running backup..."
backup -${level} -f /backup/${filename} -u ${path}

if [[ "$?" -ne 0 ]]
then
        echo "[$(date +'%H:%M')] There was an error during backup!"
        exit_code=1
fi

echo "[$(date +'%H:%M')] Compressing backup..."
gzip /backup/${filename}
echo "[$(date +'%H:%M')] Backup has been compressed!"

#echo "[$(date +'%H:%M')] Force unmounting of /backup..."
#umount -f /backup

echo "[$(date +'%H:%M')] End of backup."

exit ${exit_code}
