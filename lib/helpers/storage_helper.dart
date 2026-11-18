import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/seduh_model.dart';

class StorageHelper {
  // Key penyimpanan di SharedPreferences
  static const String _keySeduhList = 'koleksi_seduh_kopi';

  // Mengambil seluruh riwayat seduhan kopi dari SharedPreferences
  static Future<List<SeduhModel>> ambilSemuaSeduh() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_keySeduhList);

    // Jika data masih kosong (pertama kali install), buat data sampel awal
    if (jsonString == null || jsonString.isEmpty) {
      final dataAwal = _dapatkanDataSampelAwal();
      await _simpanList(dataAwal);
      return dataAwal;
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => SeduhModel.fromMap(item)).toList();
    } catch (e) {
      // Jika terjadi kesalahan decoding, kembalikan data awal
      return [];
    }
  }

  // Menyimpan data seduhan baru ke SharedPreferences
  static Future<bool> tambahSeduh(SeduhModel seduhBaru) async {
    final list = await ambilSemuaSeduh();
    // Tambahkan data baru di awal daftar (urutan terbaru di atas)
    list.insert(0, seduhBaru);
    return await _simpanList(list);
  }

  // Memperbarui data seduhan yang sudah ada
  static Future<bool> updateSeduh(SeduhModel seduhUpdate) async {
    final list = await ambilSemuaSeduh();
    final index = list.indexWhere((item) => item.id == seduhUpdate.id);
    if (index != -1) {
      list[index] = seduhUpdate;
      return await _simpanList(list);
    }
    return false;
  }

  // Menghapus data seduhan berdasarkan ID
  static Future<bool> hapusSeduh(String id) async {
    final list = await ambilSemuaSeduh();
    list.removeWhere((item) => item.id == id);
    return await _simpanList(list);
  }

  // Helper internal untuk mengonversi List<SeduhModel> ke String JSON dan menyimpannya
  static Future<bool> _simpanList(List<SeduhModel> list) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> mapList =
        list.map((item) => item.toMap()).toList();
    final String jsonString = jsonEncode(mapList);
    return await prefs.setString(_keySeduhList, jsonString);
  }

  // Data sampel awal agar aplikasi langsung terlihat rapi saat dibuka pertama kali
  static List<SeduhModel> _dapatkanDataSampelAwal() {
    return [
      SeduhModel(
        id: '1',
        namaKopi: 'Gayo Wine Process',
        origin: 'Takengon, Aceh',
        metode: 'V60',
        grindSize: 'Medium-Fine',
        beratKopi: 15.0,
        jumlahAir: 225.0,
        suhuAir: 92,
        waktuSeduh: '02:45',
        flavorNotes: 'Anggur Merah, Nanas, Manis Karamel',
        rating: 4.8,
        catatan:
            'Gunakan rasio 1:15 dengan 3x pouring. Bloom 45ml selama 40 detik, lalu tuang melingkar stabil. Keasaman winey sangat terasa dan clean.',
        tanggal: '16 Nov 2026',
      ),
      SeduhModel(
        id: '2',
        namaKopi: 'Toraja Sapan Washed',
        origin: 'Tana Toraja, Sulawesi',
        metode: 'French Press',
        grindSize: 'Coarse',
        beratKopi: 18.0,
        jumlahAir: 270.0,
        suhuAir: 94,
        waktuSeduh: '04:00',
        flavorNotes: 'Dark Chocolate, Rempah, Earthy',
        rating: 4.5,
        catatan:
            'Seduh selama 4 menit, aduk perlahan di menit ke-1, lalu plunge perlahan. Karakter body tebal dan aftertaste rempah hangat yang tahan lama.',
        tanggal: '17 Nov 2026',
      ),
    ];
  }
}
