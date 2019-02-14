# opis #@(#) WERSJA=A.02.51 ; DATA=2012.01.30
#WERSJA=A.02.51 ; DATA=2012.01.30
# program dokumentacyjny do HP-UX ver. 10.x 11.x
# syntax:	./opis > file_name
# przyklad:	./opis > /var/service/pkobp11.bielsko_biala.hostname

# LISTA POLECEN:
#
# date 
# uname -a 
# getconf KERNEL_BITS
# model
# grep rev /var/adm/sw/products/OS-Core/CORE-KRN/INDEX 
# cat /etc/fstab 
# swapinfo 
# mount -p
# bdf 
# /usr/sbin/fstyp -v fs_nameX |head -3
# strings /etc/lvmtab 
# vgdisplay -v 
# lvdisplay -v lvolXX 
# lvlnboot -v 
# /usr/sbin/vxprint -rthA
# crashconf -v (11.x)
# cat /stand/system 
# sysdef
# kctune (11v2)
# what /stand/vmunix
# /usr/sbin/vxlicense -p | egrep "Feature|valid"
# /usr/bin/strvf | grep -v "^--" 
# show_patches -a (11.x)
# swlist 
# swlist -l product -x one_liner="name title"
# swlist -l fileset -x one_liner="name revision size state"
# grep -v '^#' /etc/rc.config.d/*
# ioscan -nf
# ioscan -m dsf (for 11.31 only)
# ioscan -m lun (for 11.31 only)
# ioscan -fnNk (for 11.31 only)
# sasmgr get_info (for 11.31 only)
# rad -q
# parstatus
# vparstatus -v
# vparstatus -A
# xpinfo -d
# spmgr display
# setboot
# cat /etc/inittab 
# cat /etc/switch/Switchinfo
# /etc/switch/disklock -t boot_disk
# cmviewcl -v
# cmviewconf
# arp -a
# lanscan 
# ifconfig lanX 
# netstat -in
# netstat -rn
# nwmgr
# hpvmstatus
# hpvmstatus -P
# hpvmnet
# hpvmnet -V
# cat /etc/hosts 
# cat /etc/resolv.conf 
# grep -v '^#' /etc/bootptab 
# cat /etc/auto_master
# cat /etc/auto.direct
# /usr/sbin/hpC2400/arrayinfo
# lpstat -s 
# /opt/dtcmgr/sbin/dtclist -c dtc_name
# /opt/rdtcmgr/sbin/rdtclist -c dtc_name
# cat /etc/ddfa/dp
# dmesg 
# grep -i error /etc/rc.log
# ps -ef 
# cat /var/adm/sbtab 
# cstm->sall->info->il->v
# /usr/contrib/bin/machinfo
# nwmgr
# ioscan -m lun 
# hpvmstatus i hpvmstatus -P 
# /opt/propplus/bin/cprop -summary -c Processors
# /opt/propplus/bin/cprop -summary -c Memory


# ZMIANY:
#

