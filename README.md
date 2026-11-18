# SeduhKopi - Jurnal & Panduan Seduh Manual Brew
> Proyek Ujian Tengah Praktikum (UTP) - Praktikum Mobile Programming

Aplikasi mobile berbasis Flutter yang dirancang untuk membantu para penikmat kopi rumahan mencatat, menyimpan, dan mengevaluasi setiap hasil seduhan kopi manual (*manual brew*). Aplikasi ini mengimplementasikan **Opsi 1: Local Storage** menggunakan library `shared_preferences` untuk menyimpan seluruh data riwayat seduhan secara lokal pada perangkat pengguna.

---

## 📌 Identitas Mahasiswa
- **Nama** : Ervan Arpihsyam
- **NPM** : [Isi NPM Anda]
- **Kelas** : [Isi Kelas Anda]
- **Mata Kuliah** : Praktikum Mobile Programming
- **Opsi yang Dipilih** : Opsi 1 (Local Storage - SharedPreferences)

---

## ✨ Fitur Utama Aplikasi
1. **Pencatatan Resep Seduhan (CRUD Lengkap)**
   - **Create**: Menambahkan catatan seduh baru (profil biji, asal daerah, metode seduh, ukuran gilingan, takaran kopi, volume air, suhu, waktu seduh, flavor notes, rating, dan catatan).
   - **Read**: Menampilkan seluruh riwayat seduhan di halaman utama dalam bentuk card informatif beserta ringkasan statistik (total seduhan & rata-rata rating).
   - **Update**: Memperbarui parameter seduh atau catatan rasa pada seduhan yang telah disimpan.
   - **Delete**: Menghapus catatan seduh tertentu dengan dialog konfirmasi keamanan.
2. **Kalkulasi Rasio Otomatis**
   - Menghitung rasio seduh (misal `1 : 15.0`) secara *real-time* saat menginputkan gram kopi dan volume air.
3. **Pencarian & Filter Cepat**
   - Filter seduhan berdasarkan metode (*V60, French Press, Aeropress, Tubruk, Vietnam Drip, Japanese Iced*).
   - Pencarian instan berdasarkan nama biji kopi, asal daerah (*origin*), atau karakter rasa.
4. **Halaman Panduan & Kalkulator Rasio**
   - Kalkulator takaran air dan porsi *blooming* (3x berat kopi).
   - Panduan langkah-langkah penyeduhan untuk berbagai metode *manual brew*.

---

## 📱 Alur Halaman (Minimal 3 Halaman)
Aplikasi ini memiliki 4 halaman yang saling terhubung:
1. **Halaman Utama (`HomePage`)**: Dashboard riwayat seduhan, pencarian, filter, dan ringkasan statistik.
2. **Halaman Detail (`DetailPage`)**: Rincian parameter seduhan, evaluasi rasa, tips metode, tombol edit, dan tombol hapus.
3. **Halaman Form (`FormPage`)**: Form input dan validasi untuk menambah catatan baru maupun mengedit catatan lama.
4. **Halaman Panduan (`GuidePage`)**: Kalkulator takaran air seduh dan panduan langkah metode manual brew.

---

## 🛠️ Library yang Digunakan
- `flutter`: SDK bawaan.
- `shared_preferences: ^2.5.5`: Penyimpanan lokal (*Local Storage*) untuk menyimpan serialisasi JSON data catatan seduhan.
- `intl: ^0.20.3`: Pemformatan tanggal catatan seduhan.
- `cupertino_icons: ^1.0.8`: Ikon pelengkap antarmuka.

---

## 🚀 Cara Menjalankan Aplikasi

1. **Clone repository ini:**
   ```bash
   git clone <URL_REPOSITORY_ANDA>
   cd mopro_UTP
   ```

2. **Unduh dependencies:**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```
   *(Pilih perangkat Android Emulator, Google Chrome, atau Physical Device Anda)*.
