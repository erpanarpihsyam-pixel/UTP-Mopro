import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/seduh_model.dart';
import '../helpers/storage_helper.dart';

class FormPage extends StatefulWidget {
  final SeduhModel? seduhEdit;

  const FormPage({super.key, this.seduhEdit});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaKopiController;
  late TextEditingController _originController;
  late TextEditingController _beratKopiController;
  late TextEditingController _jumlahAirController;
  late TextEditingController _suhuAirController;
  late TextEditingController _waktuSeduhController;
  late TextEditingController _flavorNotesController;
  late TextEditingController _catatanController;

  String _metodeTerpilih = 'V60';
  String _grindSizeTerpilih = 'Medium-Fine';
  double _rating = 4.5;
  bool _isSaving = false;

  final List<String> _daftarMetode = [
    'V60',
    'French Press',
    'Aeropress',
    'Tubruk',
    'Vietnam Drip',
    'Japanese Iced',
    'Kalita Wave',
  ];

  final List<String> _daftarGrindSize = [
    'Fine',
    'Medium-Fine',
    'Medium',
    'Medium-Coarse',
    'Coarse',
  ];

  bool get _isEditMode => widget.seduhEdit != null;

  @override
  void initState() {
    super.initState();
    final edit = widget.seduhEdit;

    _namaKopiController = TextEditingController(text: edit?.namaKopi ?? '');
    _originController = TextEditingController(text: edit?.origin ?? '');
    _beratKopiController =
        TextEditingController(text: edit != null ? edit.beratKopi.toStringAsFixed(0) : '15');
    _jumlahAirController =
        TextEditingController(text: edit != null ? edit.jumlahAir.toStringAsFixed(0) : '225');
    _suhuAirController =
        TextEditingController(text: edit != null ? edit.suhuAir.toString() : '92');
    _waktuSeduhController =
        TextEditingController(text: edit?.waktuSeduh ?? '02:30');
    _flavorNotesController =
        TextEditingController(text: edit?.flavorNotes ?? '');
    _catatanController = TextEditingController(text: edit?.catatan ?? '');

    if (edit != null) {
      if (_daftarMetode.contains(edit.metode)) {
        _metodeTerpilih = edit.metode;
      }
      if (_daftarGrindSize.contains(edit.grindSize)) {
        _grindSizeTerpilih = edit.grindSize;
      }
      _rating = edit.rating;
    }
  }

