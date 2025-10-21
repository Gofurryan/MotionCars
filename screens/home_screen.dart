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

final List<Kendaraan> daftarKendaraan = [
  
  Mobil(
      "Honda", "Civic Type R", 2023, "assets/images/mobil_civic.png",
      "Hot hatchback legendaris yang menawarkan performa balap untuk penggunaan harian.",
      1180000, 4, "S", "Hot Hatch", "Available", "Front Wheel Drive",
      4, "Bensin", "315 HP", "Manual"),
  Mobil(
      "Toyota", "Supra GR", 2022, "assets/images/mobil_supra.png",
      "Mobil sport ikonik yang terlahir kembali dengan performa tinggi dan desain aerodinamis.",
      2100000, 2, "S", "Sports Car", "Available", "Rear Wheel Drive",
      2, "Bensin", "382 HP", "Otomatis"),
  Mobil(
      "Tesla", "Model S", 2024, "assets/images/mobil_tesla.png",
      "Sedan listrik mewah yang mendefinisikan ulang akselerasi dan teknologi otomotif.",
      1500000, 5, "S", "Electric Sedan", "Available", "All Wheel Drive",
      4, "Listrik", "670 HP", "Single-Speed"),
  Mobil(
      "Mitsubishi", "Pajero Sport", 2023, "assets/images/mobil_pajero.png",
      "SUV tangguh yang siap melibas segala medan dengan kenyamanan premium.",
      600000, 7, "A", "SUV", "Available", "4 Wheel Drive",
      4, "Diesel", "178 HP", "Otomatis"),
  Mobil(
      "Hyundai", "Ioniq 5", 2023, "assets/images/mobil_ioniq5.png",
      "Crossover listrik dengan desain retro-futuristik, interior lapang, dan teknologi canggih.",
      700000, 5, "A", "Electric Crossover", "Available", "Rear Wheel Drive",
      4, "Listrik", "225 HP", "Single-Speed"),
  
  Mobil(
      "Mazda", "MX-5 Miata", 2024, "assets/images/mobil_miata.png", 
      "Roadster ikonik yang ringan, lincah, dan menyenangkan untuk dikendarai.",
      850000, 2, "B", "Roadster", "Available", "Rear Wheel Drive",
      2, "Bensin", "181 HP", "Manual"),
  
  Motor(
      "Yamaha", "NMAX", 2024, "assets/images/motor_nmax.png",
      "Skutik premium populer dengan kenyamanan, bagasi luas, dan fitur konektivitas modern.",
      35000, 2, "M", "Skutik", "Available", "CVT (Belt)",
      "Otomatis", 155, "15.1 HP", "1-Silinder SOHC"),
  Motor(
      "Kawasaki", "Ninja ZX-25R", 2023, "assets/images/motor_ninja.png",
      "Satu-satunya motor sport 250cc dengan mesin 4-silinder, menghasilkan suara melengking khas moge.",
      105000, 2, "M", "Sportbike", "Available", "Chain Drive",
      "Manual", 250, "50.3 HP", "4-Silinder Segaris"),
  Motor(
      "Vespa", "Sprint 150", 2024, "assets/images/motor_vespa.png",
      "Skuter ikonik dengan gaya Italia klasik dan performa lincah untuk mobilitas perkotaan.",
      54000, 2, "M", "Skutik", "Available", "CVT",
      "Otomatis", 150, "11.6 HP", "1-Silinder i-get"),
  Motor(
      "Honda", "CB150X", 2023, "assets/images/motor_cb150x.png",
      "Motor adventure touring yang tangguh dan nyaman untuk perjalanan jarak jauh maupun harian.",
      34000, 2, "M", "Adventure", "Available", "Chain Drive",
      "Manual", 150, "15.4 HP", "1-Silinder DOHC"),
  Motor(
      "Harley-Davidson", "Sportster S", 2022, "assets/images/motor_harley.png",
      "Cruiser modern berperforma buas dari mesin Revolution Max 1250T yang legendaris.",
      600000, 1, "L", "Cruiser", "Available", "Belt Drive",
      "Manual", 1250, "121 HP", "V-Twin"),
];
class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = "Mobil";
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose(); 
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
                current: themeProvider.isDarkMode, 
                first: false, 
                second: true, 
                spacing: 25.0, 
                style: ToggleStyle( 
                  borderColor: Colors.transparent,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? kSurfaceColor.withOpacity(0.8)
                      : Colors.grey.shade200,
                  indicatorColor: Theme.of(context).scaffoldBackgroundColor, 
                ),
                borderWidth: 2.0,
                height: 35,
                indicatorSize: const Size(30, 30),
                onChanged: (b) => themeProvider.toggleTheme(b), 
                iconBuilder: (value) => value
                    ? Icon(Icons.dark_mode_rounded, color: kPrimaryColor, size: 18) 
                    : Icon(Icons.light_mode_rounded, color: Colors.orangeAccent, size: 18), 
                textBuilder: (value) => value 
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
            const SizedBox(width: 16), 
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
                        
                        Center( 
                          child:ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1200),
                            child: GridView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400, 
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              mainAxisExtent: 500.0, 
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, 
        floatingActionButton: FloatingActionButton.extended( 
          onPressed: () async { 
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
                   behavior: SnackBarBehavior.floating, 
                   margin: const EdgeInsets.all(10), 
                 ),
               );
            }
          },
          label: const Text('Info Dev'), 
          icon: const Icon(Icons.info_outline), 
          backgroundColor: kSurfaceColor, 
          foregroundColor: Colors.white, 
        ),
      ),
    );
  }
}


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

    final Color primaryTextColor = isLightMode ? Colors.black87 : Colors.white; 
    final Color secondaryTextColor = isLightMode ? Colors.grey.shade600 : Colors.grey.shade400;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: isLightMode ? Colors.white : Colors.transparent, 
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
          
          Container(
            decoration: BoxDecoration(
              color: isLightMode ? kPrimaryColor.withOpacity(0.15) : null,
              gradient: isLightMode ? null : LinearGradient( 
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
          
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, 
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
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
        baseColor: Colors.redAccent, 
        highlightColor: Colors.yellow, 
        period: const Duration(milliseconds: 2500), 
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text( 
              "Welcome To MotionCars",
              style: TextStyle(
      fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white), 
            ),
            const SizedBox(height: 4),
            const Text( 
              "Start strong, play smart, and create your legacy.",
              style: TextStyle(fontSize: 14, color: Colors.white70), 
            ),
          ],
        ),
      ),
      
    );
  }
}

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
      
      final bool useLightPurpleColor = !widget.isSelected && !_isHovering;
      backgroundColor = useLightPurpleColor
          ? kPrimaryColor.withOpacity(0.5) 
          : kSurfaceColor;

      fontWeight = useLightPurpleColor ? FontWeight.bold : FontWeight.normal;
    } else {
      
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
      width: 230, 
      height: 40, 
      child: TextField(
        controller: searchController,
        style: const TextStyle(fontSize: 14), 
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