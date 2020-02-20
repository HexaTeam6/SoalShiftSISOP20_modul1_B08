#!/bin/bash

last=$(date +%H -r $1)

name=$1
IFS='.'
read -ra ADDR <<< "$name"
msg="${ADDR[0]}"

change=$msg

while [ $last -gt 0 ]
do
 change=$(echo $change | tr '[B-ZAb-za]' '[A-Za-z]')
 last=$((last-1))
done

mv $msg.txt $change.txt
