Reservation App – Flutter Project

Aplikasi ini adalah project UAS Flutter yang menggabungkan fitur reservasi layanan, pembelian produk kecantikan dari API publik, sistem keranjang (cart), pembayaran simulasi, dan profile management dengan data persistence.

Aplikasi ini dibangun menggunakan Flutter, Provider State Management, dan memanfaatkan API Makeup untuk menampilkan produk kecantikan secara real-time.

Fitur Utama
1. Reservasi Layanan Salon

Memilih layanan seperti Haircut, Facial, Manicure, Massage.

Memilih tanggal & jam (DatePicker & Gesture Time Picker).

Input data pelanggan (Nama, No HP).

Pilihan cabang, gender terapis, paket tambahan, dan pengingat WhatsApp.

Data reservasi otomatis masuk ke keranjang.

2. Produk Kecantikan (dari API)

Mengambil data produk dari:

https://makeup-api.herokuapp.com/api/v1/products.json?product_type=lipstick


Ditampilkan dalam bentuk grid, lengkap dengan:

Foto produk

Harga

Brand

Deskripsi

Tombol beli → masuk ke Cart

3. Keranjang (Cart)

Menyimpan item layanan & produk.

Harga otomatis ditotal.

Menampilkan gambar produk sesuai API.

Menghapus item dari cart.

4. Pembayaran

Memilih metode pembayaran:

Transfer bank

E-wallet

Tunai

Simulasi pembayaran → muncul halaman sukses.

5. Profile Page

Tampilan default berupa data dasar.

Bisa beralih ke mode edit untuk mengubah profil.

Data disimpan menggunakan SharedPreferences (data persistence).

6. UI & UX Modern

Tema warna peach/cream.

Halaman smooth dengan scroll.

Animated switcher navigation.

Teknologi yang Digunakan
Teknologi	Fungsi
Flutter	UI & logic aplikasi
Provider	State management keranjang
HTTP	Fetch data dari API
SharedPreferences	Data persistence
Intl	Format tanggal Indonesia
GridView & ListView	Menampilkan data dinamis
Dialogs & Pickers	Input interaktif
📂 Struktur Folder
projectuas/
│── lib/
│   ├── main.dart
│   ├── home_page.dart
│   ├── account_page.dart
│   ├── reservation_page.dart
│   ├── cart_page.dart
│   ├── payment_page.dart
│   ├── beauty_products_page.dart
│   ├── models/
│   │    └── cart_item.dart (opsional)
│   ├── providers/
│   │    └── cart_provider.dart
│   ├── services/
│   │    └── beauty_product_service.dart
│── assets/
│   └── images/ (gambar layanan & profil)
│── pubspec.yaml
│── README.md

📡 API yang Digunakan
Makeup API

Dokumentasi:

https://makeup-api.herokuapp.com/


Contoh endpoint:

https://makeup-api.herokuapp.com/api/v1/products.json?product_type=lipstick

Data Persistence

Menggunakan SharedPreferences untuk menyimpan:

Nama pengguna

Email

Nomor HP

Alamat

Data otomatis muncul kembali ketika aplikasi dibuka ulang.

Screenshot

Tambahkan screenshot aplikasi kamu pada bagian ini:

/screenshots

Cara Menjalankan Project

Clone repository:

git clone https://github.com/Kevinw-05/projectuas


Masuk ke folder project:

cd projectuas


Get dependencies:

flutter pub get


Jalankan aplikasi:

flutter run
