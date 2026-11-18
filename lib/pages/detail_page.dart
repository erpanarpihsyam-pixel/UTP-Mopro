import 'package:flutter/material.dart';
import '../models/seduh_model.dart';
import '../helpers/storage_helper.dart';
import 'form_page.dart';

class DetailPage extends StatefulWidget {
  final SeduhModel seduh;

  const DetailPage({super.key, required this.seduh});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late SeduhModel _seduhAktif;

  @override
  void initState() {
    super.initState();
    _seduhAktif = widget.seduh;
  }

  // Dialog konfirmasi hapus data
  void _konfirmasiHapus() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Hapus Catatan?', style: TextStyle(fontSize: 18)),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus catatan seduh "${_seduhAktif.namaKopi}" dari penyimpanan lokal?',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(dialogContext); // Tutup dialog
                final berhasil = await StorageHelper.hapusSeduh(_seduhAktif.id);
                if (mounted) {
                  if (berhasil) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Catatan seduhan berhasil dihapus!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    Navigator.pop(context, true); // Kembali ke Beranda & trigger reload
                  }
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  // Tips rekomendasi berdasarkan metode seduh
  String _dapatkanTipsMetode(String metode) {
    switch (metode) {
      case 'V60':
        return 'Tips V60: Lakukan blooming selama 30-45 detik dengan air 2-3x berat kopi. Tuang air perlahan dengan gerakan spiral dari tengah ke luar untuk ekstraksi yang seimbang.';
      case 'French Press':
        return 'Tips French Press: Gunakan gilingan kasar (coarse). Biarkan kopi terekstraksi (steep) selama 4 menit, kemudian sendok sisa foam di atas sebelum menekan plunger perlahan.';
      case 'Aeropress':
        return 'Tips Aeropress: Coba teknik Inverted untuk kontrol ekstraksi lebih maksimal. Tekan plunger dengan stabil dan berhenti tepat saat terdengar desisan udara (hiss).';
      case 'Tubruk':
        return 'Tips Kopi Tubruk: Gunakan air dengan suhu sekitar 92-95°C. Diamkan 3-4 menit hingga bubuk kopi mengendap sempurna ke dasar cangkir sebelum dinikmati.';
      case 'Vietnam Drip':
        return 'Tips Vietnam Drip: Beri 1-2 sendok makan susu kental manis di dasar gelas. Rapatkan saringan secara proporsional agar tetesan kopi turun perlahan.';
      case 'Japanese Iced':
        return 'Tips Japanese Iced: Ganti 40% jumlah air seduh dengan es batu di dalam server. Seduhan panas langsung mendingin mengunci kesegaran rasa buah (acidity).';
      default:
        return 'Jaga konsistensi pouring dan suhu air untuk mendapatkan rasa kopi terbaik.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Text('Detail Seduhan'),
        actions: [
          IconButton(
            tooltip: 'Edit Catatan',
            icon: const Icon(Icons.edit_rounded),
            onPressed: () async {
              final hasil = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormPage(seduhEdit: _seduhAktif),
                ),
              );
              // Jika selesai diedit, refresh tampilan detail
              if (hasil == true) {
                final listTerbaru = await StorageHelper.ambilSemuaSeduh();
                final updated = listTerbaru.firstWhere(
                  (item) => item.id == _seduhAktif.id,
                  orElse: () => _seduhAktif,
                );
                setState(() {
                  _seduhAktif = updated;
                });
              }
            },
          ),
          IconButton(
            tooltip: 'Hapus Catatan',
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _konfirmasiHapus,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Header Biji Kopi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.brown.shade800, const Color(0xFF4E342E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _seduhAktif.metode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              color: Colors.white70, size: 13),
                          const SizedBox(width: 4),
                          Text(
                            _seduhAktif.tanggal,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _seduhAktif.namaKopi,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        _seduhAktif.origin,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Penilaian Seduhan:',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${_seduhAktif.rating.toStringAsFixed(1)} / 5.0',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Grid Parameter Seduh
            const Text(
              'Parameter Seduhan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildParamTile(
                  icon: Icons.scale_rounded,
                  label: 'Rasio Seduh',
                  value: _seduhAktif.rasio,
                ),
                _buildParamTile(
                  icon: Icons.grain_rounded,
                  label: 'Berat Kopi',
                  value: '${_seduhAktif.beratKopi.toStringAsFixed(0)} gram',
                ),
                _buildParamTile(
                  icon: Icons.water_drop_rounded,
                  label: 'Jumlah Air',
                  value: '${_seduhAktif.jumlahAir.toStringAsFixed(0)} ml',
                ),
                _buildParamTile(
                  icon: Icons.thermostat_rounded,
                  label: 'Suhu Air',
                  value: '${_seduhAktif.suhuAir} °C',
                ),
                _buildParamTile(
                  icon: Icons.timer_outlined,
                  label: 'Waktu Seduh',
                  value: _seduhAktif.waktuSeduh.isNotEmpty
                      ? _seduhAktif.waktuSeduh
                      : '-',
                ),
                _buildParamTile(
                  icon: Icons.tune_rounded,
                  label: 'Gilingan (Grind)',
                  value: _seduhAktif.grindSize,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Catatan Rasa (Flavor Notes)
            if (_seduhAktif.flavorNotes.isNotEmpty) ...[
              const Text(
                'Karakter Rasa (Flavor Notes)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E2723),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.brown.shade100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_florist_rounded,
                        color: Colors.brown.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _seduhAktif.flavorNotes,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4E342E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Catatan Tambahan
            const Text(
              'Catatan & Evaluasi Rasa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown.shade100),
              ),
              child: Text(
                _seduhAktif.catatan.isNotEmpty
                    ? _seduhAktif.catatan
                    : 'Tidak ada catatan tambahan untuk seduhan ini.',
                style: TextStyle(
                  fontSize: 13,
                  color: _seduhAktif.catatan.isNotEmpty
                      ? Colors.black87
                      : Colors.grey,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tips & Rekomendasi Khusus Metode
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb_outline_rounded,
                      color: Colors.amber.shade900),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _dapatkanTipsMetode(_seduhAktif.metode),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.brown.shade900,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildParamTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.brown.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.brown.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.brown.shade700),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C1810),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
