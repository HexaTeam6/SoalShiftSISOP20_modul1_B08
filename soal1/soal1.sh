#!/bin/bash
# 1 a
a=$(awk -F "\t" '
FNR == 1 {next} 
{
    data[$13]+=$21
} 
END{ 
    for(region in data){
        print data[region], region
    } 
}' Sample-Superstore.tsv | sort -g | head -1)

region=$(cut -d' ' -f2 <<<"$a")
echo "Region dengan profit paling sedikit "$region

# 1 b
b=$(awk -F "\t" -v region="$region" '
FNR == 1{next}
$13~region{
    data[$11]+=$21
} 
END{
    for(state in data){
        print data[state], state
    } 
}' Sample-Superstore.tsv | sort -g | head -2 | awk '{print $2}')
state1=$(cut -d$'\n' -f1 <<<"$b")
state2=$(cut -d$'\n' -f2 <<<"$b")
echo "State dengan profit paling sedikit $state1 dan $state2"

# 1 c
c=$(awk -F "\t" -v state1="$state1" -v state2="$state2" '
FNR == 1{next}
$11~state1 || $11~state2{
    data[$17] += $21
} 
END{
    for(product in data){
        print data[product]"<>"product
    } 
}' Sample-Superstore.tsv | sort -g | head -10 | awk -F "<>" '{print $2}')
echo -e "\nProduk dengan profit paling rendah di State $state1 dan $state2: \n$c"