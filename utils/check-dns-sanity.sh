#!/bin/bash

domain="google.com"

nameservers=( $( dig ${domain} ns | egrep "IN.*NS" | grep -v "^;" | awk ' { print $NF } ' | xargs ) )


rm -f _tmp_addresses
> _tmp.addresses

for nameserver in "${nameservers[@]}"
do
  dig @${nameserver} nwt.se | grep -A3 ";; ANSWER SECTION:" | tail -n3 | awk ' { print $NF } ' | sort -n -t . -k1,1 -k2,2 -k3,3 -k4,4 >> _tmp.addresses
done

echo "Currently resolved addresses are... "
cat _tmp.addresses | sort -n -t . -k1,1 -k2,2 -k3,3 -k4,4 | uniq
total=$( cat _tmp.addresses | sort -n -t . -k1,1 -k2,2 -k3,3 -k4,4 | uniq | wc -l )
if [[ ${total} -eq 3 ]]
then
  echo "No bogus entries found..."
  exit 0
else
  echo "Found invalid addresses! Check it!"
  exit 1
fi

rm -f _tmp_addresses
