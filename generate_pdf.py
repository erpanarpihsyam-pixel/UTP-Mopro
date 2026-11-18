import os
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether
)
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_number(num_pages)
            canvas.Canvas.showPage(self)
        canvas.Canvas.save(self)

    def draw_page_number(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 9)
        self.setFillColor(colors.HexColor("#757575"))
        
        # Header (pages > 1)
        if self._pageNumber > 1:
            self.drawString(54, A4[1] - 36, "Laporan UTP Praktikum Mobile Programming — SeduhKopi")
            self.setStrokeColor(colors.HexColor("#E0E0E0"))
            self.setLineWidth(0.5)
            self.line(54, A4[1] - 42, A4[0] - 54, A4[1] - 42)
        
        # Footer
        footer_text = f"Halaman {self._pageNumber} dari {page_count}"
        self.drawRightString(A4[0] - 54, 36, footer_text)
        self.drawString(54, 36, "Ervan Arpihsyam — Opsi 1 (Local Storage)")
        self.setStrokeColor(colors.HexColor("#E0E0E0"))
        self.setLineWidth(0.5)
        self.line(54, 48, A4[0] - 54, 48)
        
        self.restoreState()

def create_pdf(filename="Laporan_UTP_Mobile_Programming.pdf"):
    doc = SimpleDocTemplate(
        filename,
        pagesize=A4,
        leftMargin=54,
        rightMargin=54,
        topMargin=54,
        bottomMargin=54
    )

    styles = getSampleStyleSheet()

    # Custom styles
    primary_color = colors.HexColor("#3E2723")
    secondary_color = colors.HexColor("#4E342E")
    body_color = colors.HexColor("#212121")

    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=18,
        leading=22,
        textColor=primary_color,
        alignment=1, # Center
        spaceAfter=4
    )

    subtitle_style = ParagraphStyle(
        'DocSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=13,
        leading=16,
        textColor=secondary_color,
        alignment=1,
        spaceAfter=15
    )

    h1_style = ParagraphStyle(
        'Heading1Custom',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=12,
        leading=16,
        textColor=primary_color,
        spaceBefore=12,
        spaceAfter=6,
        keepWithNext=True
    )

    h2_style = ParagraphStyle(
        'Heading2Custom',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=10.5,
        leading=14,
        textColor=secondary_color,
        spaceBefore=8,
        spaceAfter=4,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        'BodyCustom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=13.5,
        textColor=body_color,
        spaceAfter=6
    )

    bullet_style = ParagraphStyle(
        'BulletCustom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=13.5,
        textColor=body_color,
        leftIndent=14,
        spaceAfter=4
    )

    code_style = ParagraphStyle(
        'CodeSnippet',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=8,
        leading=11,
        textColor=colors.HexColor("#263238")
    )

    story = []

    # Title & Header
    story.append(Paragraph("LAPORAN UJIAN TENGAH PRAKTIKUM (UTP)", title_style))
    story.append(Paragraph("PRAKTIKUM MOBILE PROGRAMMING", subtitle_style))
    story.append(Spacer(1, 8))

    # 1. Identitas & Info Proyek
    story.append(Paragraph("1. Identitas & Info Proyek", h1_style))
    
    info_data = [
        [Paragraph("<b>Nama Lengkap</b>", body_style), Paragraph(": Ervan Arpihsyam", body_style)],
        [Paragraph("<b>NPM</b>", body_style), Paragraph(": [Isi NPM Anda]", body_style)],
        [Paragraph("<b>Kelas</b>", body_style), Paragraph(": [Isi Kelas Anda, contoh: TI-3A]", body_style)],
        [Paragraph("<b>Judul Aplikasi</b>", body_style), Paragraph(": <b>SeduhKopi</b> - Catatan & Panduan Seduh Manual Brew", body_style)],
        [Paragraph("<b>Opsi Data yang Dipilih</b>", body_style), Paragraph(": <b>Opsi 1 (Local Storage - SharedPreferences)</b>", body_style)],
        [Paragraph("<b>Link Repository GitHub</b>", body_style), Paragraph(": [Isi URL Repository GitHub Anda]", body_style)],
    ]
    info_table = Table(info_data, colWidths=[150, 337])
    info_table.setStyle(TableStyle([
        ('VALIGN', (0,0), (-1,-1), 'TOP'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 3),
        ('TOPPADDING', (0,0), (-1,-1), 3),
        ('LEFTPADDING', (0,0), (-1,-1), 6),
        ('RIGHTPADDING', (0,0), (-1,-1), 6),
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F9F7F4")),
        ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#D7CCC8")),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor("#EFEBE9")),
    ]))
    story.append(info_table)
    story.append(Spacer(1, 10))

    # 2. Deskripsi Aplikasi
    story.append(Paragraph("2. Deskripsi Aplikasi", h1_style))
    story.append(Paragraph(
        "<b>SeduhKopi</b> adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu para penikmat "
        "dan praktisi kopi rumahan dalam mencatat, mengelola, serta mengevaluasi setiap hasil seduhan kopi manual (*manual brew*). "
        "Aplikasi ini menyelesaikan masalah lupa takaran atau rasio seduhan terbaik yang pernah diracik dengan menyediakan sistem pencatatan parameter seduh yang presisi dan tersimpan permanen di perangkat pengguna.",
        body_style
    ))
    story.append(Paragraph("<b>Fitur Utama Aplikasi:</b>", body_style))
    story.append(Paragraph("• <b>Manajemen Resep Seduh (CRUD Lengkap):</b> Menambah (*Create*), menampilkan riwayat (*Read*), mengedit parameter (*Update*), dan menghapus data seduhan (*Delete*) dengan dialog konfirmasi.", bullet_style))
    story.append(Paragraph("• <b>Kalkulasi Rasio Otomatis:</b> Menghitung rasio air:kopi secara dinamis saat pengguna memasukkan berat bubuk kopi (gram) dan volume air (ml).", bullet_style))
    story.append(Paragraph("• <b>Pencarian & Filter Kategori:</b> Memudahkan pencarian catatan berdasarkan nama biji kopi, asal daerah (*origin*), serta filter instan berdasarkan metode seduh (*V60, French Press, Aeropress, Tubruk, Vietnam Drip, Japanese Iced*).", bullet_style))
    story.append(Paragraph("• <b>Kalkulator Seduh & Panduan Metode:</b> Halaman interaktif untuk menghitung air seduh dan takaran *blooming*, dilengkapi langkah seduh standar untuk berbagai metode manual brew.", bullet_style))
    story.append(Spacer(1, 10))

    # 3. Library & Struktur Data
    story.append(Paragraph("3. Library & Struktur Data", h1_style))
    story.append(Paragraph("<b>A. Daftar Package pada pubspec.yaml:</b>", h2_style))
    story.append(Paragraph("1. <code>shared_preferences: ^2.5.5</code> — Digunakan untuk implementasi Local Storage dalam menyimpan list data seduhan dalam format serialisasi JSON string.", bullet_style))
    story.append(Paragraph("2. <code>intl: ^0.20.3</code> — Digunakan untuk memformat tanggal pencatatan seduhan (format <code>dd MMM yyyy</code>) secara seragam dan rapi.", bullet_style))
    story.append(Paragraph("3. <code>cupertino_icons: ^1.0.8</code> — Digunakan untuk melengkapi aset visual ikonik pada antarmuka aplikasi.", bullet_style))

    story.append(Paragraph("<b>B. Skema Local Storage:</b>", h2_style))
    story.append(Paragraph("Data disimpan menggunakan key <code>'koleksi_seduh_kopi'</code> dalam bentuk serialisasi Array of JSON Objects. Setiap data catatan memiliki struktur model <code>SeduhModel</code> sebagai berikut:", body_style))

    schema_data = [
        [Paragraph("<b>Nama Field</b>", body_style), Paragraph("<b>Tipe Data</b>", body_style), Paragraph("<b>Keterangan</b>", body_style)],
        [Paragraph("<code>id</code>", body_style), Paragraph("String", body_style), Paragraph("Unique ID (timestamp milidetik saat dibuat)", body_style)],
        [Paragraph("<code>namaKopi</code>", body_style), Paragraph("String", body_style), Paragraph("Nama profil biji kopi (misal: Gayo Wine)", body_style)],
        [Paragraph("<code>origin</code>", body_style), Paragraph("String", body_style), Paragraph("Asal daerah kopi (misal: Aceh Gayo)", body_style)],
        [Paragraph("<code>metode</code>", body_style), Paragraph("String", body_style), Paragraph("Metode seduh (V60, French Press, Aeropress, dll.)", body_style)],
        [Paragraph("<code>grindSize</code>", body_style), Paragraph("String", body_style), Paragraph("Ukuran gilingan (Fine, Medium-Fine, Medium, Coarse)", body_style)],
        [Paragraph("<code>beratKopi</code>", body_style), Paragraph("double", body_style), Paragraph("Takaran bubuk kopi dalam satuan gram", body_style)],
        [Paragraph("<code>jumlahAir</code>", body_style), Paragraph("double", body_style), Paragraph("Volume total air seduh dalam satuan ml", body_style)],
        [Paragraph("<code>suhuAir</code>", body_style), Paragraph("int", body_style), Paragraph("Suhu air seduh (°C)", body_style)],
        [Paragraph("<code>waktuSeduh</code>", body_style), Paragraph("String", body_style), Paragraph("Total durasi penyeduhan (contoh: 02:45)", body_style)],
        [Paragraph("<code>flavorNotes</code>", body_style), Paragraph("String", body_style), Paragraph("Karakter rasa dominan (misal: Berry, Caramel)", body_style)],
        [Paragraph("<code>rating</code>", body_style), Paragraph("double", body_style), Paragraph("Skor penilaian seduhan (skala 1.0 - 5.0)", body_style)],
        [Paragraph("<code>catatan</code>", body_style), Paragraph("String", body_style), Paragraph("Catatan teknik pouring atau evaluasi rasa", body_style)],
        [Paragraph("<code>tanggal</code>", body_style), Paragraph("String", body_style), Paragraph("Tanggal pencatatan seduhan", body_style)],
    ]
    schema_table = Table(schema_data, colWidths=[90, 75, 322])
    schema_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#EFEBE9")),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 2),
        ('TOPPADDING', (0,0), (-1,-1), 2),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#D7CCC8")),
    ]))
    story.append(schema_table)
    story.append(Spacer(1, 14))

    # Page Break for clean sectioning
    story.append(PageBreak())

    # 4. Alur Navigasi & Screenshot
    story.append(Paragraph("4. Alur Navigasi & Screenshot", h1_style))
    story.append(Paragraph(
        "Aplikasi SeduhKopi terdiri dari 4 halaman utama yang saling terhubung dengan alur navigasi yang jelas:",
        body_style
    ))
    story.append(Paragraph("1. <b>Halaman Utama (HomePage):</b> Menampilkan ringkasan statistik (total seduh & rata-rata rating), pencarian, filter kategori metode, dan daftar seluruh seduhan. Terdapat tombol FAB (+) untuk ke Form Tambah, tombol buku untuk ke Panduan, dan tap card untuk ke Detail.", bullet_style))
    story.append(Paragraph("2. <b>Halaman Form Tambah/Edit (FormPage):</b> Menangani input data seduh dengan validasi, live preview perhitungan rasio, slider rating, dan dropdown metode. Hasil simpan langsung dialirkan kembali ke Beranda.", bullet_style))
    story.append(Paragraph("3. <b>Halaman Detail (DetailPage):</b> Menampilkan spesifikasi parameter lengkap, catatan rasa, tips otomatis metode, tombol edit, dan dialog konfirmasi hapus data.", bullet_style))
    story.append(Paragraph("4. <b>Halaman Panduan (GuidePage):</b> Memuat kalkulator takaran seduh & blooming interaktif serta panduan langkah seduh berbagai metode.", bullet_style))
    story.append(Spacer(1, 8))

    # Screenshot Placeholders table
    story.append(Paragraph("<b>Tangkapan Layar (Screenshot) Antarmuka Aplikasi:</b>", h2_style))
    
    def make_ss_box(title, desc):
        content = [
            Paragraph(f"<b>{title}</b>", ParagraphStyle('T', parent=styles['Normal'], fontSize=9, fontName='Helvetica-Bold', alignment=1)),
            Spacer(1, 6),
            Paragraph(desc, ParagraphStyle('D', parent=styles['Normal'], fontSize=7.5, textColor=colors.HexColor("#616161"), alignment=1)),
            Spacer(1, 45),
            Paragraph("[ Tempat Menempelkan Tangkapan Layar ]", ParagraphStyle('P', parent=styles['Normal'], fontSize=7.5, textColor=colors.HexColor("#9E9E9E"), alignment=1))
        ]
        return content

    ss_table_data = [
        [make_ss_box("1. Halaman Beranda (Home)", "Tampilan riwayat kartu seduh, filter, dan ringkasan"),
         make_ss_box("2. Halaman Form Input", "Form tambah/edit, validasi, dan preview rasio otomatis")],
        [make_ss_box("3. Halaman Detail Seduhan", "Rincian spesifikasi, tips metode, dan tombol aksi"),
         make_ss_box("4. Halaman Panduan & Kalkulator", "Kalkulator rasio interaktif dan panduan manual brew")]
    ]
    ss_table = Table(ss_table_data, colWidths=[240, 240])
    ss_table.setStyle(TableStyle([
        ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#BCAAA4")),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor("#D7CCC8")),
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#FAFAFA")),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('TOPPADDING', (0,0), (-1,-1), 8),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
        ('LEFTPADDING', (0,0), (-1,-1), 8),
        ('RIGHTPADDING', (0,0), (-1,-1), 8),
    ]))
    story.append(ss_table)
    story.append(Spacer(1, 14))

    # 5. Penjelasan Kode Utama
    story.append(Paragraph("5. Penjelasan Kode Utama", h1_style))
    story.append(Paragraph("<b>A. Konversi Model ke JSON Map (lib/models/seduh_model.dart):</b>", h2_style))
    
    code_model = (
        "// Mengubah objek ke format Map untuk SharedPreferences\n"
        "Map<String, dynamic> toMap() {\n"
        "  return {\n"
        "    'id': id, 'namaKopi': namaKopi, 'origin': origin,\n"
        "    'metode': metode, 'grindSize': grindSize, 'beratKopi': beratKopi,\n"
        "    'jumlahAir': jumlahAir, 'suhuAir': suhuAir, 'waktuSeduh': waktuSeduh,\n"
        "    'flavorNotes': flavorNotes, 'rating': rating,\n"
        "    'catatan': catatan, 'tanggal': tanggal,\n"
        "  };\n"
        "}\n\n"
        "// Membaca kembali dari Map hasil jsonDecode\n"
        "factory SeduhModel.fromMap(Map<String, dynamic> map) {\n"
        "  return SeduhModel(\n"
        "    id: map['id'] ?? '',\n"
        "    namaKopi: map['namaKopi'] ?? '',\n"
        "    origin: map['origin'] ?? '',\n"
        "    metode: map['metode'] ?? 'V60',\n"
        "    grindSize: map['grindSize'] ?? 'Medium',\n"
        "    beratKopi: (map['beratKopi'] is num) ? (map['beratKopi'] as num).toDouble() : 0.0,\n"
        "    jumlahAir: (map['jumlahAir'] is num) ? (map['jumlahAir'] as num).toDouble() : 0.0,\n"
        "    suhuAir: (map['suhuAir'] is num) ? (map['suhuAir'] as num).toInt() : 90,\n"
        "    waktuSeduh: map['waktuSeduh'] ?? '02:30',\n"
        "    flavorNotes: map['flavorNotes'] ?? '',\n"
        "    rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 4.0,\n"
        "    catatan: map['catatan'] ?? '',\n"
        "    tanggal: map['tanggal'] ?? '',\n"
        "  );\n"
        "}"
    )
    story.append(Table([[Paragraph(code_model.replace("\n", "<br/>").replace(" ", "&nbsp;"), code_style)]],
                       colWidths=[487],
                       style=[('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F5F5F5")),
                              ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#E0E0E0")),
                              ('PADDING', (0,0), (-1,-1), 6)]))
    story.append(Spacer(1, 4))
    story.append(Paragraph("<i>Penjelasan:</i> Method <code>toMap</code> mengubah data model menjadi Map agar dapat diserialisasi oleh <code>jsonEncode</code>, sedangkan factory <code>fromMap</code> memetakan kembali nilai Map menjadi objek Dart lengkap dengan fallback nilai default agar aman terhadap null.", body_style))
    story.append(Spacer(1, 6))

    # Page Break for code helper and kendala
    story.append(PageBreak())

    story.append(Paragraph("<b>B. Fungsi CRUD pada SharedPreferences (lib/helpers/storage_helper.dart):</b>", h2_style))
    code_storage = (
        "// 1. Mengambil data dari SharedPreferences\n"
        "static Future<List<SeduhModel>> ambilSemuaSeduh() async {\n"
        "  final prefs = await SharedPreferences.getInstance();\n"
        "  final String? jsonString = prefs.getString(_keySeduhList);\n"
        "  if (jsonString == null || jsonString.isEmpty) {\n"
        "    final dataAwal = _dapatkanDataSampelAwal();\n"
        "    await _simpanList(dataAwal);\n"
        "    return dataAwal;\n"
        "  }\n"
        "  final List<dynamic> jsonList = jsonDecode(jsonString);\n"
        "  return jsonList.map((item) => SeduhModel.fromMap(item)).toList();\n"
        "}\n\n"
        "// 2. Menambah data seduhan baru\n"
        "static Future<bool> tambahSeduh(SeduhModel seduhBaru) async {\n"
        "  final list = await ambilSemuaSeduh();\n"
        "  list.insert(0, seduhBaru); // Sisipkan di posisi teratas\n"
        "  return await _simpanList(list);\n"
        "}\n\n"
        "// 3. Menghapus data berdasarkan ID\n"
        "static Future<bool> hapusSeduh(String id) async {\n"
        "  final list = await ambilSemuaSeduh();\n"
        "  list.removeWhere((item) => item.id == id);\n"
        "  return await _simpanList(list);\n"
        "}\n\n"
        "// 4. Helper internal serialisasi JSON dan set string ke prefs\n"
        "static Future<bool> _simpanList(List<SeduhModel> list) async {\n"
        "  final prefs = await SharedPreferences.getInstance();\n"
        "  final List<Map<String, dynamic>> mapList = list.map((item) => item.toMap()).toList();\n"
        "  final String jsonString = jsonEncode(mapList);\n"
        "  return await prefs.setString(_keySeduhList, jsonString);\n"
        "}"
    )
    story.append(Table([[Paragraph(code_storage.replace("\n", "<br/>").replace(" ", "&nbsp;"), code_style)]],
                       colWidths=[487],
                       style=[('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F5F5F5")),
                              ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#E0E0E0")),
                              ('PADDING', (0,0), (-1,-1), 6)]))
    story.append(Spacer(1, 4))
    story.append(Paragraph("<i>Penjelasan:</i> Fungsi <code>ambilSemuaSeduh</code> membaca string JSON dari penyimpanan lokal. Jika baru pertama kali diakses, dibuatkan data sampel bawaan. Fungsi <code>tambahSeduh</code> dan <code>hapusSeduh</code> memodifikasi list objek lalu menyimpannya kembali melalui fungsi <code>_simpanList</code>.", body_style))
    story.append(Spacer(1, 10))

    # 6. Kendala & Solusi
    story.append(Paragraph("6. Kendala & Solusi", h1_style))
    
    kendala_items = [
        ("Keterbatasan Tipe Data SharedPreferences",
         "SharedPreferences hanya menerima tipe data primitif seperti String dan int, bukan objek kompleks List<SeduhModel>.",
         "Mengimplementasikan serialisasi JSON. Objek dikonversi ke Map lewat toMap(), lalu diubah menjadi format JSON String menggunakan jsonEncode(). Saat dibaca, string di-decode dengan jsonDecode() lalu dipetakan kembali ke model."),
        
        ("Data Tampilan Tidak Otomatis Ter-update",
         "Setelah menambah data baru di FormPage atau menghapus data di DetailPage, halaman utama masih menampilkan data lama saat tombol kembali ditekan.",
         "Menjalankan navigasi secara asynchronous dengan await Navigator.push(...). Pada FormPage/DetailPage dikembalikan nilai boolean (true) saat operasi sukses, lalu halaman beranda langsung memicu _muatData() untuk me-refresh state UI."),
        
        ("Validasi dan Parsing Input Angka",
         "Input berat kopi dan air bertipe teks sehingga berisiko terjadi format exception (aplikasi crash) apabila pengguna memasukkan input kosong atau non-numerik saat kalkulasi rasio.",
         "Menerapkan double.tryParse() dan int.tryParse() dengan nilai fallback, serta membungkus form dalam Form widget dengan validator ketat sebelum proses simpan diizinkan."),
        
        ("Keyboard Menutupi Input (RenderFlex Overflow)",
         "Pada layar ponsel dengan resolusi kecil, kemunculan keyboard virtual saat mengetik form bawah mengakibatkan tampilan overflow.",
         "Membungkus keseluruhan tata letak form dengan SingleChildScrollView dan memberikan padding yang cukup agar form dapat digulir secara fleksibel.")
    ]

    for i, (judul, masalah, solusi) in enumerate(kendala_items, 1):
        story.append(Paragraph(f"<b>{i}. {judul}</b>", h2_style))
        story.append(Paragraph(f"• <b>Masalah:</b> {masalah}", bullet_style))
        story.append(Paragraph(f"• <b>Solusi:</b> {solusi}", bullet_style))
        story.append(Spacer(1, 2))

    doc.build(story, canvasmaker=NumberedCanvas)
    print("PDF generated successfully:", filename)

if __name__ == "__main__":
    create_pdf()
