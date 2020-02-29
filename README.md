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

### Penyelesaian

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
##### Penjelasan
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

## SOAL 2
Dalam soal ini kita diminta untuk membuat sebuah script **bash** yang dapat menghasilkan password secara acak sebanyak 28 
karakter yang terdiri dari **huruf besar**, **huruf kecil**, dan **angka**. Password tersebut 
kemudian disimpan pada file yang berekstensi **.txt** dengan nama berdasarkan argumen 
yang diinputkan dan nama file hanya berupa alphabet. Nama file yang diinputkan 
akan dienkripsi menggunakan _**Caesar Cipher**_ yang disesuaikan dengan jam file tersebut 
dibuat (0-23). Selain itu, kita diminta juga untuk membuat sebuah script **bash** 
untuk mendekripsi kembali nama file yang telah kita buat sebelumnya.

### Penyelesaian

#### Enkripsi
Dalam script **bash** **soal2_enkripsi**, pertama – tama  akan dibuat passwordnya terlebih dahulu dengan
```
PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 28 | head -n 1)
``` 
dimana kode diatas akan membentuk sebuah string secara acak yang terdiri dari huruf besar, huruf kecil, dan angka dengan 
panjang 28 karakter. Lalu string tersebut akan disimpan oleh variable `PASS`.

Untuk mengambil jam (waktu) saat ini, digunakan
```
hour=`date +"%H"`
```
dimana angka jam saat ini akan disimpan di sebuah variable `hour`.

Untuk mengambil nama file .txt yang diinputkan, digunakan
```
name=$1
IFS='.'
read -ra ADDR <<< "$name"
msg="${ADDR[0]}"
```
dimana argumen yang diinputkan akan dipisah menggunakan field separator `‘.’` 
sehingga kita mendapatkan nama file dengan memisah argumen yang dibatasi dengan 
karakter `‘.’` dan string pada kolom pertama akan disimpan dalam sebuah variable 
`msg`.

Setelah mendapatkan nama file, nama file tersebut perlu dienkripsi menggunakan 
**_Caesar Cipher_** yaitu dengan
```
while [ $hour -gt 0 ]
do
 	change=$(echo $msg | tr '[A-Za-z]' '[B-ZAb-za]')
 	hour=$((hour-1))
 	msg=$change
done
```
dimana nama file yang disimpan dalam variable msg akan digeser sebanyak jumlah 
yang disimpan dalam variabel `hour`. Nama file akan diubah menggunakan `tr ‘[ ]‘ ‘[ ]‘` 
dimana pada kolom square brackets pertama adalah asal huruf dan kolom square 
brackets kedua adalah penggeseran huruf yang kita inginkan. Looping dalam kode 
ini digunakan untuk mengulang penggeseran karakter sehingga terjadi penggeseran 1 karakter 
sebanyak n kali (looping).

Setelah nama file baru selesai dibuat, password yang tekah disimpan dalam variabel PASS akan disimpan ke file **.txt** baru 
dengan
````
echo $PASS >> $change.txt
````
dimana `>>` berguna untuk mengalihkan isi dari variabel `PASS` menuju ke  file **.txt** yang kita tuju.

#### Dekripsi
Dalam script bash **soal2_dekripsi.sh**, pertama – tama akan mengambil waktu last modified yang kita masukkan dalam argument dengan
````
last=$(date +%H -r $1)
````
dimana jam waktu terakhir file tersebut dibuat akan diambil dan dimasukkan ke dalam variabel last.

Setelah itu kita akan mengambil nama file yang telah diinputkan pada argument dengan
````
name=$1
IFS='.'
read -ra ADDR <<< "$name"
msg="${ADDR[0]}"
change=$msg
````
dimana nama file akan dipisah menggunakan field separator `‘.’` dan string yang 
ada pada kolom pertama akan disimpan dalam variabel `msg` dan `change`. 

Setelah mendapatkan nama file, nama file yang terdapat pada variabel change akan 
di dekripsi dengan
````
while [ $last -gt 0 ]
do
 	change=$(echo $change | tr '[B-ZAb-za]' '[A-Za-z]')
 	last=$((last-1))
done
````
dimana nama file akan digeser sebanyak 1 huruf dengan perulangan sebanyak jam waktu yang telah disimpan dalam variable `last`.

Setelah mendekripsi nama file maka nama file yang lama akan di rename dengan 
````
mv $msg.txt $change.txt
````
dimana nama file yang lama akan dirubah ke nama file yang baru.

