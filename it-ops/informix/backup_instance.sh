#!/bin/bash

# creating Informix backup either full or incremental backup via ontape, assuming /backup is mounted

setonfile=/u/informix/seton
echo "[$(date +'%H:%M:%S')] Loading seton file... (settings for instance)"
. ${setonfile}

level=0
dest_dir=/backup/informix
filename=${INFORMIXSERVER}_informix_backup_$(date +'%d_%m_%y')_L${level}
full_filename=${dest_dir}/${filename}
tapedev=/usr/informix/tapedev

echo "Starting Informix Backup, instance: ${INFORMIXSERVER} level: ${level} at $(date)"
echo "[$(date +'%H:%M:%S')] Creating tape device and structure..."
touch ${full_filename}
chmod 660 ${full_filename}
echo "[$(date +'%H:%M:%S')] Loading seton file... (settings for instance)"
. ${setonfile}
echo "[$(date +'%H:%M:%S')] Creating tape device and structure..."
if [ ! -f ${tapedev} ]
then
        echo "[$(date +'%H:%M:%S')] Tape device does not exist! Creating... "
        touch ${tapedev}
        chmod 660 ${tapedev}
        ln -fs ${full_filename} ${tapedev}
else
        echo "[$(date +'%H:%M:%S')] Tape device exists! Removing and linking to new backup tape..."
        rm ${tapedev}
        touch ${tapedev}
        chmod 660 ${tapedev}
        ln -fs ${full_filename} ${tapedev}
fi

echo "[$(date +'%H:%M:%S')] Starting backup..."
echo -e "\n0" | ontape -s -L ${level}
exit_code=$?

if [[ -s ${full_filename} ]]
then
        echo "[$(date +'%H:%M:%S')] Backup exists and has size greater than 0!"
        echo "[$(date +'%H:%M:%S')] Compressing backup..."
        gzip ${full_filename}
else
        echo "Backup doesn't exist or has 0 size!"
        exit_code=1
fi


echo "[$(date +'%H:%M:%S')] End of backup... Exit code is ${exit_code}"
exit ${exit_code}

