# LAPORAN UJIAN TENGAH PRAKTIKUM (UTP)
## PRAKTIKUM MOBILE PROGRAMMING

---

### 1. Identitas & Info Proyek
- **Nama** : Ervan Arpihsyam
- **NPM** : [Isi NPM Anda]
- **Kelas** : [Isi Kelas Anda, contoh: TI-3A]
- **Judul Aplikasi** : SeduhKopi - Catatan & Panduan Seduh Manual Brew
- **Opsi Data yang Dipilih** : Opsi 1 (Local Storage menggunakan `shared_preferences`)
- **Link Repository GitHub** : [Isi URL Repository GitHub Anda, contoh: https://github.com/username/mopro_utp]

---

### 2. Deskripsi Aplikasi
**SeduhKopi** adalah aplikasi mobile berbasis Flutter yang dibuat untuk memfasilitasi pencatatan, pengelolaan, dan evaluasi hasil seduhan kopi manual (*manual brew*). Aplikasi ini berangkat dari kebutuhan penikmat kopi rumahan yang sering mencoba berbagai kombinasi variabel seduh (seperti gramasi kopi, volume air, suhu air, dan ukuran gilingan) namun kesulitan mengingat racikan terbaik yang pernah dibuat.

**Fitur Utama Aplikasi:**
1. **Pencatatan Riwayat Seduhan (CRUD Lengkap)**:
   - Mahasiswa/pengguna dapat menambahkan resep seduhan baru (*Create*).
   - Menampilkan daftar seluruh seduhan di beranda dengan kartu informatif dan ringkasan (*Read*).
   - Mengubah parameter seduhan atau evaluasi rasa yang sudah tersimpan (*Update*).
   - Menghapus catatan seduhan tertentu yang dilengkapi konfirmasi dialog keamanan (*Delete*).
2. **Kalkulasi Rasio Kopi Otomatis**:
   Aplikasi secara langsung menghitung rasio seduh (misalnya `1 : 15.0`) saat pengguna mengisi takaran kopi dan jumlah air pada form input.
3. **Pencarian dan Filter Kategori**:
   Pengguna dapat memfilter catatan berdasarkan metode seduh (*V60, French Press, Aeropress, Tubruk, Vietnam Drip, Japanese Iced*) serta mencari catatan berdasarkan nama biji kopi, asal daerah (*origin*), atau catatan rasa (*flavor notes*).
4. **Panduan & Kalkulator Takaran Seduh**:
   Menyediakan fitur kalkulator rasio interaktif (menghitung total kebutuhan air dan air *blooming*) serta panduan langkah seduh dasar untuk berbagai metode *manual brew*.

---

### 3. Library & Struktur Data

#### A. Daftar Package (`pubspec.yaml`)
Aplikasi ini memanfaatkan beberapa package pihak ketiga yang tercatat pada `pubspec.yaml`:
1. `shared_preferences: ^2.5.5`
   Digunakan sebagai media penyimpanan lokal (*Local Storage*). Package ini menyimpan data riwayat seduhan dalam bentuk *String* terenkode JSON pada memori persisten perangkat Android/iOS, sehingga data tetap tersimpan saat aplikasi ditutup atau perangkat direstart.
2. `intl: ^0.20.3`
   Digunakan untuk memformat tanggal pencatatan seduhan (contoh: format `dd MMM yyyy` seperti `18 Nov 2026`) secara rapi dan seragam.
3. `cupertino_icons: ^1.0.8`
   Digunakan untuk mendukung kebutuhan aset ikon antarmuka pelengkap pada aplikasi.

#### B. Skema Local Storage & Struktur Data
Penyimpanan lokal diimplementasikan melalui kelas bantuan `StorageHelper` menggunakan *key* utama:
- **Key SharedPreferences**: `'koleksi_seduh_kopi'`
- **Format Penyimpanan**: String JSON berupa *Array of Objects* (`List<Map<String, dynamic>>`).

**Struktur Field Model (`SeduhModel`):**
| Field | Tipe Data | Keterangan |
| :--- | :--- | :--- |
| `id` | `String` | Identifier unik seduhan (menggunakan *timestamp* milidetik saat dibuat) |
| `namaKopi` | `String` | Nama profil/biji kopi (contoh: *Gayo Wine Process*) |
| `origin` | `String` | Asal daerah penghasil kopi (contoh: *Takengon, Aceh*) |
| `metode` | `String` | Metode penyeduhan (*V60, French Press, Aeropress, dll.*) |
| `grindSize` | `String` | Tingkat kehalusan gilingan (*Fine, Medium-Fine, Medium, Coarse*) |
| `beratKopi` | `double` | Berat bubuk kopi dalam satuan gram |
| `jumlahAir` | `double` | Volume air seduh dalam satuan mililiter (ml) |
| `suhuAir` | `int` | Suhu air seduh dalam derajat Celcius (°C) |
| `waktuSeduh` | `String` | Durasi waktu seduh (contoh: *02:45*) |
| `flavorNotes` | `String` | Karakter rasa yang muncul (contoh: *Berry, Caramel, Sweet*) |
| `rating` | `double` | Skor kepuasan hasil seduhan (skala 1.0 sampai 5.0) |
| `catatan` | `String` | Catatan evaluasi teknik *pouring* atau rasa |
| `tanggal` | `String` | Tanggal pembuatan catatan seduh |

---

### 4. Alur Navigasi & Screenshot

#### A. Diagram Alur Navigasi
```
                 ┌────────────────────────────────┐
                 │     Halaman Beranda (Home)     │
                 │   - List riwayat seduh         │
                 │   - Search & Filter Kategori   │
                 │   - Ringkasan Statistik Seduh  │
                 └───────┬──────────────┬─────────┘
                         │              │
        Klik FAB (+) /   │              │  Klik Icon Buku /
        Catat Seduhan    │              │  Menu Panduan
                         ▼              ▼
     ┌───────────────────────┐      ┌─────────────────────────────┐
     │  Halaman Form Seduh   │      │  Halaman Panduan Seduh      │
     │  - Input Data Seduhan │      │  - Kalkulator Rasio Seduh   │
     │  - Validasi Form      │      │  - Step-by-Step Manual Brew │
     │  - Auto-Rasio Preview │      └─────────────────────────────┘
     └───────────┬───────────┘
                 │
           Klik Simpan
                 │
                 ▼ (Kembali & Refresh Data)
     ┌───────────────────────┐
     │     Halaman Beranda   │
     └───────────┬───────────┘
                 │ Klik Salah Satu Card Seduhan
                 ▼
     ┌────────────────────────────────┐
     │     Halaman Detail Seduhan     │
     │  - Rincian Parameter & Rasa    │
     │  - Tips Khusus Metode Seduh    │
     │  - Tombol Edit (buka Form)     │
     │  - Tombol Hapus (Dialog Alert) │
     └────────────────────────────────┘
```

#### B. Penjelasan Antarhalaman & Tangkapan Layar (Screenshot)

1. **Halaman Utama / Beranda (`HomePage`)**
   - **Penjelasan**: Merupakan halaman pertama yang terbuka saat aplikasi dijalankan. Menampilkan ringkasan total seduhan dan rata-rata rating, kolom pencarian, tombol filter metode seduh berbentuk *horizontal choice chips*, serta daftar kartu seduhan yang tersimpan di *Local Storage*. Terdapat Floating Action Button (+) untuk menambah data baru.
   - **Tangkapan Layar**:
     > *(Tempelkan tangkapan layar Halaman Beranda di sini)*
     >
     > `[ Screenshot 1: Halaman Utama SeduhKopi ]`

2. **Halaman Tambah & Edit Seduhan (`FormPage`)**
   - **Penjelasan**: Digunakan untuk menginput catatan baru maupun memperbarui catatan yang sudah ada. Dilengkapi validasi form agar field wajib tidak kosong, kalkulator preview rasio kopi:air yang otomatis terhitung ketika angka diketik, slider rating (1.0 - 5.0), serta pilihan dropdown metode dan ukuran gilingan.
   - **Tangkapan Layar**:
     > *(Tempelkan tangkapan layar Halaman Form Tambah/Edit di sini)*
     >
     > `[ Screenshot 2: Form Input Catatan Seduhan ]`

3. **Halaman Detail Seduhan (`DetailPage`)**
   - **Penjelasan**: Menampilkan informasi lengkap seduhan kopi terpilih, mencakup kartu header profil kopi, grid parameter teknis (rasio, gram kopi, volume air, suhu, waktu seduh, grind size), catatan evaluasi rasa, dan kotak tips rekomendasi otomatis sesuai metode yang digunakan. Pada AppBar terdapat opsi Edit dan tombol Hapus.
   - **Tangkapan Layar**:
     > *(Tempelkan tangkapan layar Halaman Detail di sini)*
     >
     > `[ Screenshot 3: Halaman Detail Seduhan & Dialog Hapus ]`

4. **Halaman Panduan & Kalkulator Rasio (`GuidePage`)**
   - **Penjelasan**: Terdiri dari dua tab navigasi, yaitu Tab Kalkulator Rasio (menghitung total air dan takaran *blooming* secara interaktif berdasarkan gram kopi) serta Tab Metode Seduh (berisi panduan ringkas cara menyeduh kopi dengan V60, French Press, Aeropress, Tubruk, dan Japanese Iced).
   - **Tangkapan Layar**:
     > *(Tempelkan tangkapan layar Halaman Panduan Seduh di sini)*
     >
     > `[ Screenshot 4: Halaman Panduan & Kalkulator Seduh ]`

---

### 5. Penjelasan Kode Utama

#### A. Konversi Model ke JSON Map (`seduh_model.dart`)
Agar objek Dart dapat disimpan ke `SharedPreferences`, data perlu dikonversi menjadi format `Map<String, dynamic>` sebelum di-*encode* menjadi String JSON:
```dart
// Mengubah objek SeduhModel ke format Map (JSON) untuk disimpan ke SharedPreferences
Map<String, dynamic> toMap() {
  return {
    'id': id,
    'namaKopi': namaKopi,
    'origin': origin,
    'metode': metode,
    'grindSize': grindSize,
    'beratKopi': beratKopi,
    'jumlahAir': jumlahAir,
    'suhuAir': suhuAir,
    'waktuSeduh': waktuSeduh,
    'flavorNotes': flavorNotes,
    'rating': rating,
    'catatan': catatan,
    'tanggal': tanggal,
  };
}

// Mengonversi data Map (JSON) dari SharedPreferences kembali menjadi objek SeduhModel
factory SeduhModel.fromMap(Map<String, dynamic> map) {
  return SeduhModel(
    id: map['id'] ?? '',
    namaKopi: map['namaKopi'] ?? '',
    origin: map['origin'] ?? '',
    metode: map['metode'] ?? 'V60',
    grindSize: map['grindSize'] ?? 'Medium',
    beratKopi: (map['beratKopi'] is num) ? (map['beratKopi'] as num).toDouble() : 0.0,
    jumlahAir: (map['jumlahAir'] is num) ? (map['jumlahAir'] as num).toDouble() : 0.0,
    suhuAir: (map['suhuAir'] is num) ? (map['suhuAir'] as num).toInt() : 90,
    waktuSeduh: map['waktuSeduh'] ?? '02:30',
    flavorNotes: map['flavorNotes'] ?? '',
    rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 4.0,
    catatan: map['catatan'] ?? '',
    tanggal: map['tanggal'] ?? '',
  );
}
```
*Penjelasan*: Method `toMap` memetakan properti objek ke dalam bentuk pasangan kunci-nilai (*key-value*). Sedangkan `factory SeduhModel.fromMap` membaca nilai map tersebut dengan penanganan nilai bawaan (*null-safety fallback*) agar tidak menyebabkan *runtime crash* apabila suatu field bernilai null.

#### B. Pengelolaan Local Storage (`storage_helper.dart`)
Proses CRUD memanfaatkan SharedPreferences yang dibungkus dalam fungsi statis asynchronous:
```dart
// 1. Mengambil seluruh data seduhan
static Future<List<SeduhModel>> ambilSemuaSeduh() async {
  final prefs = await SharedPreferences.getInstance();
  final String? jsonString = prefs.getString(_keySeduhList);

  if (jsonString == null || jsonString.isEmpty) {
    final dataAwal = _dapatkanDataSampelAwal();
    await _simpanList(dataAwal);
    return dataAwal;
  }

  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((item) => SeduhModel.fromMap(item)).toList();
}

// 2. Menyimpan data baru (Create)
static Future<bool> tambahSeduh(SeduhModel seduhBaru) async {
  final list = await ambilSemuaSeduh();
  list.insert(0, seduhBaru); // Data terbaru ditaruh paling atas
  return await _simpanList(list);
}

// 3. Menghapus data berdasarkan ID (Delete)
static Future<bool> hapusSeduh(String id) async {
  final list = await ambilSemuaSeduh();
  list.removeWhere((item) => item.id == id);
  return await _simpanList(list);
}

// 4. Helper internal untuk encode list ke String JSON
static Future<bool> _simpanList(List<SeduhModel> list) async {
  final prefs = await SharedPreferences.getInstance();
  final List<Map<String, dynamic>> mapList =
      list.map((item) => item.toMap()).toList();
  final String jsonString = jsonEncode(mapList);
  return await prefs.setString(_keySeduhList, jsonString);
}
```
*Penjelasan*:
- Saat membaca data, fungsi `getString` dipanggil. String JSON kemudian diubah kembali menjadi `List<SeduhModel>` menggunakan `jsonDecode` dan fungsi mapping model.
- Saat menambah data, objek baru disisipkan ke indeks terdepan (`list.insert(0, seduhBaru)`) lalu seluruh list dikonversi menjadi String JSON menggunakan `jsonEncode` dan disimpan ulang dengan `setString`.

#### C. Navigasi & Pembaruan Tampilan Antarmuka (`home_page.dart`)
Agar data di halaman beranda otomatis terbarukan (*refresh*) setelah pengguna selesai menambah, mengedit, atau menghapus catatan:
```dart
// Navigasi ke Form Tambah dengan menunggu hasil pop (await)
final hasil = await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const FormPage(),
  ),
);

// Jika form berhasil menyimpan (return true), panggil fungsi _muatData()
if (hasil == true) {
  _muatData();
}
```
*Penjelasan*: Menggunakan kata kunci `await` pada `Navigator.push` membuat eksekusi kode di halaman beranda menunggu hingga halaman tujuan selesai ditutup (`Navigator.pop(context, true)`). Jika nilai balikan bernilai `true`, halaman beranda akan memicu `_muatData()` yang memanggil `setState()` untuk menampilkan data teranyar.

---

### 6. Kendala & Solusi
Selama pengerjaan aplikasi, beberapa kendala teknis yang dihadapi dan solusinya antara lain:

1. **Kendala Keterbatasan Tipe Data pada SharedPreferences**
   - *Masalah*: `SharedPreferences` pada Flutter secara bawaan hanya mendukung penyimpanan data tipe primitif (`String`, `int`, `double`, `bool`, dan `List<String>`), sehingga tidak dapat langsung menyimpan kumpulan objek `List<SeduhModel>`.
   - *Solusi*: Menggunakan metode serialisasi dan deserialisasi data. Objek `SeduhModel` terlebih dahulu dikonversi menjadi `Map<String, dynamic>` melalui method `toMap()`, kemudian seluruh list diubah menjadi satu string panjang berformat JSON menggunakan fungsi `jsonEncode()`. Saat data dibaca kembali, string tersebut di-*parse* dengan `jsonDecode()` dan dipetakan kembali ke objek model melalui `SeduhModel.fromMap()`.

2. **Kendala Data Tidak Otomatis Ter-update Setelah Navigasi Kembali ke Beranda**
   - *Masalah*: Ketika pengguna selesai menambahkan data baru di `FormPage` atau menghapus data di `DetailPage`, saat menekan tombol kembali ke `HomePage`, data yang tampil di layar masih merupakan data lama sebelum aksi dilakukan.
   - *Solusi*: Mengatur pemanggilan navigasi perpindahan halaman menjadi *asynchronous* (`await Navigator.push(...)`). Pada halaman form atau detail, ketika aksi simpan atau hapus berhasil, kita menyertakan nilai boolean `Navigator.pop(context, true)`. Di halaman beranda, dilakukan pengecekan kondisi: jika hasil balikan adalah `true`, fungsi `_muatData()` langsung dipanggil untuk memperbarui state halaman melalui `setState()`.

3. **Kendala Validasi dan Parsing Input Angka pada Form**
   - *Masalah*: Input untuk berat kopi, volume air, dan suhu berupa teks (`String`). Jika pengguna tidak sengaja memasukkan karakter non-angka atau mengosongkan kolom, aplikasi berisiko mengalami *unhandled exception* (crash) saat melakukan kalkulasi rasio otomatis.
   - *Solusi*: Menggunakan fungsi `double.tryParse()` dan `int.tryParse()` dengan nilai bawaan (*fallback default* atau ternary check). Selain itu, form dibungkus dengan `Form` widget beserta `GlobalKey<FormState>` dan masing-masing `TextFormField` diberikan validator khusus untuk memastikan input berada dalam batas angka yang masuk akal sebelum proses simpan diizinkan.

4. **Kendala Tampilan Menabrak Keyboard (*Bottom Overflowed*)**
   - *Masalah*: Pada perangkat dengan resolusi layar yang lebih kecil, saat pengguna mengetik di form bagian bawah, keyboard virtual muncul dan menutupi layar sehingga muncul peringatan *A RenderFlex overflowed by X pixels*.
   - *Solusi*: Membungkus elemen form di dalam widget `SingleChildScrollView` dan memastikan padding aman sehingga seluruh kolom input dapat digeser (*scroll*) dengan leluasa saat keyboard aktif.
