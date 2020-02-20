# SoalShiftSISOP20_modul1_B08

Soal Shift Modul 1 yang berfokus pada command command bash, awk, serta pengguanan crontab.

## SOAL 1
Whits adalah seorang mahasiswa teknik informatika. Dia mendapatkan tugas praktikum
untuk membuat laporan berdasarkan data yang ada pada file “Sample-Superstore.tsv”.
Namun dia tidak dapat menyelesaikan tugas tersebut.
 
 1. Tentukan wilayah bagian (region) mana yang memiliki keuntungan (profit) paling
   sedikit.
 2. Tampilkan 2 negara bagian (state) yang memiliki keuntungan (profit) paling
   sedikit berdasarkan hasil poin 1.
 3. Tampilkan 10 produk (product name) yang memiliki keuntungan (profit) paling
    sedikit berdasarkan 2 negara bagian (state) hasil poin 2.


### Soal 1.1 

Untuk mencari *region* yang memiliki keuntungan yang paling sedikit dari data **.cst**, 
kita perlu mengelompokkan dan menjumlahkan seluruh *profit* berdasarkan region. Berikut kesuluruhan _script_ menggunakan **bash** dan **awk** :

```
#!/bin/bash
# 1.1
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
```
#####Penjelasan
````
a=$(awk -F "\t"
````
pertama pada baris tersebut kita akan menyimpan keseluruhan hasil dari command **bash** 
yang ditulis pada sintaksis `$()` pada sebuah variabel `a`. Selanjutnya terdapat 
sintaksis `awk -F "\t"` digunakan untuk menjalankan perintah **awk** dengan `-F "\t"`
adalah format separator untuk saat membaca file **cst.**

````
FNR == 1 {next} 
````
digunakan agar langsung melewati baris pertama, hal ini dilakukan karena pada baris pertama file **cst.** 
tersebut digunkan sebagai nama kolom. 

````
{
    data[$13]+=$21
}
````
baris dimana file **cst.** di-iterasi per baris lalu disimpan pada sebuah array dengan nama kolom ke 13 (kolom _region_) 
sebagai nama indexnya dan ditotal *profit*nya berdasarkan index _region_ tersebut.

````
END{ 
    for(region in data){
        print data[region], region
    } 
}
````
`END{}` adalah bagian pada command **awk** yang akan dijalankan sekali di akhir setelah melakukan iterasi. 
Lalu gunakan `for` untuk menampilkan total array berdasarkan regionnya.

````
Sample-Superstore.tsv | sort -g | head -1
````
`Sample-Superstore.tsv` adalah nama file yang akan dibaca oleh **awk** lalu di **pipe** dengan perintah `sort -g` yang berfungsi 
untuk mengurutkan data floating number dari kecil dan terakhir perintah `head -1` untuk mendapatkan data pada baris pertama.

````
region=$(cut -d' ' -f2 <<<"$a")
echo "Region dengan profit paling sedikit "$region
````
sintaksis `cut -d' ' -f2 <<<"$a"` digunakan untuk men-_split_ data dari variable `a` dengan delimiter `' '`
dan `-f2` untuk mendapatkan bagian kedua dari hasil _split_ tersebut lalu disimpan di variabel `region`. Lalu 
terkahir tinggal ditampilkan isi dari variabel `region` dengan perintah `echo`  

### Soal 1.2

berikut _script_ penyelesaiannya :

```
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
```
Sama halnya dengan soal 1.1 namun dengan sedikit perbedaan. Sintaksis `-v region="$regiom"` digunakan untuk menyiapkan variable 
yang dipakai oleh awk dengan isi region yang kita peroleh sebelumnya.
 
```
$13~region
```
digunakan untuk memfilter kolom 13 (_state_) berdasarkan isi dari variabel `region`.
 
```
state1=$(cut -d$'\n' -f1 <<<"$b")
state2=$(cut -d$'\n' -f2 <<<"$b")
```
digunakan untuk mendapatkan state pertama dan kedua dari variabel 

### Soal 1.3

berikut _script_ penyelesaiannya :

```
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
```
Sama halnya dengan soal 1.2 namun dengan sedikit perbedaan. Sintaksis `-v state1="$state1" -v state2="$state2` digunakan untuk menyiapkan variable 
yang dipakai oleh awk dengan isi state1 dan state2 yang kita peroleh sebelumnya.
 
```
$11~state1 || $11~state2
```
digunakan untuk memfilter kolom 11 (_produk name_) berdasarkan isi dari variabel `state1 state2`.
 
```
print data[product]"<>"product

```
membuat separator antara profit dan nama produk agar nanti setelah di sort dapat diperoleh nama produknya saja.