#!/bin/bash

url=https://loremflickr.com/320/240/cat
log=wget.log
count=1

while [ $count -le 28 ]
do
 name="pdkt_kusuma_"
 filename="$name$count"
 wget $url -O $filename -a $log
 count=$((count+1))
done

