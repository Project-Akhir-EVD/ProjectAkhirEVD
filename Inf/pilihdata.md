### **Tentang Aplikasi**

Aplikasi ini merupakan alat bantu untuk melihat korelasi antar 2 variabel dengan menggunakan plot pencar dan nilai korelasi, dalam aplikasi ini disediakan fitur untuk memilih sumber data yang akan digunakan pada saat melihat korelasi, jenis sumber data yang disediakan adalah:

1. Data Disediakan --> Data yang sudah disediakan dalam dashboard ini, terdapat 4 data yang sudah disediakan yaitu (cars, women, rock dan pressure)
2. Input Mandiri --> Fitur ini disediakan agar para pengguna dapat menggunakan data yang sesuai dengan yang diinginkan, maksimum file yang diperbolehkan dari fitur ini adalah **1 MB**


### **Deskripsi Data**


#### **Dataset `cars`**

Data diambil dari majalah Motor Trend AS tahun 1974, dan terdiri dari konsumsi bahan bakar dan 10 aspek desain dan kinerja mobil untuk 32 mobil (model 1973 sd. 1974). Dataset ini sudah tersedia dalam  _package_ `datasets` dan dapat digunakan bebas. Data ini terdiri dari 32 amatan/mobil yang diteliti kecepatannya. Dengan variabel yang dimiliki adalah sebagai berikut :

- mpg 	: ("Miles/(US) gallon)
- cyl 	: (Number of cylinders)
- disp 	: (Displacement (cu.in.))
- hp 	: (Gross horsepower)
- drat 	: (Rear axle ratio)
- wt 	: (Weight (1000 lbs))
- qsec 	: (1/4 mile time)
- vs 	: (Engine (0 = V-shaped, 1 = straight))
- am 	: (Transmission (0 = automatic, 1 = manual))
- gear 	: (Number of forward gears)

#### **Dataset `women`**

Dataset women merupakan data rata-rata tinggi dan berat badan wanita Ameriak yang berusia 30-39 tahun. Data ini juga sudah tersedia dalam  _package_ `datasets` dan dapat digunakan bebas dengan 2 variabel  yaitu height dan weight dan jumlah data sebanyak 15 observasi.

#### **Dataset `rock`**

Dataset ini merupakan data pengukuran sampel batuan minyak bumi, data ini terdiri dari 48 sampel batuan dari reservoir minyak bumi, dengan memiliki 3 variabel yaitu :
- area : (area of pores space, in pixels out of 256 by 256)
- peri : (perimeter in pixels)
- shape : (perimeter/sqrt(area))
Dataset ini sudah tersedia dalam  _package_ `datasets` dan dapat digunakan bebas.

#### **Dataset `pressure`**

Dataset ini digunakan untuk dapat melihat hubungan suhu dalam derajat Celcius dengan tekanan uap air raksa yang terdapat pada dalam milimeter (merkuri).
Data ini terdiri dari 2 variabel (Temperature dan Pressure) dengan 19 pengamatan. Dataset ini sudah tersedia dalam  _package_ `datasets` dan dapat digunakan bebas.


### **Definisi Output**

Berikut merupakan beberapa penjelasan terkait dengan yang akan di tampilkan pada jendela utama

#### **Statistik Deskriptif** 

- **Mean**: Rata-rata aritmetika dari suatu set data, dihitung dengan menjumlahkan semua nilai dan membaginya dengan jumlah pengamatan. (Kotz, Balakrishnan, & Johnson, 2000).

- **Ragam**: Ukuran sebar data yang mengukur variasi atau dispersi nilai-nilai dari mean. Dihitung sebagai rata-rata dari kuadrat deviasi setiap nilai dari mean. (Eisenhauer, 2003).

- **Nilai Minimum**: Nilai terkecil dalam suatu set data. Pemahaman ini penting dalam analisis statistik untuk menentukan rentang dan karakteristik distribusi data. (Everitt & Dunn, 2001).

- **Median**: Posisi tengah data saat diurutkan. Nilai yang membagi data menjadi dua bagian setara, dan sering digunakan sebagai ukuran tendensi sentral alternatif. (Hoaglin, Mosteller, & Tukey, 1983).

- **Nilai Maksimum**: Nilai terbesar dalam suatu set data. Penting untuk menilai rentang data dan menentukan nilai ekstrim. (Cramer, Rao, & Rao, 2002).

- **Variabel Independen**: Variabel yang dianggap sebagai penyebab atau pengendali dalam eksperimen atau analisis statistik. Manipulasi variabel ini mempengaruhi variabel dependen. (Creswell, 2014).

- **Variabel Dependen**: Variabel yang diukur atau diamati sebagai tanggapan terhadap perubahan dalam variabel independen. Menunjukkan efek atau hasil dari manipulasi variabel independen. (Creswell, 2014).

- **Plot Pencar (Scatter Plot)**: Jenis visualisasi data yang menunjukkan hubungan antar variabel dependen (_x_) dan variabel independen (_y_). Data ini ditunjukkan dengan menempatkan berbagai titik data di antara _sumbu x_ dan _sumbu y_.


#### **Analisis Korelasi Statistik**

##### **- Korelasi Pearson**

Korelasi person digunakan untuk mengukur kekuatan dan arah hubungan linear antara dua variabel. Nilai berkisar antara -1 dan 1, dengan 1 menunjukkan korelasi sempurna. (Pearson, 1895).

##### **- Korelasi Spearman**

Korelasi ini digunakan untuk metode non-parametrik yang mengukur hubungan monotik antara dua variabel. Digunakan untuk data ordinal atau ketika asumsi distribusi normal tidak terpenuhi. (Spearman, 1904).

##### **- Korelasi Kendalls Tau**

Korelasi non-parametrik yang mengukur hubungan monotik antara dua variabel. Kendalls Tau cocok untuk data ordinal dan sensitif terhadap tren monotik tanpa asumsi distribusi data. (Kendall, 1938).


