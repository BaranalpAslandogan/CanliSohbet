import 'package:cloud_firestore/cloud_firestore.dart';

class Konusma {
  // ignore: non_constant_identifier_names
  final String konusma_sahibi;
  // ignore: non_constant_identifier_names
  final String kimle_konusuyor;
  final bool gorulme;
  // ignore: non_constant_identifier_names
  final Timestamp olusturulma_tarihi;
  // ignore: non_constant_identifier_names
  final String son_atilan_mesaj;
  // ignore: non_constant_identifier_names
  final Timestamp gorulme_tarihi;
  String konusulanUserName;
  String konusulanUserProfilURL;
  DateTime sonOkunmaTarihi;
  String aradakiFark;

  Konusma(
      // ignore: non_constant_identifier_names
      {this.konusma_sahibi,
      // ignore: non_constant_identifier_names
      this.kimle_konusuyor,
      this.gorulme,
      // ignore: non_constant_identifier_names
      this.olusturulma_tarihi,
      // ignore: non_constant_identifier_names
      this.son_atilan_mesaj,
      // ignore: non_constant_identifier_names
      this.gorulme_tarihi});

  Map<String, dynamic> toMap() {
    return {
      'konusma_sahibi': konusma_sahibi,
      'kimle_konusuyor': kimle_konusuyor,
      'gorulme': gorulme,
      'olusturulma_tarihi': olusturulma_tarihi ?? FieldValue.serverTimestamp(),
      'son_atilan_mesaj': son_atilan_mesaj,
      'gorulme_tarihi': gorulme_tarihi,
    };
  }

  Konusma.fromMap(Map<String, dynamic> map)
      : konusma_sahibi = map['konusma_sahibi'],
        kimle_konusuyor = map['kimle_konusuyor'],
        gorulme = map['gorulme'],
        olusturulma_tarihi = map['olusturulma_tarihi'],
        son_atilan_mesaj = map['son_atilan_mesaj'],
        gorulme_tarihi = map['gorulme_tarihi'];

  @override
  String toString() {
    return 'Konusma{konusma_sahibi: $konusma_sahibi, kimle_konusuyor: $kimle_konusuyor, gorulme: $gorulme, olusturulma_tarihi: $olusturulma_tarihi, son_atilan_mesaj: $son_atilan_mesaj, gorulme_tarihi: $gorulme_tarihi}';
  }

}

