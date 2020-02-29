#!/bin/bash

#soal 3A
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

#soal 3C
mkdir kenangan
mkdir duplicate

awk -F "\n" '/Location/{gsub("Location: /cache/resized/", ""); gsub("\\[following]", ""); print}' wget.log > name_log.txt

awk 'BEGIN{i=1;j=1;k=1}
{
 dup[$1]++
 if(dup[$1] > 1) {
        mov = "mv pdkt_kusuma_" i " duplicate/duplicate_" j
        j++
 }
 else {
        mov = "mv pdkt_kusuma_" i " kenangan/kenangan_" k
        k++
 }
 system(mov)
 i++
}' name_log.txt

cat wget.log | grep Location: > location.log.bak
