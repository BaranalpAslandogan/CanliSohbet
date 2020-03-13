import 'package:canli_sohbet3/models/konusma.dart';
import 'package:canli_sohbet3/models/mesaj.dart';
import 'package:canli_sohbet3/models/user.dart';
import 'package:canli_sohbet3/services/database_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDbService implements DBBase {
  final Firestore _firestore = Firestore.instance;

  @override
  Future<bool> saveUser(User user) async {
    DocumentSnapshot _userOku =
        await Firestore.instance.document("users/${user.userID}").get();

    if (_userOku.data == null) {
      await _firestore
          .collection("users")
          .document(user.userID)
          .setData(user.toMap());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<User> readUser(String userID) async {
    DocumentSnapshot _readedUser =
        await _firestore.collection("users").document(userID).get();
    Map<String, dynamic> _readedUserMap = _readedUser.data;

    User _readedUserNesne = User.fromMap(_readedUserMap);
    print("User Nesnesi readed: " + _readedUserNesne.toString());
    return _readedUserNesne;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    var users = await _firestore
        .collection("users")
        .where("userName", isEqualTo: newUserName)
        .getDocuments();
    if (users.documents.length >= 1) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .document(userID)
          .updateData({'userName': newUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilFoto(String userID, String profilFotoURL) async {
    await _firestore
        .collection("users")
        .document(userID)
        .updateData({'profilURL': profilFotoURL});
    return true;
  }

  /* tüm kullanıcıları çağırma metodu
  @override
  Future<List<User>> getAllUsers() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection("users").getDocuments();

    List<User> allUsers = [];
    for (DocumentSnapshot tekUser in querySnapshot.documents) {
      User _tekUser = User.fromMap(tekUser.data);
      allUsers.add(_tekUser);
    }

    //Map Metoduyla
    //allUsers = querySnapshot.documents.map((tekSatir)=>User.fromMap(tekSatir.data)).toList();

    return allUsers;
  }*/

  @override
  Stream<List<Mesaj>> getMessages(String currentUserID, String sohbetUserID) {
    var snapShot = _firestore
        .collection("konusmalar")
        .document(currentUserID + "--" + sohbetUserID)
        .collection("mesajlar")
        .where("konusmaSahibi", isEqualTo: currentUserID)
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
    return snapShot.map((mesajListe) => mesajListe.documents
        .map((mesaj) => Mesaj.fromMap(mesaj.data))
        .toList());
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firestore.collection("konusmalar").document().documentID;
    var _myDocumentID =
        kaydedilecekMesaj.gonderici + "--" + kaydedilecekMesaj.alici;
    var _aliciUserID =
        kaydedilecekMesaj.alici + "--" + kaydedilecekMesaj.gonderici;

    var _saveMessageMapYapi = kaydedilecekMesaj.toMap();

    await _firestore
        .collection("konusmalar")
        .document(_myDocumentID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_saveMessageMapYapi);

    await _firestore.collection("konusmalar").document(_myDocumentID).setData({
      "konusma_sahibi": kaydedilecekMesaj.gonderici,
      "kimle_konusuyor": kaydedilecekMesaj.alici,
      "son_atilan_mesaj": kaydedilecekMesaj.mesaj,
      "gorulme": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    _saveMessageMapYapi.update("bendenMi", (deger) => false);
    _saveMessageMapYapi.update(
        "konusmaSahibi", (deger) => kaydedilecekMesaj.alici);

    await _firestore
        .collection("konusmalar")
        .document(_aliciUserID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_saveMessageMapYapi);

    await _firestore.collection("konusmalar").document(_aliciUserID).setData({
      "konusma_sahibi": kaydedilecekMesaj.alici,
      "kimle_konusuyor": kaydedilecekMesaj.gonderici,
      "son_atilan_mesaj": kaydedilecekMesaj.mesaj,
      "gorulme": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<Konusma>> getAllConversations(String userID) async {
    QuerySnapshot querysnapshot = await _firestore
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();

    List<Konusma> tumKonusmalar = [];

    for (DocumentSnapshot tekKonusma in querysnapshot.documents) {
      Konusma _tekKonusma = Konusma.fromMap(tekKonusma.data);
      tumKonusmalar.add(_tekKonusma);
    }

    return tumKonusmalar;
  }

  @override
  Future<DateTime> showTime(String userID) async {
    await _firestore.collection("server").document(userID).setData({
      "saat": FieldValue.serverTimestamp(),
    });
    var okunanMap =
        await _firestore.collection("server").document(userID).get();
    Timestamp okunanTarih = okunanMap.data["saat"];

    return okunanTarih.toDate();
  }

  @override
  Future<List<User>> getUserWithPagination(
      User enSonGetirilenKullanici, int elemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<User> _tumKullanicilar = [];

    if (enSonGetirilenKullanici == null) {
      _querySnapshot = await Firestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(elemanSayisi)
          .getDocuments();
    } else {
      _querySnapshot = await Firestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSonGetirilenKullanici.userName])
          .limit(elemanSayisi)
          .getDocuments();
      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.documents) {
      User _tekUser = User.fromMap(snap.data);
      _tumKullanicilar.add(_tekUser);
    }

    return _tumKullanicilar;
  }

  Future<List<Mesaj>> getMessageWithPagination(
      String currentUserID,
      String sohbetUserID,
      Mesaj enSonGetirilenMesaj,
      int getirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<Mesaj> _tumMesajar = [];

    if (enSonGetirilenMesaj == null) {
      _querySnapshot = await Firestore.instance
          .collection("konusmalar")
          .document(currentUserID + "--" + sohbetUserID)
          .collection("mesajlar")
          .where("konusmaSahibi", isEqualTo: currentUserID)
          .orderBy("date", descending: true)
          .limit(getirilecekElemanSayisi)
          .getDocuments();
    } else {
      _querySnapshot = await Firestore.instance
          .collection("konusmalar")
          .document(currentUserID + "--" + sohbetUserID)
          .collection("mesajlar")
          .where("konusmaSahibi", isEqualTo: currentUserID)
          .orderBy("date", descending: true)
          .startAfter([enSonGetirilenMesaj.date])
          .limit(getirilecekElemanSayisi)
          .getDocuments();
      await Future.delayed(Duration(seconds: 1));
    }

    for (DocumentSnapshot snap in _querySnapshot.documents) {
      Mesaj _tekMesaj = Mesaj.fromMap(snap.data);
      _tumMesajar.add(_tekMesaj);
    }

    return _tumMesajar;
  }

  Future<String> getToken(String alici) async {
    DocumentSnapshot _token =
        await _firestore.document("tokens/" + alici).get();
    if (_token != null) {
      return _token.data["token"];
    } else
      return null;
  }
}
