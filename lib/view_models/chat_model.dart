import 'dart:async';

import 'package:canli_sohbet3/locator.dart';
import 'package:canli_sohbet3/models/mesaj.dart';
import 'package:canli_sohbet3/models/user.dart';
import 'package:canli_sohbet3/repository/user_repository.dart';
import 'package:flutter/material.dart';

enum ChatState { Idle, Loaded, Busy }

class ChatModel with ChangeNotifier {
  List<Mesaj> _tumMesajlar;
  ChatState _state = ChatState.Idle;
  static final sayfaMesajGonderiSayisi = 10;
  bool _hasMore = true;
  bool _anlikMesajDinleme = false;
  final User currentUser;
  final User sohbetUser;
  Mesaj _enSonGetirilenMesaj;
  Mesaj _listeyeIlkEklenenEleman;

  bool get hasMoreLoading => _hasMore;

  StreamSubscription _streamSubscription;

  UserRepo _userRepo = locator<UserRepo>();

  ChatModel({this.currentUser, this.sohbetUser}) {
    _tumMesajlar = [];
    getMessageWithPagination(false);
  }

  List<Mesaj> get mesajlar => _tumMesajlar;

  ChatState get state => _state;

  set state(ChatState value) {
    _state = value;
    notifyListeners();
  }

  @override
  dispose() {
    print("ChatModel dispose edildi.") ;
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj, User currentUser) async {
    return await _userRepo.saveMessage(kaydedilecekMesaj,currentUser);
  }

  void getMessageWithPagination(bool yeniMesajGetirme) async {

    if (_tumMesajlar.length > 0) {
      _enSonGetirilenMesaj = _tumMesajlar.last;
    }
    if (!yeniMesajGetirme) state = ChatState.Busy;

    state = ChatState.Busy;
    var getirilenMesajlar = await _userRepo.getMessageWithPagination(
        currentUser.userID,
        sohbetUser.userID,
        _enSonGetirilenMesaj,
        sayfaMesajGonderiSayisi);

    if (getirilenMesajlar.length < sayfaMesajGonderiSayisi) {
      _hasMore = false;
    }

    getirilenMesajlar
        .forEach((mesage) => print("getirilen mesajlar: ${mesage.mesaj}"));

    _tumMesajlar.addAll(getirilenMesajlar);
    if(_tumMesajlar.length>0) {
      _listeyeIlkEklenenEleman = _tumMesajlar.first;
      print("ilk mesaj:${_listeyeIlkEklenenEleman.mesaj}");
    }

    state = ChatState.Loaded;

    if (_anlikMesajDinleme == false) {
      _anlikMesajDinleme = true;
      print("Listener yok o yüzden atanacak!");
      anlikMesajDinlemeAta();
    }
  }

  Future<void> dahaFazlaMesajGetir() async {
    print("fazladan mesaj getirme metodu tetiklendi - AllUserModel -");
    if (_hasMore)
      getMessageWithPagination(true);
    else
      print("Daha fazla mesaj kalmadı. Bu yüzden Çağırılmayacak.");
    await Future.delayed(Duration(seconds: 1, milliseconds: 30));
  }

  void anlikMesajDinlemeAta() {
    print("Listener Aktive Edildi(Mesajlar için)");
    _streamSubscription= _userRepo
        .getMessages(currentUser.userID, sohbetUser.userID)
        .listen((anlikdata) {

          if(anlikdata.isNotEmpty){
            print("Listener aktive edildi. Son getirilen Veri: ${anlikdata[0]}");

            if (anlikdata[0].date != null) {
              
              if(_listeyeIlkEklenenEleman == null){
                _tumMesajlar.insert(0, anlikdata[0]);
              }

              else if(_listeyeIlkEklenenEleman.date.millisecondsSinceEpoch!=anlikdata[0].date.millisecondsSinceEpoch){
                _tumMesajlar.insert(0, anlikdata[0]);
              }

            }
            state = ChatState.Loaded;
          }
    });
  }
}
