import 'package:canli_sohbet3/models/user.dart';
import 'package:canli_sohbet3/repository/user_repository.dart';
import 'package:flutter/material.dart';

import '../locator.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<User> _tumkullanicilar;
  User _enSonGetirilenKullanici;
  static final herSayfaGonderiSayisi = 10;
  bool _hasMore=true;

  bool get hasMoreLoading => _hasMore;

  UserRepo _userRepo = locator<UserRepo>();

  List<User> get kullanicilarListesi => _tumkullanicilar;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserModel() {
    _tumkullanicilar = [];
    _enSonGetirilenKullanici = null;
    getUserWithPagination(_enSonGetirilenKullanici, false);
  }

  //yeni elem getirme true yapılır.(refresh ve sayfalama için)
  //ilk açılış için yenielemanlar için false değer döndürülür.
  getUserWithPagination(
      User enSonGetirilenKullanici, bool yeniElemanlar) async {

    if (_tumkullanicilar.length > 0) {
      _enSonGetirilenKullanici = _tumkullanicilar.last;
      print("Sonuncu gelen username:" + _enSonGetirilenKullanici.userName);
    }

    if (yeniElemanlar) {
    } else {
      state = AllUserViewState.Busy;
    }


    var yeniListe = await _userRepo.getUserWithPagination(
        _enSonGetirilenKullanici, herSayfaGonderiSayisi);

    if(yeniListe.length<herSayfaGonderiSayisi){
      _hasMore=false;
    }

    yeniListe
        .forEach((userAd) => print("gelen username: ${userAd.userName}"));
    _tumkullanicilar.addAll(yeniListe);
    state = AllUserViewState.Loaded;

  }

  Future<void> fazladanKullaniciGetir() async {
    print("fazladan kullanıcı çağırma metodu tetiklendi - AllUserModel -");
    if(_hasMore)
    getUserWithPagination(_enSonGetirilenKullanici, true);
    else print("Daha fazla eleman kalmadı. Bu yüzden Çağırılmayacak.");
    await Future.delayed(Duration(seconds: 1, milliseconds: 30));
  }

  Future<Null> refresh() async{
    _hasMore = true;
    _enSonGetirilenKullanici = null;
    _tumkullanicilar=[];
    getUserWithPagination(_enSonGetirilenKullanici, true);
  }
}
