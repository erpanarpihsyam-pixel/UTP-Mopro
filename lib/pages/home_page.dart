import 'package:flutter/material.dart';
import '../models/seduh_model.dart';
import '../helpers/storage_helper.dart';
import 'form_page.dart';
import 'detail_page.dart';
import 'guide_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SeduhModel> _semuaList = [];
  List<SeduhModel> _tampilList = [];
  bool _isLoading = true;
  String _metodeFilter = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _daftarKategori = [
    'Semua',
    'V60',
    'French Press',
    'Aeropress',
    'Tubruk',
    'Vietnam Drip',
    'Japanese Iced',
  ];

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil data seduhan dari Local Storage
  Future<void> _muatData() async {
    setState(() => _isLoading = true);
    final data = await StorageHelper.ambilSemuaSeduh();
    setState(() {
      _semuaList = data;
      _terapkanFilter();
      _isLoading = false;
    });
  }

  // Memfilter data berdasarkan kategori metode dan input pencarian
  void _terapkanFilter() {
    List<SeduhModel> hasil = List.from(_semuaList);

    // Filter berdasarkan metode seduh
    if (_metodeFilter != 'Semua') {
      hasil = hasil.where((item) => item.metode == _metodeFilter).toList();
    }

    // Filter berdasarkan teks pencarian (nama kopi atau origin)
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      hasil = hasil.where((item) {
        return item.namaKopi.toLowerCase().contains(query) ||
            item.origin.toLowerCase().contains(query) ||
            item.flavorNotes.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _tampilList = hasil;
    });
  }

  // Menghitung rata-rata rating
  double _hitungRataRating() {
    if (_semuaList.isEmpty) return 0.0;
    double total = _semuaList.fold(0.0, (sum, item) => sum + item.rating);
    return total / _semuaList.length;
  }

  // Warna aksen badge metode seduh
  Color _warnaMetode(String metode) {
    switch (metode) {
      case 'V60':
        return Colors.brown.shade700;
      case 'French Press':
        return Colors.deepOrange.shade700;
      case 'Aeropress':
        return Colors.teal.shade700;
      case 'Tubruk':
        return Colors.blueGrey.shade700;
      case 'Vietnam Drip':
        return Colors.amber.shade900;
      case 'Japanese Iced':
        return Colors.indigo.shade600;
      default:
        return Colors.brown.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SeduhKopi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Jurnal & Resep Kopi Manual Brew',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Panduan & Kalkulator Rasio',
            icon: const Icon(Icons.menu_book_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GuidePage()),
              );
            },
          ),
          IconButton(
            tooltip: 'Segarkan Data',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _muatData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _muatData,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // Kartu Statistik / Ringkasan Jurnal
                    _buildStatistikCard(),
                    const SizedBox(height: 16),

                    // Kotak Pencarian
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => _terapkanFilter(),
                      decoration: InputDecoration(
                        hintText: 'Cari nama biji, origin, atau notes...',
                        prefixIcon: const Icon(Icons.search, color: Colors.brown),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  _terapkanFilter();
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.brown.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.brown.shade100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filter Chip Kategori Metode Seduh
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _daftarKategori.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final item = _daftarKategori[index];
                          final isSelected = _metodeFilter == item;
                          return ChoiceChip(
                            label: Text(item),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _metodeFilter = item;
                                  _terapkanFilter();
                                });
                              }
                            },
                            selectedColor: Colors.brown.shade700,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                            backgroundColor: Colors.white,
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.brown.shade700
                                  : Colors.brown.shade200,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Header List
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Riwayat Seduhan (${_tampilList.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        if (_metodeFilter != 'Semua')
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _metodeFilter = 'Semua';
                                _terapkanFilter();
                              });
                            },
                            child: const Text(
                              'Reset Filter',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.brown,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Daftar Item Seduhan
                    if (_tampilList.isEmpty)
                      _buildEmptyState()
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _tampilList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final seduh = _tampilList[index];
                          return _buildSeduhCard(seduh);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown.shade800,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Catat Seduhan'),
        onPressed: () async {
          // Navigasi ke halaman form tambah data
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormPage(),
            ),
          );
          // Jika berhasil menyimpan, muat ulang data di halaman utama
          if (hasil == true) {
            _muatData();
          }
        },
      ),
    );
  }

  // Widget Kartu Statistik / Ringkasan
  Widget _buildStatistikCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.brown.shade800, Colors.brown.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.coffee_rounded,
            label: 'Total Catatan',
            value: '${_semuaList.length}',
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.white24,
          ),
          _buildStatItem(
            icon: Icons.star_rounded,
            label: 'Rata-rata Rating',
            value: _hitungRataRating().toStringAsFixed(1),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.white24,
          ),
          _buildStatItem(
            icon: Icons.auto_graph_rounded,
            label: 'Penyimpanan',
            value: 'Lokal (SP)',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber.shade200, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // Widget Tampilan Item Catatan Seduhan
  Widget _buildSeduhCard(SeduhModel seduh) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.brown.shade100, width: 0.8),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          // Buka halaman detail
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(seduh: seduh),
            ),
          );
          if (hasil == true) {
            _muatData();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Baris Judul & Badge Metode
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seduh.namaKopi,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C1810),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 13, color: Colors.brown),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                seduh.origin,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _warnaMetode(seduh.metode),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      seduh.metode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 18, thickness: 0.7),

              // Baris Info Teknis Seduhan (Rasio, Kopi, Air, Suhu)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMiniInfo(
                    label: 'Rasio',
                    value: seduh.rasio,
                    icon: Icons.scale_rounded,
                  ),
                  _buildMiniInfo(
                    label: 'Kopi',
                    value: '${seduh.beratKopi.toStringAsFixed(0)}g',
                    icon: Icons.grain_rounded,
                  ),
                  _buildMiniInfo(
                    label: 'Air',
                    value: '${seduh.jumlahAir.toStringAsFixed(0)}ml',
                    icon: Icons.water_drop_rounded,
                  ),
                  _buildMiniInfo(
                    label: 'Suhu',
                    value: '${seduh.suhuAir}°C',
                    icon: Icons.thermostat_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Flavor Notes & Footer
              if (seduh.flavorNotes.isNotEmpty) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.brown.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_florist_rounded,
                          size: 13, color: Colors.brown),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          seduh.flavorNotes,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.brown.shade900,
                            fontStyle: FontStyle.italic,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Rating dan Tanggal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        seduh.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    seduh.tanggal,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniInfo({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.brown.shade400),
        const SizedBox(width: 3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget Tampilan Kosong (Empty State)
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          Icon(Icons.coffee_maker_outlined,
              size: 64, color: Colors.brown.shade300),
          const SizedBox(height: 12),
          Text(
            _searchController.text.isNotEmpty
                ? 'Tidak ada seduhan yang cocok dengan pencarian'
                : 'Belum ada catatan seduhan untuk kategori ini',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Klik tombol "Catat Seduhan" untuk menambahkan catatan baru.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
