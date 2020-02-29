 
#!/bin/bash

# check dan buat file untuk nampung nama
if test ! -f "name_log.txt"; then
    touch name_log.txt
fi

# check dan buat folder
if test ! -d "duplicate"; then
    mkdir duplicate
fi

# check dan buat folder
if test ! -d "kenangan"; then
    mkdir kenangan
fi

url=https://loremflickr.com/320/240/cat
log=wget.log
count=1

while [ $count -le 28 ]
do
 name="pdkt_kusuma_"
 filename="$name$count"
 wget $url -O $filename -a $log

# mendapatkan nama file dari wget
 nama=$(grep "Location" wget.log | tail -1 | awk '{print $2}')

# check nama tersebut apakah sudah ada di list nama
 if [[ $(grep "$nama" name_log.txt) ]]
 then
#  check angka terakhir file duplicate
    last=$(ls duplicate/ | awk -F '_' '{print $2}' | sort -rn | head -1)

    if [[ $last ]]
    then
        mv "$(pwd)/pdkt_kusuma_$count" "$(pwd)/duplicate/duplicate_$(($last+1))"
    else
        mv "$(pwd)/pdkt_kusuma_$count" "$(pwd)/duplicate/duplicate_1"
    fi
 else
 #  check angka terakhir file kenangan
    last=$(ls kenangan/ | awk -F '_' '{print $2}' | sort -rn | head -1)

    if [[ $last ]]
    then
        mv "$(pwd)/pdkt_kusuma_$count" "$(pwd)/kenangan/kenangan_$(($last+1))"
    else
        mv "$(pwd)/pdkt_kusuma_$count" "$(pwd)/kenangan/kenangan_1"
    fi

    # menyimpan nama yang tidak duplicate ke list nama
    echo $nama >> name_log.txt
 fi

 count=$((count+1))
done

# membuat log.bak
cat wget.log >> wget.log.bak
# mengosongkan log
> wget.log
