#!/bin/bash

orasid=( ORASID ORASID )
backup_path="/mnt/backup"
ouser=oracle
ogroup=oinstall
check_nfs=1 # we check if backup path is mounted as NFS
echo "[$(date +'%H:%M')] ### Creating RMAN scripts for ${orasid[@]}, base backup destination is ${backup_path} ###"

if [[ "${check_nfs}" -eq 1 ]]
then
        echo "[$(date +'%H:%M')] Checking NFS mounts..."
        mount | grep -q "${backup_path}"
        if [[ "$?" -eq 0 ]]
        then
                echo "[$(date +'%H:%M')] Backup path ${backup_path} seems mounted..."
        else
                echo "[$(date +'%H:%M')] Backup path ${backup_path} is not mounted! Exit! (disable check in script if you want to)"
                exit 1
        fi
fi

for sid in "${orasid[@]}"
do
        orasid=${sid}
        orasidbig=${orasid^^}
        oradate=$( date +'%d_%m_%Y' )
        oradatesuffix=$( date +'%d%m%Y' )
        final_backup_path="${backup_path}/${orasid}/${oradate}"
        if [[ ! -d "${final_backup_path}" ]]
        then
                echo "[$(date +'%H:%M')] Backup path does not exist... attempting to create it..."
                mkdir "${final_backup_path}"
                if [[ "$?" -ne 0 ]]
                then
                        echo "[$(date +'%H:%M')] Creating directory failed! Exiting..."
                        exit 1
                else
                        echo "[$(date +'%H:%M')] Successfully created backup destination... proceeding..."
                fi
        else
                echo "[$(date +'%H:%M')] Backup destination exists... Proceeding..."
                echo "[$(date +'%H:%M')] Checking permissions on backup directory (oracle:oinstall)..."
                backup_user_base=$( stat -c %U ${backup_path} )
                backup_group_base=$( stat -c %G ${backup_path} )
                backup_user_final=$( stat -c %U ${backup_path} )
                backup_group_final=$( stat -c %G ${backup_path} )
                if [[ "${backup_user_base}" == "${ouser}" ]] && [[ "${backup_user_final}" == "${ouser}" ]] && [[ "${backup_group_base}" == "${ogroup}" ]] && [[ "${backup_group_final}" == "${ogroup}"  ]]
                then
                        echo "[$(date +'%H:%M')] Permissions are OK (${ouser}:${ogroup})..."
                else
                        echo "[$(date +'%H:%M')] Permissions are not OK, they need to be (${ouser}:${ogroup})... (or fix them in script!), exit!"
                        exit 1
                fi

        fi

        echo "[$(date +'%H:%M')] Creating RMAN scripts..."

        sed -e "s/ORASID/${orasid}/g" -e "s/ORADATE/${oradate}/g" -e "s/ORATAG/${orasidbig}/g" -e "s/ORATDATE/${oradatesuffix}/g" -e "s#BPATH#${backup_path}#g" /home/oracle/tmp.rman.backup.template > /home/oracle/tmp.rman.backup.${orasid}
done
