import 'package:hive/hive.dart';

part 'veresiye_model.g.dart';

@HiveType(typeId: 0)
class VeresiyeModel {
  @HiveField(0)
  String musteriAdi;

  @HiveField(1)
  double borcTutari;

  @HiveField(2)
  DateTime tarih;

  @HiveField(3)
  bool odendi;

  @HiveField(4)
  String not;

  @HiveField(5) // ✅ Yeni alan: ödenen toplam miktar
  double odenenTutar;

  VeresiyeModel(
    this.musteriAdi,
    this.borcTutari,
    this.tarih,
    this.odendi,
    this.not, [
    this.odenenTutar = 0.0, // varsayılan 0.0
  ]);
}
