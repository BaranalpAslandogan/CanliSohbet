import 'package:canli_sohbet3/app/konusmalar.dart';
import 'package:canli_sohbet3/view_models/all_users_model.dart';
import 'package:canli_sohbet3/view_models/chat_model.dart';
import 'package:canli_sohbet3/view_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KullanicilarTab extends StatefulWidget {
  @override
  _KullanicilarTabState createState() => _KullanicilarTabState();
}

class _KullanicilarTabState extends State<KullanicilarTab> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_listeScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          "Kullanıcılar",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<AllUserModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.refresh,
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {

                  if(model.kullanicilarListesi.length==1){
                    return _tekKullaniciVar();
                  }
                  else if (model.hasMoreLoading &&
                      index == model.kullanicilarListesi.length) {
                    return _yeniElemanYukleIndicator();
                  } else {
                    return _userListeElemanOlustur(index);
                  }
                },
                itemCount: model.hasMoreLoading
                    ? model.kullanicilarListesi.length + 1
                    : model.kullanicilarListesi.length,
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }


  Widget _tekKullaniciVar(){
    final _kullanicilarModel=Provider.of<AllUserModel>(context);
    return RefreshIndicator(
      onRefresh: _kullanicilarModel.refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.sentiment_dissatisfied,
                  color: Theme.of(context).primaryColor,
                  size: 90,
                ),
                Text(
                  "Hiç Kullanıcı Yok, Siz Hariç...",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white38, fontSize: 20),
                ),
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height - 150,
        ),
      ),
    );
  }



  Widget _userListeElemanOlustur(int index) {
    final _userModel = Provider.of<UserModel>(context);
    final _allUserModel = Provider.of<AllUserModel>(context);
    var _anlikKullanici = _allUserModel.kullanicilarListesi[index];

    if (_anlikKullanici.userID == _userModel.user.userID) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context)=> ChatModel(currentUser:  _userModel.user, sohbetUser: _anlikKullanici),
              child: Konusmalar(),
            ),
          ),
        );
      },
      child: Card(
        color: Colors.deepPurple.shade700,
        child: ListTile(
          title: Text(
            _anlikKullanici.userName,
            style: TextStyle(color: Colors.white70),
          ),
          subtitle: Text(
            _anlikKullanici.email,
            style: TextStyle(color: Colors.white38),
          ),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(_anlikKullanici.profilFotoURL),
          ),
        ),
      ),
    );
  }

  _yeniElemanYukleIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void fazladanKullaniciGetir() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _allUserModel = Provider.of<AllUserModel>(context);
      await _allUserModel.fazladanKullaniciGetir();
      _isLoading = false;
    }
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Listenin tabanındayız.");
      fazladanKullaniciGetir();
    }
  }
}

/* Önceki Body Yapısı
Column(
  children: <Widget>[
    Expanded(
        child: _tumKullanicilar.length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.sentiment_dissatisfied,
                      size: 100,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      "Hiç Kullanıcı Yok, Siz Hariç... ",
                      style:
                          TextStyle(color: Colors.white54, fontSize: 20),
                    ),
                  ],
                ),
              )
            : _kullaniciListeOlustur()),
    _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(),
  ],
),
 */