## SOAL 3 
Dalam soal ini kita diminta untuk membuat:

  1. Sebuah script untuk mendownload 28 gambar dari "https://loremflickr.com/320/240/cat" menggunakan command wget dan menyimpan 
     file dengan nama "pdkt_kusuma_NO" (contoh: pdkt_kusuma_1, pdkt_kusuma_2, pdkt_kusuma_3) serta menyimpan log messages wget 
     kedalam sebuah file "wget.log".
  2. Penjadwalan untuk menjalankan script setiap 8 jam dimulai dari jam 6.05 setiap hari kecuali hari sabtu.
  3. Sebuah script untuk mengidentifikasi gambar yang identik dari keseluruhan gambar yang terdownload tadi. Bila terindikasi 
     sebagai gambar yang identik, maka sisakan 1 gambar dan pindahkan sisa file identik tersebut ke dalam folder ./duplicate
     dengan format filename "duplicate_nomor" (contoh : duplicate_200, duplicate_201). Setelah itu lakukan pemindahan semua gambar 
     yang tersisa kedalam folder ./kenangan dengan format filename "kenangan_nomor" (contoh: kenangan_252, kenangan_253).
     Setelah tidak ada gambar di current directory, maka lakukan backup seluruh log menjadi ekstensi ".log.bak".
     
 ### Penyelesaian
 
 ### Soal 3.1
 Dalam script **bash** **soal3.sh** bagian 3A, pertama - tama kita akan menyimpan url download ke dalam variabel `url` dan menyimpan lokasi
 log ke variable `log`.
 ````
 url=https://loremflickr.com/320/240/cat
 log=wget.log
 ````
 Setelah itu kita akan melakukan looping untuk mendownload gambar sebanyak 28 gambar dengan
 ````
 count=1

 while [ $count -le 28 ]
 do
  name="pdkt_kusuma_"
  filename="$name$count"
  wget $url -O $filename -a $log
  count=$((count+1))
 done
 ````
 dimana variabel `filename` akan menyimpan gabungan nama dari `name` dan `count`. Lalu pada bagian ini
 ````
 wget $url -O $filename -a $log
 ````
 `wget` akan mendowload gambar dari link url yang telah kita simpan di variabel `url` dengan penamaan sesuai `filename` dan 
 log messages yang ada akan disimpan dalam `wget.log`.
 
 ### Soal 3.2
 Untuk membuat penjadwalan maka kita perlu membuka terminal pada jendela Linux. 
 Lalu untuk mengedit crontab dilakukan dengan perintah
 ````
 crontab -e
 ````
 Lalu kita perlu memasukkan penjadwalan yang diminta yaitu setiap 8 jam dimulai dari jam 6.05 setiap hari kecuali hari sabtu
 ````
 5 6-23/8 * * 0-5 bash /home/user/SoalShiftSISOP20_modul1_B08/soal3/soal3a.sh
 ````
 dimana 
 * `5` adalah menit (menit ke-5)
 * `6-23/8` adalah jam (dimulai dari jam 6 hingga 23 dengan jarak 8 jam) 
 * `0-5` adalah hari (minggu-jumat)
 
 ### Soal 3.3
 Penyelesaian soal 3.3 terdapat dalam script **bash** **soal3.sh** bagian 3C.
````
#Bagian 3C
mkdir kenangan
mkdir duplicate

awk -F "\n" '/Location/{gsub("Location: /cache/resized/", ""); gsub("\\[follow$

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
````

Pertama -  tama kita akan membuat directory dengan nama `kenangan` dan `duplicate`.
````
mkdir kenangan
mkdir duplicate
````

Lalu kita akan mengambil nama file menggunakan awk dan menyimpannya ke dalam file .txt dengan nama `name_log.txt`.
````
awk -F "\n" '/Location/{gsub("Location: /cache/resized/", ""); gsub("\\[follow$
````

Setelah mendapat nama file, kita akan membandingkan nama file antara satu file dengan file lainnya menggunakan array `dup[$1]` 
dengan nama file sebagai indeks. Untuk gambar yang belum pernah disimpan akan dimasukkan directory `kenangan` dengan 
nama `kenangan_no` dan apabila sudah pernah disimpan `dup[$1] > 1` maka akan disimpan ke dalam directory `duplicate` dengan 
nama `duplicate_no`.
````
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
````

Apabila semua gambar sudah dipisah ke dalam directory `kenangan` dan `dupluicate` maka location file pada `wget.log` akan dibackup ke `location.lg.bak`.
````
cat wget.log | grep Location: > location.log.bak
````

Sekian penyelesaian soal untuk praktikum SISOP Modul 1, atas perhatiannya kami ucapkan terima kasih.
