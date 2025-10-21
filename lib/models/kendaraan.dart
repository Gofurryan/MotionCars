abstract class Kendaraan {
  final String _merk;
  final String _model;
  final int _tahunRilis;
  final String _urlGambar;
  final String _deskripsi;
  
  final int _price;
  final int _seat;
  final String _vehicleClass;
  final String _vehicleType;
  final String _stockStatus;
  final String _driveType;

  const Kendaraan(
    this._merk,
    this._model,
    this._tahunRilis,
    this._urlGambar,
    this._deskripsi,
    
    this._price,
    this._seat,
    this._vehicleClass,
    this._vehicleType,
    this._stockStatus,
    this._driveType,
  );

  String get merk => _merk;
  String get model => _model;
  int get tahunRilis => _tahunRilis;
  String get urlGambar => _urlGambar;
  String get deskripsi => _deskripsi;
  
  int get price => _price;
  int get seat => _seat;
  String get vehicleClass => _vehicleClass;
  String get vehicleType => _vehicleType;
  String get stockStatus => _stockStatus;
  String get driveType => _driveType;

  String getJenisKendaraan();
  String getSpesifikasiUtama(); 

  
  String get fullCategory {
    return "${getJenisKendaraan().toUpperCase()} - $vehicleClass CLASS";
  }
}