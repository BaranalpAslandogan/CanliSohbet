import 'package:cloud_firestore/cloud_firestore.dart';

class Mesaj {
  final String gonderici;
  final String alici;
  final bool bendenMi;
  final String mesaj;
  final Timestamp date;
  final String konusmaSahibi;

  Mesaj({
    this.gonderici,
    this.alici,
    this.bendenMi,
    this.mesaj,
    this.date,
    this.konusmaSahibi,
  });

  Map<String, dynamic> toMap() {
    return {
    'gonderici': gonderici,
    'alici': alici,
    'bendenMi': bendenMi,
    'mesaj': mesaj,
    'date': date ?? FieldValue.serverTimestamp(),
    'konusmaSahibi' : konusmaSahibi,
  };}

  Mesaj.fromMap(Map<String, dynamic> map)
      : gonderici = map['gonderici'],
        alici = map['alici'],
        bendenMi = map['bendenMi'],
        mesaj = map['mesaj'],
        date = map['date'],
        konusmaSahibi = map['konusmaSahibi'];

  @override
  String toString() {
    return 'Mesaj{gonderici: $gonderici, alici: $alici, bendenMi: $bendenMi, mesaj: $mesaj, date: $date}';
  }
}
