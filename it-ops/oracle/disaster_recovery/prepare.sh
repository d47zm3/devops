#!/bin/bash

set -u

nfs_backup_server=1.1.1.1
nfs_backup_share=/backup
nfs_backup_subshare=/
local_backup_share=/mnt/backup

function mount_nfs_dir
{
    # check if resource is mounted, do it if not
    nserver=$1
    nserver_path=$2
    local_path=$3

    mountpoint -q ${local_path}
    if [[ "$?" -eq 0  ]]
    then
        echo "[$(date +'%H:%M:%S')] NFS ${nserver}:${nserver_path} mounted, checking if it's valid directory then proceed..."
        mount | grep "${local_backup_share}" | grep -q "${nserver}:${nserver_path}"
        if [[ "$?" -eq 0 ]]
        then
            echo "[$(date +'%H:%M:%S')] NFS ${nserver}:${nserver_path}  mounted, proceed..."
        else
            echo "[$(date +'%H:%M:%S')] NFS ${nserver}:${nserver_path}  not mounted, proceed..."
            echo "[$(date +'%H:%M:%S')] Unmounting current directory and mounting right one..."
            sudo umount ${local_path}
            if [[ "$?" -eq 0  ]]
            then
                echo "[$(date +'%H:%M:%S')] Unmounting was successful, proceed..."
            else
                echo "[$(date +'%H:%M:%S')] Unmounting was NOT successful, exit!"
                exit 1
            fi
            sudo mount ${nserver}:${nserver_path} ${local_path}
            if [[ "$?" -eq 0  ]]
            then
                echo "[$(date +'%H:%M:%S')] Mount ${nserver}:${nserver_path} was successful."
                mountpoint -q ${local_path}
                if [[ "$?" -eq 0  ]]
                then
                    echo "[$(date +'%H:%M:%S')] Host ${nserver}:${nserver_path} mounted, proceed..."
                else
                    echo "[$(date +'%H:%M:%S')] ERROR! Mount ${nserver}:${nserver_path} was NOT successful. EXIT!"
                    exit 1
                fi
            else
                echo "[$(date +'%H:%M:%S')] ERROR! Mount ${nserver}:${nserver_path} was NOT successful. EXIT!"
                exit 1
            fi
        fi
    else
        echo "[$(date +'%H:%M:%S')] NFS ${nserver}:${nserver_path} not mounted, mounting..."
        sudo mount ${nserver}:${nserver_path} ${local_path}
        if [[ "$?" -eq 0  ]]
        then
            echo "[$(date +'%H:%M:%S')] Mount ${nserver}:${nserver_path} was successful."
            mountpoint -q ${local_path}
            if [[ "$?" -eq 0  ]]
            then
                echo "[$(date +'%H:%M:%S')] Host ${nserver}:${nserver_path} mounted, proceed..."
            else
                echo "[$(date +'%H:%M:%S')] ERROR! Mount ${nserver}:${nserver_path} was NOT successful. EXIT!"
                exit 1
            fi
        else
            echo "[$(date +'%H:%M:%S')] ERROR! Mount ${nserver}:${nserver_path} was NOT successful. EXIT!"
            exit 1
        fi
    fi
}

if [[ ! -d /mnt/backup ]]
then
        mkdir -p /mnt/backup
fi

echo "[$(date +'%H:%M:%S')] Starting DR process... preparing backup share..."

mount_nfs_dir ${nfs_backup_server} ${nfs_backup_share}/${nfs_backup_subshare} ${local_backup_share}

echo "[$(date +'%H:%M:%S')] Setting ownership..."
sudo chown -R oracle:oinstall ${local_backup_share}/*