# A.02.01 - dodane listowanie /etc/rc.config.d/* configuration variables
#         - przesuniecie na koniec listowania zbioru /var/adm/sbtab
#         - dodana sekcja LISTA POLECEN
#         - dodana sekcja ZMIANY
#         - dodane dopisywanie linii koncowej z WERSJA i DATA programu opis
# A.02.02 - dodana opcja n do ioscan
#	  - zmieniony argument komendy diskinfo na c*t*d* 
# A.02.03 - zmieniony argument komendy diskinfo na c*t*d?
# A.02.04 - usunieta komenda diskinfo
# A.02.05 - dodane komendy swlist -l product oraz swlist -l fileset
# A.02.06 - wersja dla idm_pbi: dodane komendy zbierajace informacje o SG
# A.02.07 - wersja dla idm_pbi: dodane dtclist i nailed device config
# A.02.08 - wersja dla idm_pbi: dodane listowanie konfiguracji routera
# A.02.09 - usuniete listowanie zbiorow kernrel i bootconf
#         - dodana rejestracja konfiguracji clustra SG, dtclist i ddfa
#         - dodane komendy model, sysdef, identyfikator dla what
#         - dodana mapa pamieci przy uzyciu sysdiag
#         - dodany nowy format daty 
# A.02.10 - zmieniona rejestracja zbioru /etc/bootptab
#         - dodana rejestracja wersji JFS'a w fstyp
#         - dodane what /stand/vmunix
# A.02.11 - dodane rdtclist
# A.02.12 - poprawione wywolanie fstyp
# A.02.13 - dodany filtr do dtclist
# A.02.14 - wykonywanie lvdisplay rowniez jesli nie ma mirroru
#         - dodane szukanie bledow w /etc/rc.log
#         - dodana opcja "state" do swlist -l fileset
#         - poprawione "ifconfig lanX" dla kompatybilnosci z 11.0
#         - dodane info o pamieci przy uzyciu cstm
# A.02.15 - poprawione wywolanie polecen dtclist
#         - dodane info o typach procesorow
# A.02.16 - poprawione info o pamieci (bez zbioru posredniego)
# A.02.17 - usuniecie wycinkowych informacji o procesorach/pamieci (cstm) 
#         - dodanie pelnej mapy hardware'u na koncu (cstm)
#         - dodanie informacji o sciezkach bootowania (polecenie setboot)
#         - korekta wyswietlania "busy/done" dla terminali # hp
# A.02.18 - dodanie sprawdzania poprawnosci STREAMS
#         - poprawka filtrowania /etc/rc.config.d
#         - wyswietlanie poziomu systemu
#         - swapinfo: dodanie -mt
#         - dodanie zmiennej skryptu: UNIX = 10 lub 11
#         - zastapienie sysdef przez kmtune w 11.x
#         - dodanie wyswietlania konfiguracji dump'u (crashconf)
# A.02.19 - dodanie show_patches -a
# A.02.20 - poprawienie sekcji hpC2400
# A.02.30 - zbieranie konfiguracji VxVM 
#	  - lista dyskow XP
#	  - zamiana cmviewcl na cmscancl
#	  - dodanie cmviewconf
# A.02.31 - poprawiona funkcja ecad() - zerowanie zmiennej 'a' po
# damjan    wykonaniu; wykonanie tylko gdy zmienna 'a' jest ustawiona
#         - zbieranie konfiguracji vPars
#         - zbieranie nie zboundowanych resource-ow vPars
#	  - zmiana xpinfo -d | awk na bez awk
# A.02.32 - wyswietlanie szerokosci kernela: getconf KERNEL_BITS
#         - badanie (nie)obecnosci produktow Veritasa: vxlicense -p
#         - wyswietlanie modulow OLA/R: rad -q
#	  - zamiana cmscancl na cmviewcl
# A.02.34 - dodanie mount -p
#         - zbieranie konfiguracji automountera (auto_master i auto.direct)
#         - zbieranie konfiguracji nPars (parstatus -V)
#         - dodanie "netstat -in"
#         - zamiana "netstat -r" na "netstat -rn"
#         - dodanie "machinfo" dla 11.23
#         - dodanie "spmgr display" dla EVA'y.
# A.02.35 - zmiana parstatus -V na parstatus
#	  - dodanie kctune (11.31 only)
#	  - dodanie ioscan -m dsf (11.31 only)
#	  - dodanie ioscan -fNnk (11.31 only)
# A.02.40 - dodanie nwmgr (11.31 only)
#	  - dodanie ioscan -m lun (11.31 only)
#	  - dodanie hpvmstatus i hpvmstatus -P (11.31 only)
#	  - dodanie hpvmnet i hpvmnet -V (11.31 only)
# 	  - dodanie sasmgr get_info -D /dev/sasd* (11.31 only)
# 	  - dodanie /opt/propplus/bin/cprop -summary -c Processors (11.31 only)
# 	  - dodanie /opt/propplus/bin/cprop -summary -c Memory (11.31 only)
# A.02.50 - dodanie sasmgr get_info -D /dev/sasd* -q lun=all -q lun_locate (11.31 only)
#	  - dodanie sautil /dev/ciss* -s (11.31 only)
# A.02.51 - dodanie testowania obecnosci nowych funkcjonalnosci

