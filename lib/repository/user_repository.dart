import 'dart:io';

import 'package:canli_sohbet3/locator.dart';
import 'package:canli_sohbet3/models/konusma.dart';
import 'package:canli_sohbet3/models/mesaj.dart';
import 'package:canli_sohbet3/models/user.dart';
import 'package:canli_sohbet3/services/auth_base.dart';
import 'package:canli_sohbet3/services/bildirim_gonderme.dart';
import 'package:canli_sohbet3/services/fake_auth_service.dart';
import 'package:canli_sohbet3/services/firebase_auth_service.dart';
import 'package:canli_sohbet3/services/firebase_storage_service.dart';
import 'package:canli_sohbet3/services/firestoredb_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepo with ChangeNotifier implements AuthBase {
  //User usertype;

  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDbService _firestoreDbService = locator<FirestoreDbService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  BildirimGonderim _bildirimGonderim = locator<BildirimGonderim>();

  AppMode appMode = AppMode.RELEASE;
  List<User> allUsersList = [];
  Map<String,String> userToken = Map<String,String>();

  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      User _user = await _firebaseAuthService.currentUser();
      if (_user != null) {
        return await _firestoreDbService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      //usertype.type= AcilanHesap.Anonymous;
      return await _fakeAuthService.signInAnonymously();
    } else {
      //usertype.type= AcilanHesap.Anonymous;
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      //usertype.type= AcilanHesap.Google;
      return await _fakeAuthService.signInWithGoogle();
    } else {
      //usertype.type= AcilanHesap.Google;
      User _user = await _firebaseAuthService.signInWithGoogle();
      if (_user != null) {
        bool _sonuc = await _firestoreDbService.saveUser(_user);
        if (_sonuc == true) {
          return await _firestoreDbService.readUser(_user.userID);
        } else {
          await _firebaseAuthService.signOut();
          return null;
        }
      } else
        return null;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      //usertype.type= AcilanHesap.Facebook;
      return await _fakeAuthService.signInWithFacebook();
    } else {
      //usertype.type= AcilanHesap.Facebook;
      User _user = await _firebaseAuthService.signInWithFacebook();

      if (_user != null) {
        bool _sonuc = await _firestoreDbService.saveUser(_user);
        if (_sonuc == true) {
          return await _firestoreDbService.readUser(_user.userID);
        }
        else {
          await _firebaseAuthService.signOut();
          return null;
        }
      }
      else{
        return null;
      }
    }
  }

  @override
  Future<User> convertFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.convertFacebook();
    } else {
      return await _firebaseAuthService.convertFacebook();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      //usertype.type= AcilanHesap.None;
      return await _fakeAuthService.signOut();
    } else {
      //usertype.type= AcilanHesap.None;
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<User> createEmailPassword(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createEmailPassword(email, password);
    } else {
      User _user =
          await _firebaseAuthService.createEmailPassword(email, password);
      bool _sonuc = await _firestoreDbService.saveUser(_user);
      if (_sonuc == true) {
        return await _firestoreDbService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> signInEmailPassword(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      //usertype.type= AcilanHesap.EmailPassword;
      return await _fakeAuthService.signInEmailPassword(email, password);
    } else {
      //usertype.type= AcilanHesap.EmailPassword;
      User _user =
          await _firebaseAuthService.signInEmailPassword(email, password);
      return await _firestoreDbService.readUser(_user.userID);
    }
  }

  @override
  Future<User> convertWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.convertWithGoogle();
    } else {
      return await _firebaseAuthService.convertWithGoogle();
    }
  }

  @override
  Future<User> convertEmailPassword(String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.convertEmailPassword(email, password);
    } else {
      return await _firebaseAuthService.convertEmailPassword(email, password);
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDbService.updateUserName(userID, newUserName);
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linki";
    } else {
      var profilFotoURL = await _firebaseStorageService.uploadFile(
          userID, fileType, profilFoto);

      await _firestoreDbService.updateProfilFoto(userID, profilFotoURL);

      return profilFotoURL;
    }
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String sohbetUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDbService.getMessages(currentUserID, sohbetUserID);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj, User currentUser) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      var dbYazma = await _firestoreDbService.saveMessage(kaydedilecekMesaj);
      if(dbYazma){
        var token="";
        if(userToken.containsKey(kaydedilecekMesaj.alici)){
          token=userToken[kaydedilecekMesaj.alici];
          print("Lokal Cache'den Çağrıldı: $token");
        }
        else{
          token = await _firestoreDbService.getToken(kaydedilecekMesaj.alici);
          if(token!=null)
          userToken[kaydedilecekMesaj.alici]=token;
          print("Firebase'den  Çağrıldı: $token");
        }

        if(token!=null)
        await _bildirimGonderim.notificationGonder(kaydedilecekMesaj, currentUser, token);

        return true;
      }
      else return false;
    }
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    var konusmaList = await _firestoreDbService.getAllConversations(userID);
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _zaman = await _firestoreDbService.showTime(userID);

      for (var anlikKonusma in konusmaList) {
        var userInUserList = findListUser(anlikKonusma.kimle_konusuyor);

        if (userInUserList != null) {
          print("Veriler lokal cache'den getiriliyor.");
          anlikKonusma.konusulanUserName = userInUserList.userName;
          anlikKonusma.konusulanUserProfilURL = userInUserList.profilFotoURL;
        } else {
          print("Veriler Firebase'den Getiriliyor.");
          // ignore: non_constant_identifier_names
          var DBOkunanUser =
              await _firestoreDbService.readUser(anlikKonusma.kimle_konusuyor);
          anlikKonusma.konusulanUserName = DBOkunanUser.userName;
          anlikKonusma.konusulanUserProfilURL = DBOkunanUser.profilFotoURL;
        }
        timeagoHesapla(anlikKonusma, _zaman);
      }
    }
    return konusmaList;
  }

  User findListUser(String userID) {
    for (int i = 0; i < allUsersList.length; i++) {
      if (allUsersList[i].userID == userID) {
        return allUsersList[i];
      }
    }
    return null;
  }

  void timeagoHesapla(Konusma anlikKonusma, DateTime zaman) {
    anlikKonusma.sonOkunmaTarihi = zaman;
    timeago.setLocaleMessages("tr", timeago.TrMessages());

    var _duration = zaman.difference(anlikKonusma.olusturulma_tarihi.toDate());
    anlikKonusma.aradakiFark =
        timeago.format(zaman.subtract(_duration), locale: "tr");
  }

  Future<List<User>> getUserWithPagination(
      User enSonGetirilenKullanici, int elemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<User> _userList = await _firestoreDbService.getUserWithPagination(
          enSonGetirilenKullanici, elemanSayisi);
      allUsersList.addAll(_userList);
      return _userList;
    }
  }

  Future<List<Mesaj>> getMessageWithPagination(
      String currentUserID,
      String sohbetUserID,
      Mesaj enSonGetirilenMesaj,
      int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      return await _firestoreDbService.getMessageWithPagination(currentUserID,
          sohbetUserID, enSonGetirilenMesaj, getirilecekElemanSayisi);
    }
  }
}
