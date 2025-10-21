import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:shimmer/shimmer.dart';
import '../models/mobil.dart';
import '../models/motor.dart';
import '../models/kendaraan.dart';
import 'detail_screen.dart';
import '../main.dart';
import 'theme_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

// --- DATA KENDARAAN (DITAMBAH MAZDA) ---
final List<Kendaraan> daftarKendaraan = [
  // MOBIL
  Mobil(
      "Honda", "Civic Type R", 2023, "assets/images/mobil_civic.png",
      "Hot hatchback legendaris yang menawarkan performa balap untuk penggunaan harian.",
      /*price*/ 1180000, /*seat*/ 4, /*class*/ "S", /*type*/ "Hot Hatch", /*stock*/ "Available", /*drive*/ "Front Wheel Drive",
      /*pintu*/ 4, /*bakar*/ "Bensin", /*tenaga*/ "315 HP", /*transmisi*/ "Manual"),
  Mobil(
      "Toyota", "Supra GR", 2022, "assets/images/mobil_supra.png",
      "Mobil sport ikonik yang terlahir kembali dengan performa tinggi dan desain aerodinamis.",
      /*price*/ 2100000, /*seat*/ 2, /*class*/ "S", /*type*/ "Sports Car", /*stock*/ "Available", /*drive*/ "Rear Wheel Drive",
      /*pintu*/ 2, /*bakar*/ "Bensin", /*tenaga*/ "382 HP", /*transmisi*/ "Otomatis"),
  Mobil(
      "Tesla", "Model S", 2024, "assets/images/mobil_tesla.png",
      "Sedan listrik mewah yang mendefinisikan ulang akselerasi dan teknologi otomotif.",
      /*price*/ 1500000, /*seat*/ 5, /*class*/ "S", /*type*/ "Electric Sedan", /*stock*/ "Available", /*drive*/ "All Wheel Drive",
      /*pintu*/ 4, /*bakar*/ "Listrik", /*tenaga*/ "670 HP", /*transmisi*/ "Single-Speed"),
  Mobil(
      "Mitsubishi", "Pajero Sport", 2023, "assets/images/mobil_pajero.png",
      "SUV tangguh yang siap melibas segala medan dengan kenyamanan premium.",
      /*price*/ 600000, /*seat*/ 7, /*class*/ "A", /*type*/ "SUV", /*stock*/ "Available", /*drive*/ "4 Wheel Drive",
      /*pintu*/ 4, /*bakar*/ "Diesel", /*tenaga*/ "178 HP", /*transmisi*/ "Otomatis"),
  Mobil(
      "Hyundai", "Ioniq 5", 2023, "assets/images/mobil_ioniq5.png",
      "Crossover listrik dengan desain retro-futuristik, interior lapang, dan teknologi canggih.",
      /*price*/ 700000, /*seat*/ 5, /*class*/ "A", /*type*/ "Electric Crossover", /*stock*/ "Available", /*drive*/ "Rear Wheel Drive",
      /*pintu*/ 4, /*bakar*/ "Listrik", /*tenaga*/ "225 HP", /*transmisi*/ "Single-Speed"),
  // --- MOBIL BARU DITAMBAHKAN DI SINI ---
  Mobil(
      "Mazda", "MX-5 Miata", 2024, "assets/images/mobil_miata.png", // Ganti path gambar jika perlu
      "Roadster ikonik yang ringan, lincah, dan menyenangkan untuk dikendarai.",
      /*price*/ 850000, /*seat*/ 2, /*class*/ "B", /*type*/ "Roadster", /*stock*/ "Available", /*drive*/ "Rear Wheel Drive",
      /*pintu*/ 2, /*bakar*/ "Bensin", /*tenaga*/ "181 HP", /*transmisi*/ "Manual"),
  // ------------------------------------
  
  // MOTOR
  Motor(
      "Yamaha", "NMAX", 2024, "assets/images/motor_nmax.png",
      "Skutik premium populer dengan kenyamanan, bagasi luas, dan fitur konektivitas modern.",
      /*price*/ 35000, /*seat*/ 2, /*class*/ "M", /*type*/ "Skutik", /*stock*/ "Available", /*drive*/ "CVT (Belt)",
      /*transmisi*/ "Otomatis", /*cc*/ 155, /*tenaga*/ "15.1 HP", /*mesin*/ "1-Silinder SOHC"),
  Motor(
      "Kawasaki", "Ninja ZX-25R", 2023, "assets/images/motor_ninja.png",
      "Satu-satunya motor sport 250cc dengan mesin 4-silinder, menghasilkan suara melengking khas moge.",
      /*price*/ 105000, /*seat*/ 2, /*class*/ "M", /*type*/ "Sportbike", /*stock*/ "Available", /*drive*/ "Chain Drive",
      /*transmisi*/ "Manual", /*cc*/ 250, /*tenaga*/ "50.3 HP", /*mesin*/ "4-Silinder Segaris"),
  Motor(
      "Vespa", "Sprint 150", 2024, "assets/images/motor_vespa.png",
      "Skuter ikonik dengan gaya Italia klasik dan performa lincah untuk mobilitas perkotaan.",
      /*price*/ 54000, /*seat*/ 2, /*class*/ "M", /*type*/ "Skutik", /*stock*/ "Available", /*drive*/ "CVT",
      /*transmisi*/ "Otomatis", /*cc*/ 150, /*tenaga*/ "11.6 HP", /*mesin*/ "1-Silinder i-get"),
  Motor(
      "Honda", "CB150X", 2023, "assets/images/motor_cb150x.png",
      "Motor adventure touring yang tangguh dan nyaman untuk perjalanan jarak jauh maupun harian.",
      /*price*/ 34000, /*seat*/ 2, /*class*/ "M", /*type*/ "Adventure", /*stock*/ "Available", /*drive*/ "Chain Drive",
      /*transmisi*/ "Manual", /*cc*/ 150, /*tenaga*/ "15.4 HP", /*mesin*/ "1-Silinder DOHC"),
  Motor(
      "Harley-Davidson", "Sportster S", 2022, "assets/images/motor_harley.png",
      "Cruiser modern berperforma buas dari mesin Revolution Max 1250T yang legendaris.",
      /*price*/ 600000, /*seat*/ 1, /*class*/ "L", /*type*/ "Cruiser", /*stock*/ "Available", /*drive*/ "Belt Drive",
      /*transmisi*/ "Manual", /*cc*/ 1250, /*tenaga*/ "121 HP", /*mesin*/ "V-Twin"),
];
class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = "Mobil";
  // 1. Tambahkan Controller dan Query untuk Search
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // 2. Listener untuk update query
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); // 3. Dispose controller
    super.dispose();
  }

  Map<String, List<Kendaraan>> _groupKendaraan(List<Kendaraan> kendaraanList) {
    final Map<String, List<Kendaraan>> grouped = {};
    for (var k in kendaraanList) {
      String category = k.fullCategory;
      if (grouped[category] == null) {
        grouped[category] = [];
      }
      grouped[category]!.add(k);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // --- LOGIKA FILTERING BARU DENGAN SEARCH ---
    List<Kendaraan> filteredList;
    if (_selectedFilter == "Mobil") {
      filteredList = daftarKendaraan.whereType<Mobil>().toList();
    } else {
      filteredList = daftarKendaraan.whereType<Motor>().toList();
    }

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((kendaraan) {
        final merkLower = kendaraan.merk.toLowerCase();
        final modelLower = kendaraan.model.toLowerCase();
        final queryLower = _searchQuery.toLowerCase();
        return merkLower.contains(queryLower) || modelLower.contains(queryLower);
      }).toList();
    }
    // --- AKHIR LOGIKA FILTERING ---

    final groupedData = _groupKendaraan(filteredList);
    final categories = groupedData.keys.toList();

    return Container(
      decoration: themeProvider.isDarkMode ? kAppBackgroundGradient() : BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset('assets/images/logo.png', height: 35),
              const SizedBox(width: 10),
              const Text("Katalog Kendaraan"),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: AnimatedToggleSwitch<bool>.dual(
                current: themeProvider.isDarkMode, // Status saat ini (true=dark, false=light)
                first: false, // Nilai untuk mode terang
                second: true, // Nilai untuk mode gelap
                spacing: 25.0, // Jarak antar ikon
                style: ToggleStyle( // Warna background switch
                  borderColor: Colors.transparent,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? kSurfaceColor.withOpacity(0.8)
                      : Colors.grey.shade200,
                  indicatorColor: Theme.of(context).scaffoldBackgroundColor, // Warna indikator/bulatan
                ),
                borderWidth: 2.0,
                height: 35,
                indicatorSize: const Size(30, 30),
                onChanged: (b) => themeProvider.toggleTheme(b), // Panggil fungsi toggle
                iconBuilder: (value) => value
                    ? Icon(Icons.dark_mode_rounded, color: kPrimaryColor, size: 18) // Ikon Dark
                    : Icon(Icons.light_mode_rounded, color: Colors.orangeAccent, size: 18), // Ikon Light
                textBuilder: (value) => value // Teks di dalam (opsional)
                    ? Center(child: Text('Dark', style: TextStyle(fontSize: 10, color: Colors.white)))
                    : Center(child: Text('Light', style: TextStyle(fontSize: 10, color: Colors.black))),
              ),
            ),

          Flexible(
              child: _SearchBarWidget(
                searchController: _searchController,
                searchQuery: _searchQuery,
              ),
            ),
            const SizedBox(width: 16), // Jarak kanan
          ],
        ),
        body: Column(
          children: [
            _WelcomeBanner(),
            _FilterToggle(
              selectedFilter: _selectedFilter,
              onFilterChanged: (newFilter) {
                setState(() {
                  _selectedFilter = newFilter;
                });
              },
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 8.0),
                children: [
                  // Tampilkan pesan jika hasil pencarian kosong
                  if (filteredList.isEmpty && _searchQuery.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'Kendaraan "${_searchQuery}" tidak ditemukan.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                      ),
                    )
                  else
                    ...categories.map((category) {
                    final items = groupedData[category]!;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Chip(
                            label: Text(category),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                        ),
                        // --- HAPUS ConstrainedBox DI SINI ---
                        Center( // Grid tetap di tengah
                          child:ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            child: GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400, // Lebar maksimal item
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              mainAxisExtent: 500.0, // Tinggi kartu tetap
                            ),
                            itemBuilder: (context, index) {
                              final kendaraan = items[index];
                              return _VehicleCard(
                                kendaraan: kendaraan,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailScreen(kendaraan: kendaraan),
                                       ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Posisi kanan bawah
        floatingActionButton: FloatingActionButton.extended( // Gunakan extended untuk teks+ikon
          onPressed: () async { // Logika onPressed tetap sama
            DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
            String info = 'Info Perangkat Tidak Diketahui';
            try {
              if (kIsWeb) {
                WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
                info = 'Browser: ${webBrowserInfo.browserName} (${webBrowserInfo.appVersion})';
              } else if (Platform.isAndroid) {
                AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
                info = 'Android: ${androidInfo.manufacturer} ${androidInfo.model} (SDK ${androidInfo.version.sdkInt})';
              } else if (Platform.isIOS) {
                IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
                info = 'iOS: ${iosInfo.name} ${iosInfo.model} (${iosInfo.systemVersion})';
              }
            } catch (e) {
              info = 'Gagal mendapatkan info perangkat.';
            }

            if (mounted) {
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text(
                    info,
                    style: TextStyle(color: Colors.white),
                    ),
                   backgroundColor: kSurfaceColor,
                   behavior: SnackBarBehavior.floating, // Buat mengambang sedikit
                   margin: const EdgeInsets.all(10), // Beri margin
                 ),
               );
            }
          },
          label: const Text('Info Dev'), // Teks tombol
          icon: const Icon(Icons.info_outline), // Ikon tombol
          backgroundColor: kSurfaceColor, // Warna latar tombol
          foregroundColor: Colors.white, // Warna teks & ikon
        ),
      ),
    );
  }
}

// --- WIDGET KARTU KENDARAAN (STATEFUL) ---
class _VehicleCard extends StatefulWidget {
  final Kendaraan kendaraan;
  final VoidCallback onTap;

  const _VehicleCard({required this.kendaraan, required this.onTap});

  @override
  State<_VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<_VehicleCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bool isLightMode = brightness == Brightness.light;

    final Color primaryTextColor = isLightMode ? Colors.black87 : Colors.white; // Hitam (sedikit pudar) saat terang, putih saat gelap
    final Color secondaryTextColor = isLightMode ? Colors.grey.shade600 : Colors.grey.shade400;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: isLightMode ? Colors.white : Colors.transparent, // Kartu putih saat terang, transparan (mengikuti background) saat gelap
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLightMode ? Colors.grey.shade300 : Colors.white.withOpacity(0.5),
          width: 0.5,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Judul & Deskripsi
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.kendaraan.merk} ${widget.kendaraan.model}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryTextColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.kendaraan.deskripsi,
                  style:
                      TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor
                        ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 2. Gambar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                widget.kendaraan.urlGambar,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.no_photography, size: 50)),
              ),
            ),
          ),


          // 3. Kotak Info Ungu (Seat & Class)
          Container(
            decoration: BoxDecoration(
              color: isLightMode ? kPrimaryColor.withOpacity(0.15) : null,
              gradient: isLightMode ? null : LinearGradient( // Hanya gradient saat gelap
                colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.7)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),

            margin: const EdgeInsets.all(12.0),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoColumn("SEAT", "${widget.kendaraan.seat} SEATER", isLightMode),
                _InfoColumn("CLASS", widget.kendaraan.vehicleClass, isLightMode),
              ],
            ),
          ),

          // 4. Daftar Info (Type, Stock, Drive Type)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                _InfoRow(Icons.category_outlined, "Type", widget.kendaraan.vehicleType, primaryTextColor, secondaryTextColor),
                _InfoRow(Icons.inventory_2_outlined, "Stock", widget.kendaraan.stockStatus, primaryTextColor, secondaryTextColor),
                _InfoRow(Icons.settings_outlined, "Drive Type", widget.kendaraan.driveType, primaryTextColor, secondaryTextColor),
              ],
            ),
          ),

          const Expanded(
            child: SizedBox(height: 12),
          ),

          // 5. Tombol Detail (Sudah benar posisinya)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Tombol ke kanan
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Harga tidak ditampilkan

                MouseRegion(
                  onEnter: (_) => setState(() => _isHovering = true),
                  onExit: (_) => setState(() => _isHovering = false),
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: BorderRadius.circular(30.0),

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isHovering
                        ? kPrimaryColor 
                        : (isLightMode ? Colors.grey.shade200 : Colors.white),
                      ),

                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        child: Icon(
                          _isHovering ? Icons.arrow_forward : Icons.arrow_outward,
                          key: ValueKey<bool>(_isHovering),
                          size: 20,
                          color: _isHovering 
                          ? Colors.white 
                          : (isLightMode ? Colors.black54 : kSurfaceColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _InfoColumn(String title, String value, bool isLightMode) {
    final Color titleColor = isLightMode ? kPrimaryColor.withOpacity(0.7) : Colors.white70;
    final Color valueColor = isLightMode ? kPrimaryColor : Colors.white;

    return Column(
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 10,
                color: titleColor,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 14,
                color: valueColor,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _InfoRow(IconData icon, String title, String value, Color valueColor, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: labelColor),
          const SizedBox(width: 8),
          Text(
            "$title: ",
            style: TextStyle(fontSize: 12, color: labelColor),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 12,
                  color: valueColor,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET BANNER ---
class _WelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: kSurfaceColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.redAccent, // Warna dasar teks (putih)
        highlightColor: Colors.yellow, // Warna kilauan
        period: const Duration(milliseconds: 2500), // Durasi shimmer
        child: Column( // Kolom teks asli tetap di dalam shimmer
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text( // Hapus const agar bisa di-shimmer
              "Welcome To MotionCars",
              style: TextStyle(
      fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white), // Warna ini akan jadi baseColor
            ),
            const SizedBox(height: 4),
            const Text( // Hapus const agar bisa di-shimmer
              "Start strong, play smart, and create your legacy.",
              style: TextStyle(fontSize: 14, color: Colors.white70), // Warna ini akan jadi baseColor
            ),
          ],
        ),
      ),
      // --- 👆 AKHIR SHIMMER 👆 ---
    );
  }
}


