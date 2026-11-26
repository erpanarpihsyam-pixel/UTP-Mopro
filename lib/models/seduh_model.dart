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
  Map<String, dynamic> toJson() {
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

  // Alias toMap untuk kompatibilitas
  Map<String, dynamic> toMap() => toJson();

  // Mengonversi data Map (JSON) dari SharedPreferences atau file JSON kembali menjadi objek SeduhModel
  factory SeduhModel.fromJson(Map<String, dynamic> json) {
    return SeduhModel(
      id: json['id'] ?? '',
      namaKopi: json['namaKopi'] ?? '',
      origin: json['origin'] ?? '',
      metode: json['metode'] ?? 'V60',
      grindSize: json['grindSize'] ?? 'Medium',
      beratKopi: (json['beratKopi'] is num) ? (json['beratKopi'] as num).toDouble() : 0.0,
      jumlahAir: (json['jumlahAir'] is num) ? (json['jumlahAir'] as num).toDouble() : 0.0,
      suhuAir: (json['suhuAir'] is num) ? (json['suhuAir'] as num).toInt() : 90,
      waktuSeduh: json['waktuSeduh'] ?? '02:30',
      flavorNotes: json['flavorNotes'] ?? '',
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 4.0,
      catatan: json['catatan'] ?? '',
      tanggal: json['tanggal'] ?? '',
    );
  }

  // Alias fromMap untuk kompatibilitas
  factory SeduhModel.fromMap(Map<String, dynamic> map) => SeduhModel.fromJson(map);
}
