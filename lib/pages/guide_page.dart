import 'package:flutter/material.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // State untuk Kalkulator Rasio Seduh
  final TextEditingController _kopiCalcController =
      TextEditingController(text: '15');
  double _rasioPilihan = 15.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _kopiCalcController.dispose();
    super.dispose();
  }

  // Menghitung kebutuhan air berdasarkan gram kopi dan rasio
  double _hitungKebutuhanAir() {
    final gram = double.tryParse(_kopiCalcController.text) ?? 0.0;
    return gram * _rasioPilihan;
  }

  // Menghitung blooming (umumnya 2-3x berat kopi)
  double _hitungBlooming() {
    final gram = double.tryParse(_kopiCalcController.text) ?? 0.0;
    return gram * 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Text('Panduan & Kalkulator Seduh'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.calculate_rounded),
              text: 'Kalkulator Rasio',
            ),
            Tab(
              icon: Icon(Icons.menu_book_rounded),
              text: 'Metode Seduh',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildKalkulatorTab(),
          _buildPanduanMetodeTab(),
        ],
      ),
    );
  }

  // TAB 1: KALKULATOR RASIO SEDUH INTERAKTIF
  Widget _buildKalkulatorTab() {
    final kebutuhanAir = _hitungKebutuhanAir();
    final blooming = _hitungBlooming();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Pengantar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown.shade800,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.coffee_maker_rounded, color: Colors.amber, size: 36),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kalkulator Seduh Manual',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Hitung takaran air dan blooming ideal untuk mendapatkan seduhan yang seimbang.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Input Gramasi Kopi
          const Text(
            '1. Masukkan Berat Bubuk Kopi (gram):',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _kopiCalcController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              suffixText: 'Gram',
              prefixIcon: const Icon(Icons.scale_rounded, color: Colors.brown),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Pilihan Rasio Seduh
          const Text(
            '2. Pilih Rasio Kopi : Air yang Diinginkan:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildRasioChoice(13.0, '1 : 13 (Pekat / Kuat)'),
              _buildRasioChoice(15.0, '1 : 15 (Standar Emas)'),
              _buildRasioChoice(16.0, '1 : 16 (Light / Lembut)'),
              _buildRasioChoice(18.0, '1 : 18 (Sangat Ringan)'),
            ],
          ),
          const SizedBox(height: 24),

          // Hasil Kalkulasi
          const Text(
            'Hasil Perhitungan Takaran:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3E2723),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.brown.shade200),
            ),
            child: Column(
              children: [
                _buildHasilRow(
                  label: 'Kebutuhan Total Air Seduh',
                  value: '${kebutuhanAir.toStringAsFixed(0)} ml',
                  icon: Icons.water_drop_rounded,
                  color: Colors.blue.shade700,
                ),
                const Divider(height: 20),
                _buildHasilRow(
                  label: 'Takaran Air Blooming (Tahap 1)',
                  value: '${blooming.toStringAsFixed(0)} ml (~30-45 dtk)',
                  icon: Icons.hourglass_top_rounded,
                  color: Colors.orange.shade800,
                ),
                const Divider(height: 20),
                _buildHasilRow(
                  label: 'Sisa Air untuk Pouring Berikutnya',
                  value:
                      '${(kebutuhanAir - blooming).clamp(0, double.infinity).toStringAsFixed(0)} ml',
                  icon: Icons.waves_rounded,
                  color: Colors.teal.shade700,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Info Proyek Mahasiswa di Bawah
          _buildInfoMahasiswa(),
        ],
      ),
    );
  }

  Widget _buildRasioChoice(double rasio, String label) {
    final isSelected = _rasioPilihan == rasio;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _rasioPilihan = rasio);
        }
      },
      selectedColor: Colors.brown.shade700,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildHasilRow({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C1810))),
            ],
          ),
        ),
      ],
    );
  }

  // TAB 2: PANDUAN LENGKAP METODE SEDUH
  Widget _buildPanduanMetodeTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildGuideCard(
          metode: 'V60 (Pour Over)',
          icon: Icons.coffee_rounded,
          rasio: '1 : 15 s/d 1 : 16',
          gilingan: 'Medium-Fine (mirip garam laut halus)',
          suhu: '90 - 93 °C',
          langkah:
              '1. Bilas kertas filter dengan air panas untuk menghilangkan aroma kertas.\n'
              '2. Masukkan kopi, ratakan permukaannya.\n'
              '3. Tuang air blooming 3x berat kopi (~45ml), tunggu 45 detik.\n'
              '4. Lakukan pouring kedua secara memutar pelan hingga ~150ml.\n'
              '5. Tuang sisa air hingga target rasio tercapai. Total waktu 02:30 - 03:00 menit.',
        ),
        const SizedBox(height: 14),
        _buildGuideCard(
          metode: 'French Press',
          icon: Icons.coffee_maker_rounded,
          rasio: '1 : 14 s/d 1 : 15',
          gilingan: 'Coarse (kasar)',
          suhu: '93 - 96 °C',
          langkah:
              '1. Masukkan bubuk kopi kasar ke dalam beaker French Press.\n'
              '2. Tuangkan seluruh air panas perlahan.\n'
              '3. Diamkan selama 4 menit (ekstraksi immersi).\n'
              '4. Sendok sisa busa (crust) yang mengapung di permukaan.\n'
              '5. Pasang penutup dan tekan plunger perlahan ke bawah. Segera sajikan.',
        ),
        const SizedBox(height: 14),
        _buildGuideCard(
          metode: 'Aeropress',
          icon: Icons.air_rounded,
          rasio: '1 : 12 (Konsentrat) s/d 1 : 14',
          gilingan: 'Fine hingga Medium-Fine',
          suhu: '85 - 90 °C',
          langkah:
              '1. Gunakan metode Inverted (tabung terbalik) untuk kontrol ekstraksi.\n'
              '2. Masukkan kopi dan tuang air panas, aduk perlahan 10-15 detik.\n'
              '3. Pasang cap dengan filter yang sudah dibilas.\n'
              '4. Balikkan tabung ke atas cangkir, tekan plunger perlahan selama 30 detik.',
        ),
        const SizedBox(height: 14),
        _buildGuideCard(
          metode: 'Kopi Tubruk Tradisional',
          icon: Icons.local_cafe_rounded,
          rasio: '1 : 12 s/d 1 : 14',
          gilingan: 'Fine / Halus',
          suhu: '92 - 95 °C',
          langkah:
              '1. Masukkan bubuk kopi halus ke dalam cangkir.\n'
              '2. Tuang air panas mendidih secara langsung.\n'
              '3. Aduk 3-4 putaran agar bubuk terbasahi merata.\n'
              '4. Diamkan selama 3 hingga 5 menit hingga ampas kopi mengendap di dasar cangkir.',
        ),
        const SizedBox(height: 14),
        _buildGuideCard(
          metode: 'Japanese Iced Coffee',
          icon: Icons.ac_unit_rounded,
          rasio: '1 : 15 (60% Air Panas + 40% Es Batu)',
          gilingan: 'Medium-Fine',
          suhu: '92 - 94 °C',
          langkah:
              '1. Tempatkan es batu di dalam server/teko kaca (~100g es untuk 250ml total).\n'
              '2. Pasang dripper V60 di atas server.\n'
              '3. Seduh kopi menggunakan sisa air panas (~150ml).\n'
              '4. Kopi yang menetes panas akan langsung didinginkan es, mengunci aroma cerah & rasa manis buah.',
        ),
        const SizedBox(height: 20),
        _buildInfoMahasiswa(),
      ],
    );
  }

  Widget _buildGuideCard({
    required String metode,
    required IconData icon,
    required String rasio,
    required String gilingan,
    required String suhu,
    required String langkah,
  }) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.brown.shade100),
      ),
      color: Colors.white,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.brown.shade50,
          child: Icon(icon, color: Colors.brown.shade700),
        ),
        title: Text(
          metode,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF2C1810),
          ),
        ),
        subtitle: Text(
          'Rasio: $rasio | Suhu: $suhu',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.brown.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildGuideSpecRow('Ukuran Gilingan', gilingan),
                const SizedBox(height: 4),
                _buildGuideSpecRow('Rasio Ideal', rasio),
                const SizedBox(height: 4),
                _buildGuideSpecRow('Suhu Air', suhu),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Langkah Penyeduhan:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF3E2723),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            langkah,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideSpecRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.brown.shade800,
            ),
          ),
        ),
        const Text(': ', style: TextStyle(fontSize: 11)),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // Info Mahasiswa Praktikum
  Widget _buildInfoMahasiswa() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.brown, size: 18),
              SizedBox(width: 8),
              Text(
                'Informasi Proyek UTP',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C1810),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Mata Kuliah: Praktikum Mobile Programming\n'
            'Nama: Ervan Arpihsyam\n'
            'Opsi: Opsi 1 (Local Storage - SharedPreferences)\n'
            'Aplikasi: SeduhKopi (Manual Brew Coffee Journal)',
            style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }
}
