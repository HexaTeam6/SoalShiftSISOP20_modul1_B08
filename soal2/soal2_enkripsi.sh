#!/bin/bash
PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 28 | head -n 1)

hour=`date +"%H"`

name=$1
IFS='.'
read -ra ADDR <<< "$name"
msg="${ADDR[0]}"

while [ $hour -gt 0 ]
do
 change=$(echo $msg | tr '[A-Za-z]' '[B-ZAb-za]')
 hour=$((hour-1))
 msg=$change
done

echo $PASS >> $change.txt
