import 'kendaraan.dart';

class Mobil extends Kendaraan {
  final int _jumlahPintu;
  final String _jenisBahanBakar;
  final String _tenaga;
  final String _transmisi;

  const Mobil(
    String merk,
    String model,
    int tahunRilis,
    String urlGambar,
    String deskripsi,
    // DATA BARU DARI KENDARAAN
    int price,
    int seat,
    String vehicleClass,
    String vehicleType,
    String stockStatus,
    String driveType,
    // DATA SPESIFIK MOBIL
    this._jumlahPintu,
    this._jenisBahanBakar,
    this._tenaga,
    this._transmisi,
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

  int get jumlahPintu => _jumlahPintu;
  String get jenisBahanBakar => _jenisBahanBakar;
  String get tenaga => _tenaga;
  String get transmisi => _transmisi;

  @override
  String getJenisKendaraan() => "Mobil";

  @override
  String getSpesifikasiUtama() {
    return "Tenaga: $_tenaga\nTransmisi: $_transmisi\nJumlah Pintu: $_jumlahPintu\nBahan Bakar: $_jenisBahanBakar";
  }
}