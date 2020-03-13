import 'dart:io';

import 'package:canli_sohbet3/common_widget/social_login_button.dart';
import 'package:canli_sohbet3/view_models/user_model.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilTab extends StatefulWidget {
  @override
  _ProfilTabState createState() => _ProfilTabState();
}

class _ProfilTabState extends State<ProfilTab> {
  File _profilFoto;

  TextEditingController _controllerUsername;


  Future<void> _updateUsername(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.user.userName != _controllerUsername.text) {
      var updateResult = await _userModel.usernameGuncelle(
          _userModel.user.userID, _controllerUsername.text);

      if (updateResult == true) {
        FlushbarHelper.createSuccess(
          title: 'Kayıt Başarılı!',
          message: "İsim değişikliği kaydedildi!",
        ).show(context);
      } else {
        _controllerUsername.text = _userModel.user.userName;
        FlushbarHelper.createError(
          title: 'Hata!',
          message:
              "Kullanıcı adı zaten kullanımda! Farklı bir kullanıcı adı deneyiniz!",
        ).show(context);
      }
    } else {
      FlushbarHelper.createError(
        title: 'Hata!',
        message: "İsim değişikliği yapılmadı!",
      ).show(context);
    }
  }

  Future<void> _galeridenSec() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilFoto = _yeniResim;
      Navigator.of(context).pop();
    });
  }

  Future<void> _kameradanCek() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _profilFoto = _yeniResim;
      Navigator.of(context).pop();
    });
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    if(_profilFoto!=null){
      var url = await _userModel.uploadFile(_userModel.user.userID, "profil_foto", _profilFoto);
      print("Foto Url:$url");

      if (url != null) {
        FlushbarHelper.createSuccess(
          title: 'Değişiklik Başarılı!',
          message: "Profil resmi başarıyla değiştirildi!",
        ).show(context);
     }
    }
     
  }

  @override
  void initState() {
    super.initState();
    _controllerUsername = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _controllerUsername.text = _userModel.user.userName;
    print("Profil page'deki user değerleri: ${_userModel.user}");

    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: Text("Profil"),
          actions: <Widget>[
            /*FlatButton(
            onPressed: () => _girisyap(context),
            child: Text(
              "Giriş Yap",
              style: TextStyle(color: Colors.white),
            ),
          ),*/
            FlatButton(
              onPressed: () => _cikisyap(context),
              child: Text(
                "Çıkış Yap",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 160,
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.camera),
                                      title: Text("Kameradan Çek"),
                                      onTap: () {
                                        _kameradanCek();
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.image),
                                      title: Text("Galeriden Seç"),
                                      onTap: () {
                                        _galeridenSec();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: (_profilFoto == null)
                            ? NetworkImage(_userModel.user.profilFotoURL)
                            : FileImage(_profilFoto),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.grey.shade100),
                      initialValue: _userModel.user.email,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "E-postanız",
                        hintText: "E-posta",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _controllerUsername,
                      style: TextStyle(color: Colors.grey.shade100),
                      decoration: InputDecoration(
                        labelText: "Kullanıcı Adınız",
                        hintText: "Kullanıcı Adı",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  SocialLoginButton(
                    buttonText: "Kaydet",
                    onPressed: () {
                      _updateUsername(context);
                      _profilFotoGuncelle(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _cikisyap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  
}