ecad()	# execute command and display
{
  if [ "dupa$a" != "dupa" ] ; then
    echo "[busy] $a \r\c" >&2
    echo "## $a ##"
    /sbin/sh -c "$a"
    echo
    echo "[done] $a" >&2
    a=""
  fi
}

echo >&2

# UNIX = 10 lub 11 oraz RELEASE = 11, 23 lub 31
/usr/bin/uname -r | tr '.' ' ' | read a UNIX RELEASE

echo "[busy] /sbin/date \r\c" >&2
echo "## /sbin/date ##"
DATE1=`/sbin/date +%Y%m%d%H%M`
DATE2=`/sbin/date`
echo "$DATE1 $DATE2"
echo
echo "[done] /sbin/date" >&2

a="/usr/bin/uname -a"
ecad

a="/usr/bin/getconf KERNEL_BITS"
ecad

a="/bin/model"
ecad

if [ -f /var/adm/sw/products/OS-Core/CORE-KRN/INDEX ]
then
	a="grep rev /var/adm/sw/products/OS-Core/CORE-KRN/INDEX"
	ecad
fi

a="cat /etc/fstab"
ecad

a="/usr/sbin/swapinfo -mt"
ecad

a="/usr/sbin/mount -p"
ecad

a="/usr/bin/bdf"
ecad


echo "[busy] /usr/sbin/fstyp -v fs_nameX \r\c" >&2
echo "## /usr/sbin/fstyp -v fs_nameX |head -3 ##"
for FS in `/usr/sbin/mount -l | cut -f 3 -d " " | sort` ; do
  PARM1=`/usr/sbin/fstyp -v $FS | head -1`
  PARM2=`/usr/sbin/fstyp -v $FS | grep f_bsize`
  PARM3=`/usr/sbin/fstyp -v $FS | grep version`
  echo $FS $PARM1 $PARM2 $PARM3
done
echo
echo "[done] /usr/sbin/fstyp -v fs_nameX" >&2

a="/usr/bin/strings /etc/lvmtab"
ecad

a="/usr/sbin/vgdisplay -v"
ecad

if [ -f /etc/lvmpvg ] ; then
  a="cat /etc/lvmpvg"
  ecad
fi

echo "[busy] /usr/sbin/lvdisplay -v lvolXX \r\c" >&2
echo "## /usr/sbin/lvdisplay -v lvolXX |head -25 ##"
LVOL=`/usr/sbin/vgdisplay -v | grep "LV Name" | cut -c 27-`
for i in $LVOL ; do
  /usr/sbin/lvdisplay -v $i | grep -v current
  /usr/sbin/lvdisplay -v $i | grep 0000
  echo
done
echo
echo "[done] /usr/sbin/lvdisplay -v lvolXX" >&2

a="/usr/sbin/lvlnboot -v"
ecad

if /usr/sbin/vxprint -rthAa >/dev/null 2>&1 ; then
  a="/usr/sbin/vxprint -rthA"
  ecad
fi

if [ "$UNIX" = "11" ] ; then
  a="/sbin/crashconf -v"
  ecad
fi

a="cat /stand/system"
ecad

if [ "$UNIX" = "10" ] ; then
  a="/usr/sbin/sysdef"
  ecad
fi


if [ "$UNIX" = "11" ] ; then
if [ "$RELEASE" = "31" ] ; then
  a="/usr/sbin/kctune"
  ecad
else
  a="/usr/sbin/kmtune"
  ecad
fi
fi

# if [ "$UNIX" = "11" ] ; then
#   a="/usr/sbin/kmtune"
#   ecad
# fi

a="what /stand/vmunix"
ecad

