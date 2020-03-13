import 'dart:io';

import 'package:canli_sohbet3/locator.dart';
import 'package:canli_sohbet3/models/konusma.dart';
import 'package:canli_sohbet3/models/user.dart';
import 'package:canli_sohbet3/repository/user_repository.dart';
import 'package:canli_sohbet3/services/auth_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepo _userRepo = locator<UserRepo>();
  User _user;

  String emailHata;
  String sifreHata;
  String hataAl;

  AcilanHesap _hesap = AcilanHesap.None;

  User get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  AcilanHesap get anlik => _hesap;

  set anlik(AcilanHesap value) {
    _hesap = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }

  @override
  Future<User> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepo.currentUser();
      return _user;
    } catch (e) {
      debugPrint("Viewmodel Current User Hata: $e");
      hataAl = e.toString();
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepo.signInAnonymously();
      anlik = AcilanHesap.Anonymous;
      return _user;
    } catch (e) {
      debugPrint("Viewmodel Anonim User Hata: $e");
      hataAl = e.toString();
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepo.signInWithGoogle();
      if (_user != null) {
        anlik = AcilanHesap.Google;
        return _user;
      } else
        return null;
    } catch (e) {
      debugPrint("Viewmodel Google User Hata: $e");
      hataAl = e.toString();
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> convertWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepo.convertWithGoogle();
      return _user;
    } catch (e) {
      debugPrint("ViewModel Convert Google User Hata: $e");
      hataAl = e.toString();
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepo.signInWithFacebook();
      anlik = AcilanHesap.Facebook;
      if (_user != null)
        return _user;
      else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> convertFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepo.convertFacebook();
      return _user;
    } catch (e) {
      debugPrint("Viewmodel Convert Facebook User Hata: $e");
      hataAl = e.toString();
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepo.signOut();
      _user = null;
      anlik = AcilanHesap.None;
      return sonuc;
    } catch (e) {
      debugPrint("Viewmodel Signout User Hata: $e");
      hataAl = e.toString();
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> createEmailPassword(String email, String password) async {
    if (_emailSifreKontrol(email, password)) {
      try {
        state = ViewState.Busy;
        _user = await _userRepo.createEmailPassword(email, password);
        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

  @override
  Future<User> signInEmailPassword(String email, String password) async {
    try {
      if (_emailSifreKontrol(email, password)) {
        state = ViewState.Busy;
        _user = await _userRepo.signInEmailPassword(email, password);
        anlik = AcilanHesap.EmailPassword;
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String password) {
    var sonuc = true;

    if (password.length < 6) {
      sifreHata = "Şifreniz minimum 6 karakterli olmalı.";
      sonuc = false;
    } else {
      sifreHata = null;
    }

    if (!email.contains('@')) {
      emailHata = "Geçersiz Mail girdiniz.";
      sonuc = false;
    } else {
      emailHata = null;
    }

    return sonuc;
  }

  @override
  Future<User> convertEmailPassword(String email, String password) async {
    try {
      if (_emailSifreKontrol(email, password)) {
        state = ViewState.Busy;
        _user = await _userRepo.convertEmailPassword(email, password);
        return _user;
      } else
        return null;
    } catch (e) {
      debugPrint("Viewmodel Convert Email User Hata: $e");
      hataAl = e.toString();
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<bool> usernameGuncelle(String userID, String newUserName) async {
    var sonuc = await _userRepo.updateUserName(userID, newUserName);
    if (sonuc) {
      _user.userName = newUserName;
    }

    return sonuc;
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    var downloadLink = await _userRepo.uploadFile(userID, fileType, profilFoto);
    return downloadLink;
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    return await _userRepo.getAllConversations(userID);
  }

  Future<List<User>> getUserWithPagination(
      User enSonGetirilenKullanici, int elemanSayisi) async {
    return await _userRepo.getUserWithPagination(
        enSonGetirilenKullanici, elemanSayisi);
  }
}
