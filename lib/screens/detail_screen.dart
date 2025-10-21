import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Tidak perlu jika harga dihapus
import '../models/kendaraan.dart';
import '../models/mobil.dart';
import '../models/motor.dart';
import '../main.dart'; // Import kPrimaryColor dan kAppBackgroundGradient

class DetailScreen extends StatelessWidget {
  final Kendaraan kendaraan;

  const DetailScreen({super.key, required this.kendaraan});

  @override
  Widget build(BuildContext context) {
    // 1. Dapatkan informasi tema
    final ThemeData theme = Theme.of(context);
    final bool isLightMode = theme.brightness == Brightness.light;

    // 2. Tentukan warna teks primer dan sekunder berdasarkan tema
    final Color primaryTextColor = isLightMode ? Colors.black87 : Colors.white;
    final Color secondaryTextColor = isLightMode ? Colors.grey.shade700 : Colors.white70;
    // Warna untuk box spesifikasi
    final Color boxColor = isLightMode ? Colors.white : Colors.white.withOpacity(0.05);
    final Color boxBorderColor = isLightMode ? Colors.grey.shade300 : Colors.white24;


    // Harga tidak ditampilkan
    // final priceFormat =
    //     NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    // 3. Terapkan background kondisional pada Container terluar
    return Container(
      decoration: isLightMode
          ? BoxDecoration(color: theme.scaffoldBackgroundColor) // Warna solid saat terang
          : kAppBackgroundGradient(), // Gradient saat gelap
      child: Scaffold(
        backgroundColor: Colors.transparent, // Scaffold tetap transparan
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: Colors.transparent, // AppBar selalu transparan
              foregroundColor: isLightMode ? Colors.black87 : Colors.white, // Warna ikon & teks AppBar
              elevation: 0, // Hapus shadow di mode terang
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  "${kendaraan.merk} ${kendaraan.model}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    // Warna title AppBar mengikuti foregroundColor di atas
                  ),
                ),
                background: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 250,
                    child: Image.asset(
                      kendaraan.urlGambar,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          // Warna background error disesuaikan
                          color: isLightMode ? Colors.grey.shade200 : Colors.grey[800],
                          child: Center(
                            child: Icon(
                              Icons.no_photography,
                              size: 100,
                              // Warna ikon error disesuaikan
                              color: isLightMode ? Colors.grey.shade400 : Colors.white54,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // === BODY ===
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Harga Dihapus

                    // === DESKRIPSI ===
                    Text(
                      "DESKRIPSI",
                      style: TextStyle( // Gunakan warna sekunder
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      kendaraan.deskripsi,
                      style: TextStyle( // Gunakan warna primer
                        fontSize: 16,
                        color: primaryTextColor,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // === SPESIFIKASI ===
                    Text(
                      "SPESIFIKASI",
                      style: TextStyle( // Gunakan warna sekunder
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // === BOX TABEL (TENGAH & TIDAK PANJANG) ===
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 500, // batasi lebar tabel
                        ),
                        decoration: BoxDecoration(
                          // Gunakan warna border & box kondisional
                          border: Border.all(color: boxBorderColor, width: 1),
                          borderRadius: BorderRadius.circular(16),
                          color: boxColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        child: Column(
                          children: [
                            // Teruskan warna ke _specRow
                            _specRow("Kategori", kendaraan.fullCategory, primaryTextColor, secondaryTextColor),
                            _specRow("Tipe", kendaraan.vehicleType, primaryTextColor, secondaryTextColor),
                            _specRow("Tahun Rilis", kendaraan.tahunRilis.toString(), primaryTextColor, secondaryTextColor),
                            _specRow("Jumlah Kursi", "${kendaraan.seat} Seater", primaryTextColor, secondaryTextColor),
                            _specRow("Status Stok", kendaraan.stockStatus, primaryTextColor, secondaryTextColor),
                            _specRow("Tipe Penggerak", kendaraan.driveType, primaryTextColor, secondaryTextColor),

                            if (kendaraan is Mobil)
                              _specRow("Bahan Bakar", (kendaraan as Mobil).jenisBahanBakar, primaryTextColor, secondaryTextColor),
                            if (kendaraan is Motor)
                              _specRow("Kapasitas Mesin", "${(kendaraan as Motor).kapasitasMesinCC} CC", primaryTextColor, secondaryTextColor),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Modifikasi _specRow untuk menerima warna
  Widget _specRow(String title, String value, Color valueColor, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: TextStyle( // Gunakan labelColor
                fontSize: 15,
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle( // Gunakan valueColor
                fontSize: 15,
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}