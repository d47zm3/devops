et LC_ALL

dir_suffix=`date +'%d_%m_%Y'`

server_name=$1
exit_code=0

if [[ -z "${server_name}" ]]
then
        echo "Server Name required!"
        exit 1
fi

backup_nas=1.1.1.1:/${server_name}/
echo "[$(date +'%H:%M:%S')] Starting AIX backup, server ${server_name}..."
echo "[$(date +'%H:%M:%S')] Destination is ${backup_nas}..."
mkdir -p /mnt/backup_aix

chmod -R 755 /mnt/backup_aix/
chown -R root /mnt/backup_aix/


echo "[$(date +'%H:%M:%S')] Checking if NFS share is mounted..."
df -g | grep -q "backup_aix"
if [ $? != 0 ]
then
        echo "[$(date +'%H:%M:%S')] NFS share is not mounted, mounting..."
        mount -v nfs -o timeo=10,retrans=1,retry=1,soft ${backup_nas} /mnt/backup_aix
fi

df -g | grep -q "backup_aix"
if [ $? == 0 ]
then
        echo "[$(date +'%H:%M:%S')] NFS share is mounted, proceed..."
        echo "[$(date +'%H:%M:%S')] Creating directory structure..."
        mkdir /mnt/backup_aix/mksysb_${dir_suffix}
        extdir=/mnt/backup_aix/mksysb_${dir_suffix}
        for i in mksysb_target tmp iso mkcd; do
               test -d $extdir/$i || mkdir $extdir/$i || exit 1
        done


        echo "[$(date +'%H:%M:%S')] Setting permissions..."
        chmod -R 755 /backup_aix/
        chown -R root /backup_aix/
        echo "[$(date +'%H:%M:%S')] Starting backup..."
        /usr/sbin/mkdvd -M $extdir/mksysb_target -C $extdir/tmp -I $extdir/iso -S
        mkdvd_ec=$?
        if [[ $mkdvd_ec == 0 ]]
        then
                echo "[$(date +'%H:%M:%S')] Backup was successful, exit code was 0!"
        else
                echo "[$(date +'%H:%M:%S')] Backup was NOT successful, exit code was $mkdvd_ec!"
                exit_code=1
        fi
else

        echo "[$(date +'%H:%M:%S')] NFS share still not mounted, exit!"
        exit_code=1
fi

umount -f /mnt/backup_aix

exit $exit_code