if [ -x /usr/sbin/vxlicense ] ; then
  a='/usr/sbin/vxlicense -p | egrep "Feature|valid"'
  ecad
fi

a="/usr/bin/strvf | grep -v \"^--\" "
ecad

if [ -f /tcb/files/auth/system/default ] ; then
  echo "Level: C2\n"
else
  echo "Level: C1\n"
fi

if [ "$UNIX" = "11" ] ; then
  a="/usr/contrib/bin/show_patches -a"
  ecad
fi

a="/usr/sbin/swlist"
ecad

a='/usr/sbin/swlist -l product -x one_liner="name title"'
ecad

echo '[busy] /usr/sbin/swlist -l fileset -x one_liner="name revision size state" \r\c' >&2
echo "## /usr/sbin/swlist -l fileset -x one_liner="name revision size state" ##"
/usr/sbin/swlist -l fileset -x one_liner='name revision size state' \
 | sed -e "s/      //" | pr -e8 -t | sed -e "s/      /  /"
echo
echo '[done] /usr/sbin/swlist -l fileset -x one_liner="name revision size state"' >&2

echo "[busy] /usr/bin/grep -v '#' /etc/rc.config.d/* \r\c" >&2
for i in `ls /etc/rc.config.d/*` ; do
  echo "## /usr/bin/grep -v '#' $i ##"
  grep -v "^#" $i |grep -v "^$"
  echo
done
echo "[done] /usr/bin/grep -v '#' /etc/rc.config.d/*" >&2

a="/usr/sbin/ioscan -nf"
ecad


if [ "$UNIX" = "11" ] ; then
if [ "$RELEASE" = "31" ] ; then
  a="/usr/sbin/ioscan -fNnk"
  ecad
fi
fi

if [ "$UNIX" = "11" ] ; then
if [ "$RELEASE" = "31" ] ; then
  a="/usr/sbin/ioscan -m dsf"
  ecad
fi
fi

if [ "$UNIX" = "11" ] ; then
if [ "$RELEASE" = "31" ] ; then
  a="/usr/sbin/ioscan -m lun"
  ecad
fi
fi

if [ "$UNIX" = "11" -a "$RELEASE" = "31" ] ; then
if [ -x /opt/sas/bin/sasmgr ] ; then
if ls /dev/sasd* > /dev/null 2>&1
then
for i in /dev/sasd*
do
	a="/opt/sas/bin/sasmgr get_info -D $i; /opt/sas/bin/sasmgr get_info -D $i -q raid; /opt/sas/bin/sasmgr get_info -D $i -q lun=all -q lun_locate"
	ecad
done
fi
fi
fi


if [ "$UNIX" = "11" -a "$RELEASE" = "31" ] ; then
if [ -x /usr/sbin/sautil ] ; then
if ls /dev/ciss* > /dev/null 2>&1
then
for i in /dev/ciss*
do
	a="sautil $i -s"
	ecad
done
fi
fi
fi

if /usr/bin/rad -q >/dev/null 2>&1 ; then
  a="/usr/bin/rad -q"
  ecad
fi

if /usr/sbin/parstatus >/dev/null 2>&1 ; then
  a="/usr/sbin/parstatus"
  ecad
fi

if [ -f /sbin/vparstatus ] ; then
  a="/sbin/vparstatus -v"
  ecad
fi

if [ -f /sbin/vparstatus ] ; then
  a="/sbin/vparstatus -A"
  ecad
fi

if [ -f /usr/contrib/bin/xpinfo ] ; then
  a='/usr/contrib/bin/xpinfo -d'
  ecad
fi

if /sbin/spmgr display >/dev/null 2>&1 ; then
  a="/sbin/spmgr display"
  ecad
fi

a="/usr/sbin/setboot | grep t"
ecad

a="cat /etc/inittab"
ecad

