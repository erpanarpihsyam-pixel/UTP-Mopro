class SeduhModel {
  final String id;
  final String namaKopi;
  final String origin;
  final String metode;
  final String grindSize;
  final double beratKopi;
  final double jumlahAir;
  final int suhuAir;
  final String waktuSeduh;
  final String flavorNotes;
  final double rating;
  final String catatan;
  final String tanggal;

  SeduhModel({
    required this.id,
    required this.namaKopi,
    required this.origin,
    required this.metode,
    required this.grindSize,
    required this.beratKopi,
    required this.jumlahAir,
    required this.suhuAir,
    required this.waktuSeduh,
    required this.flavorNotes,
    required this.rating,
    required this.catatan,
    required this.tanggal,
  });

  // Menghitung rasio seduh otomatis (misal 1 : 15.0)
  String get rasio {
    if (beratKopi <= 0) return '1 : -';
    double rasioValue = jumlahAir / beratKopi;
    return '1 : ${rasioValue.toStringAsFixed(1)}';
  }

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
}
