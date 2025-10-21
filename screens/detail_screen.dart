import 'package:flutter/material.dart';
import '../models/kendaraan.dart';
import '../models/mobil.dart';
import '../models/motor.dart';
import '../main.dart'; 

class DetailScreen extends StatelessWidget {
  final Kendaraan kendaraan;
  const DetailScreen({super.key, required this.kendaraan});

  @override
  Widget build(BuildContext context) {
    
    final ThemeData theme = Theme.of(context);
    final bool isLightMode = theme.brightness == Brightness.light;
    final Color primaryTextColor = isLightMode ? Colors.black87 : Colors.white;
    final Color secondaryTextColor = isLightMode ? Colors.grey.shade700 : Colors.white70;
    final Color boxColor = isLightMode ? Colors.white : Colors.white.withOpacity(0.05);
    final Color boxBorderColor = isLightMode ? Colors.grey.shade300 : Colors.white24;

    return Container(
      decoration: isLightMode
          ? BoxDecoration(color: theme.scaffoldBackgroundColor) 
          : kAppBackgroundGradient(), 
      child: Scaffold(
        backgroundColor: Colors.transparent, 
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: Colors.transparent, 
              foregroundColor: isLightMode ? Colors.black87 : Colors.white, 
              elevation: 0, 
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  "${kendaraan.merk} ${kendaraan.model}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
                          
                          color: isLightMode ? Colors.grey.shade200 : Colors.grey[800],
                          child: Center(
                            child: Icon(
                              Icons.no_photography,
                              size: 100,
                              
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

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "DESKRIPSI",
                      style: TextStyle( 
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
                      style: TextStyle( 
                        fontSize: 16,
                        color: primaryTextColor,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "SPESIFIKASI",
                      style: TextStyle( 
                        color: secondaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    Center(
                      child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 500, 
                        ),
                        decoration: BoxDecoration(
                          
                          border: Border.all(color: boxBorderColor, width: 1),
                          borderRadius: BorderRadius.circular(16),
                          color: boxColor,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        child: Column(
                          children: [
                            
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
              style: TextStyle( 
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
              style: TextStyle( 
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