  @override
  void dispose() {
    _namaKopiController.dispose();
    _originController.dispose();
    _beratKopiController.dispose();
    _jumlahAirController.dispose();
    _suhuAirController.dispose();
    _waktuSeduhController.dispose();
    _flavorNotesController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  // Kalkulasi rasio secara langsung untuk preview di form
  String _hitungPreviewRasio() {
    final berat = double.tryParse(_beratKopiController.text) ?? 0.0;
    final air = double.tryParse(_jumlahAirController.text) ?? 0.0;
    if (berat <= 0 || air <= 0) return '1 : -';
    return '1 : ${(air / berat).toStringAsFixed(1)}';
  }

  // Simpan data seduhan
  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final berat = double.tryParse(_beratKopiController.text) ?? 15.0;
    final air = double.tryParse(_jumlahAirController.text) ?? 225.0;
    final suhu = int.tryParse(_suhuAirController.text) ?? 92;

    // Format tanggal
    final String tanggalFormatted = _isEditMode
        ? widget.seduhEdit!.tanggal
        : DateFormat('dd MMM yyyy').format(DateTime.now());

    final seduhData = SeduhModel(
      id: _isEditMode
          ? widget.seduhEdit!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      namaKopi: _namaKopiController.text.trim(),
      origin: _originController.text.trim(),
      metode: _metodeTerpilih,
      grindSize: _grindSizeTerpilih,
      beratKopi: berat,
      jumlahAir: air,
      suhuAir: suhu,
      waktuSeduh: _waktuSeduhController.text.trim(),
      flavorNotes: _flavorNotesController.text.trim(),
      rating: _rating,
      catatan: _catatanController.text.trim(),
      tanggal: tanggalFormatted,
    );

    bool berhasil = false;
    if (_isEditMode) {
      berhasil = await StorageHelper.updateSeduh(seduhData);
    } else {
      berhasil = await StorageHelper.tambahSeduh(seduhData);
    }

    setState(() => _isSaving = false);

    if (mounted) {
      if (berhasil) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditMode
                ? 'Catatan seduhan berhasil diperbarui!'
                : 'Catatan seduhan berhasil disimpan ke Local Storage!'),
            backgroundColor: Colors.green.shade700,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat menyimpan data.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Catatan Seduh' : 'Catat Seduhan Baru'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Preview Rasio Otomatis
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.brown.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calculate_rounded, color: Colors.brown.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estimasi Rasio Seduh',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.brown,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _hitungPreviewRasio(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Otomatis terhitung',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Bagian 1: Profil Biji Kopi
              _buildSectionTitle('1. Profil Biji Kopi'),
              const SizedBox(height: 10),

              // Nama Biji Kopi
              TextFormField(
                controller: _namaKopiController,
                decoration: InputDecoration(
                  labelText: 'Nama Biji Kopi / Profil Roasting *',
                  hintText: 'Contoh: Gayo Natural Anaerob',
                  prefixIcon: const Icon(Icons.coffee, color: Colors.brown),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Nama biji kopi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Asal Daerah / Origin
              TextFormField(
                controller: _originController,
                decoration: InputDecoration(
                  labelText: 'Asal Daerah / Origin *',
                  hintText: 'Contoh: Aceh Gayo / Toraja',
                  prefixIcon: const Icon(Icons.location_on, color: Colors.brown),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Asal daerah tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Bagian 2: Parameter Seduh
              _buildSectionTitle('2. Parameter & Metode Seduh'),
              const SizedBox(height: 10),

              // Dropdown Metode Seduh & Grind Size
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _metodeTerpilih,
                      decoration: InputDecoration(
                        labelText: 'Metode Seduh',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _daftarMetode.map((metode) {
                        return DropdownMenuItem(
                          value: metode,
                          child: Text(metode, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _metodeTerpilih = val);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _grindSizeTerpilih,
                      decoration: InputDecoration(
                        labelText: 'Ukuran Gilingan',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: _daftarGrindSize.map((grind) {
                        return DropdownMenuItem(
                          value: grind,
                          child: Text(grind, style: const TextStyle(fontSize: 14)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _grindSizeTerpilih = val);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Berat Kopi, Jumlah Air & Suhu Air
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _beratKopiController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Kopi (gram)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Wajib diisi';
                        final num = double.tryParse(val);
                        if (num == null || num <= 0) return 'Tidak valid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _jumlahAirController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Air (ml)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Wajib diisi';
                        final num = double.tryParse(val);
                        if (num == null || num <= 0) return 'Tidak valid';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _suhuAirController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Suhu (°C)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Wajib diisi';
                        final num = int.tryParse(val);
                        if (num == null || num < 50 || num > 100) return '50-100';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Waktu Seduh
              TextFormField(
                controller: _waktuSeduhController,
                decoration: InputDecoration(
                  labelText: 'Total Waktu Seduh (menit:detik)',
                  hintText: 'Contoh: 02:45',
                  prefixIcon: const Icon(Icons.timer_outlined, color: Colors.brown),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bagian 3: Review & Catatan Rasa
              _buildSectionTitle('3. Karakter Rasa & Kesan Seduh'),
              const SizedBox(height: 10),

              // Flavor Notes
              TextFormField(
                controller: _flavorNotesController,
                decoration: InputDecoration(
                  labelText: 'Flavor Notes / Karakter Rasa',
                  hintText: 'Contoh: Berry, Chocolate, Sweet Caramel',
                  prefixIcon: const Icon(Icons.local_florist_outlined, color: Colors.brown),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Rating Slider
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Rating Hasil Seduhan:',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              _rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Slider(
                      value: _rating,
                      min: 1.0,
                      max: 5.0,
                      divisions: 8,
                      activeColor: Colors.brown.shade700,
                      inactiveColor: Colors.brown.shade100,
                      label: _rating.toStringAsFixed(1),
                      onChanged: (val) {
                        setState(() => _rating = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Catatan Tambahan
              TextFormField(
                controller: _catatanController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Catatan Tambahan / Teknik Pouring',
                  hintText: 'Tuliskan pouring flow, sensasi aftertaste, atau saran perbaikan...',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade800,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    _isSaving
                        ? 'Menyimpan...'
                        : (_isEditMode ? 'Perbarui Catatan' : 'Simpan ke Penyimpanan Lokal'),
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  onPressed: _isSaving ? null : _simpanData,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  ),
);
}

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF3E2723),
      ),
    );
  }
}
