import 'kendaraan.dart';
class Motor extends Kendaraan {
  final String _tipeTransmisi;
  final int _kapasitasMesinCC;
  final String _tenaga;
  final String _tipeMesin;

  const Motor(
    String merk,
    String model,
    int tahunRilis,
    String urlGambar,
    String deskripsi,
    
    int price,
    int seat,
    String vehicleClass,
    String vehicleType,
    String stockStatus,
    String driveType,
    
    this._tipeTransmisi,
    this._kapasitasMesinCC,
    this._tenaga,
    this._tipeMesin,
  ) : super(
          merk,
          model,
          tahunRilis,
          urlGambar,
          deskripsi,
          price,
          seat,
          vehicleClass,
          vehicleType,
          stockStatus,
          driveType,
        );

  String get tipeTransmisi => _tipeTransmisi;
  int get kapasitasMesinCC => _kapasitasMesinCC;
  String get tenaga => _tenaga;
  String get tipeMesin => _tipeMesin;

  @override
  String getJenisKendaraan() => "Motor";
  @override
  String getSpesifikasiUtama() {
    return "Tenaga: $_tenaga\nTipe Mesin: $_tipeMesin\nTransmisi: $_tipeTransmisi\nKapasitas: $_kapasitasMesinCC CC";
  }
}