// --- WIDGET FILTER ---
class _FilterToggle extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterChanged;

  const _FilterToggle({
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _IndividualFilterTab(
            text: "KATALOG MOBIL",
            isSelected: selectedFilter == "Mobil",
            onTap: () => onFilterChanged("Mobil"),
          ),
          const SizedBox(width: 10),
          _IndividualFilterTab(
            text: "KATALOG MOTOR",
            isSelected: selectedFilter == "Motor",
            onTap: () => onFilterChanged("Motor"),
          ),
        ],
      ),
    );
  }
}

class _IndividualFilterTab extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _IndividualFilterTab({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_IndividualFilterTab> createState() => _IndividualFilterTabState();
}

class _IndividualFilterTabState extends State<_IndividualFilterTab> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    Color backgroundColor;  
    FontWeight fontWeight;

    if (isLightMode) {
      // Logika untuk Tema Terang
      final bool useLightPurpleColor = !widget.isSelected && !_isHovering;
      backgroundColor = useLightPurpleColor
          ? kPrimaryColor.withOpacity(0.5) // Ganti ke ungu muda (atau warna lain)
          : kSurfaceColor;

      fontWeight = useLightPurpleColor ? FontWeight.bold : FontWeight.normal;
    } else {
      // Logika untuk Tema Gelap (seperti sebelumnya)
      final bool useDarkColor = widget.isSelected || (!widget.isSelected && _isHovering);
      backgroundColor = useDarkColor ? kSurfaceColor : kPrimaryColor;
      fontWeight = useDarkColor ? FontWeight.normal : FontWeight.bold;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: fontWeight,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

// --- WIDGET BARU UNTUK SEARCH BAR DI APPBAR ---
class _SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;

  const _SearchBarWidget({
    required this.searchController,
    required this.searchQuery,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230, // Atur lebar search bar di sini
      height: 40, // Atur tinggi search bar di sini
      child: TextField(
        controller: searchController,
        style: const TextStyle(fontSize: 14), // Ukuran font dalam search bar
        decoration: InputDecoration(
          hintText: 'Cari Kendaraan...',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    searchController.clear();
                  },
                )
              : null,
          filled: true,
          fillColor: kSurfaceColor.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        ),
      ),
    );
  }
}