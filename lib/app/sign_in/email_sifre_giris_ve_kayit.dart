import 'package:canli_sohbet3/app/hata_exception.dart';
import 'package:canli_sohbet3/common_widget/social_login_button.dart';
import 'package:canli_sohbet3/models/user.dart';
import 'package:canli_sohbet3/view_models/user_model.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum FormType { Register, Login }

class EmailSifreLoginPage extends StatefulWidget {
  @override
  _EmailSifreLoginPageState createState() => _EmailSifreLoginPageState();
}

class _EmailSifreLoginPageState extends State<EmailSifreLoginPage> {
  String _email, _password;
  String _butontext, _linktext, _apptext;
  var _formType = FormType.Login;

  final _formkey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formkey.currentState.save();
    debugPrint("Eposta: " + _email + " Şifre: " + _password);
    final _userModel = Provider.of<UserModel>(context);

    if (_formType == FormType.Login) {
      try{
        User _girisUser = await _userModel.signInEmailPassword(_email, _password);
        if (_girisUser != null) {
          debugPrint("Eposta giriş ID:" + _girisUser.userID.toString());
          await FlushbarHelper.createSuccess(
            title: 'Giriş Başarılı!',
            message: "ID: ${_girisUser.userID.toString()}",
          ).show(context);
          Future.delayed(Duration(milliseconds: 100), () {
            Navigator.of(context).pop();
          });
        }
      }
      on PlatformException catch(e){
        debugPrint("${e.code}");
        await FlushbarHelper.createError(
          title: 'Hata!',
          message: "${Hatalar.goster(e.code)}",
        ).show(context);
      }


    } else {
      try{
        if (_userModel.anlik == AcilanHesap.Anonymous) {
          User _conv = await _userModel.convertEmailPassword(_email, _password);
          User _kayitUser =
          await _userModel.createEmailPassword(_email, _password);
          if (_kayitUser != null) {
            debugPrint("Kayıt olan ID:" + _conv.userID.toString());
            await FlushbarHelper.createSuccess(
              title: 'Kayıt İşlemi Tamamlandı!',
              message: "ID: ${_conv.userID.toString()}",
            ).show(context);
            Future.delayed(Duration(milliseconds: 100), () {
              Navigator.of(context).pop();
            });
          }
        } else {
          User _kayitUser =
          await _userModel.createEmailPassword(_email, _password);
          if (_kayitUser != null) {
            debugPrint("Kayıt olan ID:" + _kayitUser.userID.toString());
            await FlushbarHelper.createSuccess(
              title: 'Kayıt İşlemi Tamamlandı!',
              message: "ID: ${_kayitUser.userID.toString()}",
            ).show(context);
            Future.delayed(Duration(milliseconds: 100), () {
              Navigator.of(context).pop();
            });
          }
        }
      }
      on PlatformException catch(e){
        debugPrint("${e.code}");
        await FlushbarHelper.createError(
          title: 'Hata!',
          message: "${Hatalar.goster(e.code)}",
        ).show(context);
      }

    }
  }

  void _textDegis() {
    setState(() {
      _formType =
          _formType == FormType.Login ? FormType.Register : FormType.Login;
    });
  }

  void _googleIleGiris(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);

    try {
      if (_userModel.anlik == AcilanHesap.Anonymous) {
        //User _convert = await _userModel.convertWithGoogle();
        User _user = await _userModel.signInWithGoogle();
        if (_userModel.hataAl != null) {
          FlushbarHelper.createError(
            title: 'Hata Çıktısı',
            message: _userModel.hataAl,
          ).show(context);
        } else {
          debugPrint("Convert Google ID:" + _user.userID.toString());
          /*Future.delayed(Duration(milliseconds: 100), () {
              Navigator.of(context).pop();
            });*/
        }
      } else {
        User _user = await _userModel.signInWithGoogle();
        if (_user != null) {
          debugPrint("Google ID:" + _user.userID.toString());
          await FlushbarHelper.createSuccess(
            title: 'Giriş Başarılı!',
            message: "ID: ${_user.userID.toString()}",
          ).show(context);
          Future.delayed(Duration(milliseconds: 100), () {
            Navigator.of(context).pop();
          });
        }
      }
    } catch (e) {
      debugPrint("Google Giriş Hata Çıktısı: $e");
    }
  }

  void _facebookIleGiris(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    //final _anlikHesap = Provider.of<FirebaseAuthService>(context);

    try {
      if (_userModel.anlik == AcilanHesap.Anonymous) {
        User _conv = await _userModel.convertFacebook();
        User _user = await _userModel.signInWithFacebook();
        if (_user != null) {
          if (_userModel.hataAl != null) {
            FlushbarHelper.createError(
              title: 'Hata Çıktısı',
              message: _userModel.hataAl,
            ).show(context);
          } else {
            debugPrint("Converted Facebook ID:" + _conv.userID.toString());
            Future.delayed(Duration(milliseconds: 100), () {
              Navigator.of(context).pop();
            });
          }
        }
      } else {
        User _user = await _userModel.signInWithFacebook();
        debugPrint("Facebook ID:" + _user.userID.toString());
        Future.delayed(Duration(milliseconds: 100), () {
          Navigator.of(context).pop();
        });
      }
    } on PlatformException catch (e) {
      debugPrint("${e.code}");
      await FlushbarHelper.createError(
        title: 'Hata!',
        message: "${Hatalar.goster(e.code)}",
      ).show(context);
    }
  }

  bool passwordVisible = true;

  @override
  // ignore: must_call_super
  void initState() {
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    _apptext = _formType == FormType.Login ? "Giriş Formu" : "Kayıt Formu";
    _butontext = _formType == FormType.Login ? "Giriş Yap" : "Kaydol";
    _linktext = _formType == FormType.Login
        ? "Hesabın yok mu? Hemen Kaydol!"
        : "Hesabın var mı? O zaman giriş yap!";

    final _userModel = Provider.of<UserModel>(context);

    /*if(_userModel.user!=null){
      Future.delayed(Duration(milliseconds: 100),(){
        Navigator.of(context).pop();
      });
    }*/
    return Scaffold(
        appBar: AppBar(
          title: Text(_apptext),
        ),
        backgroundColor: Colors.grey.shade900,
        body: _userModel.state == ViewState.Idle
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 32,
                          ),
                          SocialLoginButton(
                            buttonIcon: Image.asset("images/facebook-logo.png"),
                            textColor: Colors.white,
                            radius: 15,
                            buttonColor: Color(0xFF334D92),
                            buttonText: "Facebook ile Giriş Yap",
                            onPressed: () => _facebookIleGiris(context),
                          ),
                          SocialLoginButton(
                            buttonIcon: Image.asset("images/google-logo.png"),
                            textColor: Colors.black87,
                            buttonColor: Colors.white,
                            buttonText: "Gmail ile Giriş Yap",
                            onPressed: () => _googleIleGiris(context),
                          ),
                          SizedBox(height: 46),
                          TextFormField(
                            style: TextStyle(color: Colors.grey.shade100),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 14),
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 14),
                              errorText: _userModel.emailHata != null
                                  ? _userModel.emailHata
                                  : null,
                              prefixIcon: Icon(
                                Icons.mail,
                                color: Colors.blueGrey,
                              ),
                              hintText: "E-posta",
                              labelText: "E-posta",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            onSaved: (String girilenEmail) {
                              _email = girilenEmail;
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            style: TextStyle(color: Colors.grey.shade100),
                            keyboardType: TextInputType.text,
                            obscureText: passwordVisible,
                            //This will obscure text dynamically
                            decoration: InputDecoration(
                              errorText: _userModel.sifreHata != null
                                  ? _userModel.sifreHata
                                  : null,
                              prefixIcon: Icon(
                                Icons.vpn_key,
                                color: Colors.blueGrey,
                              ),
                              hintText: "Şifre",
                              labelText: "Şifre",
                              labelStyle: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 14),
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 14),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                            onSaved: (String girilenPassword) {
                              _password = girilenPassword;
                            },
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          SocialLoginButton(
                            buttonText: _butontext,
                            buttonColor: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () => _formSubmit(),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          FlatButton(
                            onPressed: () => _textDegis(),
                            child: Text(
                              _linktext,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