if [ -f /etc/switch/Switchinfo ] ; then
  a="cat /etc/switch/Switchinfo"
  ecad
  if [ -x /etc/switch/disklock ] ; then
    a="/etc/switch/disklock -t boot_disk"
    echo "[busy] $a \r\c" >&2
    for i in `/usr/sbin/lvlnboot -v | grep Root: | cut -c 27-` ; do
      echo "## /etc/switch/disklock -t /dev/rdsk/$i ##"
      /etc/switch/disklock -t /dev/rdsk/$i
      echo
    done
    echo "[done] $a" >&2
  fi
fi

if /usr/sbin/cmviewcl >/dev/null 2>&1 ; then
  a="/usr/sbin/cmviewcl -v"
  ecad
fi

if [ -f /usr/sbin/cmviewconf ] ; then
  a="/usr/sbin/cmviewconf"
  ecad
fi

a="/usr/sbin/arp -a"
ecad

a="/usr/sbin/lanscan"
ecad

a="/usr/sbin/ifconfig lanX"
echo "[busy] $a \r\c" >&2
for i in `/usr/sbin/lanscan | grep lan | awk '{print $5}'` ; do
  echo "## ifconfig $i ##"
  /usr/sbin/ifconfig $i
  echo
done
echo "[done] $a" >&2

a="/usr/bin/netstat -in"
ecad

a="/usr/bin/netstat -rn"
ecad

if [ "$UNIX" = "11" -a "$RELEASE" = "31" ] ; then
  a="/usr/sbin/nwmgr"
  ecad
fi

if [ "$UNIX" = "11" -a \( "$RELEASE" = "31" -o "$RELEASE" = "23" \) ] ; then
if [ -x /opt/hpvm/bin/hpvmstatus ] ; then
  a="/opt/hpvm/bin/hpvmstatus"
  ecad
fi
fi

if [ "$UNIX" = "11" -a \( "$RELEASE" = "31" -o "$RELEASE" = "23" \) ] ; then
if [ -x /opt/hpvm/bin/hpvmstatus ] ; then
#a="/usr/sbin/hpvmstatus -P vmname"
#echo "[busy]  /usr/sbin/hpvmstatus -P vm_name \r\c" >&2
for i in `/opt/hpvm/bin/hpvmstatus | grep GB | awk '{print $1}'` ; do
#  echo "## hpvmstatus -P $i ##"
  a="/opt/hpvm/bin/hpvmstatus -P $i"
  ecad
done
fi
fi

if [ "$UNIX" = "11" -a \( "$RELEASE" = "31" -o "$RELEASE" = "23" \) ] ; then
if [ -x /opt/hpvm/bin/hpvmnet ] ; then
  a="/opt/hpvm/bin/hpvmnet"
  ecad
fi
fi

if [ "$UNIX" = "11" -a \( "$RELEASE" = "31" -o "$RELEASE" = "23" \) ] ; then
if [ -x /opt/hpvm/bin/hpvmnet ] ; then
  a="/opt/hpvm/bin/hpvmnet -V"
  ecad
fi
fi

a="cat /etc/hosts"
ecad

if [ -f /etc/resolv.conf ] ; then
  a="cat /etc/resolv.conf"
  ecad
fi

if [ -f /etc/bootptab ] ; then
  a="egrep -v '^#|^$' /etc/bootptab"
  ecad
fi

if [ -f /etc/auto_master ] ; then
  a="cat /etc/auto_master"
  ecad
fi

if [ -f /etc/auto.direct ] ; then
  a="cat /etc/auto.direct"
  ecad
fi

LUNS=/etc/hpC2400/hparray.luns
if [ -s $LUNS ] ; then
  a="disk array informations"
  echo "[busy] $a \r\c" >&2
  echo "## $a ##"
  echo
  echo
  echo "## cat /etc/hpC2400/hparray.luns ##"
  cat $LUNS
  echo
  for i in `cat $LUNS|awk '{print $3}'` ; do
    for k in "/usr/sbin/hpC2400/arrayinfo -s $i" \
             "/usr/sbin/hpC2400/arrayinfo -dr $i" \
             "/usr/sbin/hpC2400/arrayinfo -ar $i" \
             "/usr/sbin/hpC2400/arrayinfo -m $i" \
             "/usr/sbin/hpC2400/dsp -l $i" \
             "/usr/sbin/hpC2400/dcc -d $i" \
             "/usr/sbin/hpC2400/arrayinfo -j $i"
      do
        echo
        echo "## $k ##"
        $k
    done
  done
  echo "[done] $a" >&2
