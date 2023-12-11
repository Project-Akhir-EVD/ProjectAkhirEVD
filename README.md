# Project Akhir EVD
Project Mata Kuliah Eksplorasi dan Visualisasi Data STA1563
## Kelompok 6

### Tim Pengembang:
- `Tahira Fulazzaky` `(G1501221024)`
- `Setyo Wahyudi` `(G1501222046)`
- `Bayu Paramita` `(G1501222052)`

## :scroll: Tentang

Proyek ini merupakan bagian dari tugas mata kuliah Eksplorasi dan Visualisasi Data yang bertujuan untuk memberikan pemahaman yang lebih baik tentang hubungan antara dua variabel dengan menggunakan diagram pencar (_scatter plot_) dan menganalisis korelasinya. Dashboard interaktif ini dikembangkan menggunakan **Shiny R**, sebuah framework web untuk membuat aplikasi interaktif dengan menggunakan **R**.

## :rice_scene: Screenshot


## :dvd: Demo

Berikut merupakan tautan untuk mendemokan aplikasi ShinyApp

| url                      |
| ------------------------ |
| https://mds6.shinyapps.io/Scatter_Plot_Correlation/ |

## :bookmark_tabs: _Side Bar_

- Input data: pengguna bisa menggunakan data sendiri ataupun data yang sudah disediakan.
- Pengguna dapat memilih variabel bebas (_X_) dan variabel dependen (_Y_) untuk diagram pencar.
- Penguna bisa memilih korelasi statistik yang akan ditampilkan diantara tiga pilihan, yaitu korelasi _Pearson_, _Spearman_, dan _Kendall Tau_.
- Tren penghalusan (_smooth trend_)
- Trend lurus (linear)

## :bookmark_tabs: _Main_

- Deskripsi data yang meliputi: 
    - nama peubah, 
    - jumlah, 
    - rata-rata, 
    - ragam, 
    - nilai terkecil, 
    - median, dan
    - nilai terbesar
- Diagram pencar disertai garis tren yang dipilih pengguna.
- Tabel yang menampilkan statistik untuk mengukur hubungan variabel bebas (_X_) dan variabel dependen (_Y_) dengan jenis korelasi statistik sesuai pilihan pengguna.