fi

a="/usr/bin/lpstat -s"
ecad

if [ -x /opt/dtcmgr/sbin/dtclist ] ; then
  CHK=`/opt/dtcmgr/sbin/dtclist -c`
else
  CHK=""
fi
if [ "$CHK"z != ""z ] ; then
  echo "[busy] /opt/dtcmgr/sbin/dtclist -c dtcX \r\c" >&2
  for i in `/opt/dtcmgr/sbin/dtclist -c |/usr/bin/cut -f 1 -d "  "` ; do
    echo "## /opt/dtcmgr/sbin/dtclist -c $i ##"
    /opt/dtcmgr/sbin/dtclist -c $i |grep -v "^$" |tr -d "\014"
    echo
  done
  echo "[done] /opt/dtcmgr/sbin/dtclist -c dtcX" >&2
fi

if [ -x /opt/rdtcmgr/sbin/rdtclist ] ; then
  CHK=`/opt/rdtcmgr/sbin/rdtclist -d`
else
  CHK=""
fi
if [ "$CHK"z != ""z ] ; then
  echo "[busy] /opt/rdtcmgr/sbin/rdtclist -c dtcX \r\c" >&2
  for i in `/opt/rdtcmgr/sbin/rdtclist -d |/usr/bin/cut -f 1 -d "  "` ; do
    echo "## /opt/rdtcmgr/sbin/rdtclist -c $i ##"
    /opt/rdtcmgr/sbin/rdtclist -c $i |grep -v "^$" |tr -d "\014"
    echo
  done
  echo "[done] /opt/rdtcmgr/sbin/rdtclist -c dtcX" >&2
fi

if [ -f /etc/ddfa/dp ] ; then
  a="cat /etc/ddfa/dp"
  ecad
fi

if [ -f /etc/ddfa/pcf ] ; then
  a="cat /etc/ddfa/pcf"
  ecad
fi

a="/usr/sbin/dmesg"
ecad

a="grep -i error /etc/rc.log"
ecad

a="/usr/bin/ps -ef"
ecad

a="cat /var/adm/sbtab"
ecad

CHK=`ps -ef |grep DIAGMON |grep -v grep`
if [ "$CHK"z != ""z ] && [ -x /usr/sbin/sysdiag ] ; then
  echo "[busy] sysdiag->sysmap->memmap \r\c" >&2
  echo "## sysdiag->sysmap->memmap ##"
  echo "sysmap\nmemmap\nexit\nexit" | sysdiag |grep MBYTES
  echo
  echo "[done] sysdiag->sysmap->memmap" >&2
fi

CHK=`ps -ef |grep diagmond |grep -v grep`
if [ "$CHK"z != ""z ] && [ -x /usr/sbin/cstm ] ; then
  echo "[busy] cstm->sall->info->il->v \r\c" >&2
  echo "## cstm->sall->info->il->v ##"
  echo ' sall\n info\n wait\n il\n v' | /usr/sbin/cstm | sed '1,/View/d' | egrep -v "Done|the file\." 
  echo
  echo "[done] cstm->sall->info->il->v" >&2
fi

a="/usr/contrib/bin/machinfo"
[ -x /usr/contrib/bin/machinfo ] && ecad

if [ "$UNIX" = "11" -a "$RELEASE" = "31" ] ; then
if model | grep -v Virtual > /dev/null ; then
  a="/opt/propplus/bin/cprop -summary -c Processors"
  ecad
  a="/opt/propplus/bin/cprop -summary -c Memory"
  ecad
fi
fi


echo "WERSJA: $WERSJA     DATA: $DATA"
echo >&2

