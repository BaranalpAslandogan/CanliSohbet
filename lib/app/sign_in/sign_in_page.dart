import 'package:canli_sohbet3/common_widget/social_login_button.dart';
import 'package:canli_sohbet3/models/user.dart';
import 'package:canli_sohbet3/view_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'email_sifre_giris_ve_kayit.dart';


class SignInPage extends StatelessWidget {

  void _emailSifreGiris(BuildContext context) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => EmailSifreLoginPage()
      ),
    );
  }


  void _emailSifreKayit(BuildContext context) async{
    Navigator.of(context)
        .push(
      MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => EmailSifreLoginPage()
      ),
    );
  }

  void _anonimGiris(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    User _user = await _userModel.signInAnonymously();
    debugPrint("Anonim ID:" + _user.userID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Canlı Sohbet"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Container(
        color: Colors.grey.shade600,
        padding: EdgeInsets.all(23),
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(backgroundColor: Colors.deepOrange,radius: 50,),
            SizedBox(
              height: 30,
            ),
            Text(
              "Canlı Sohbet Uygulamasına Hoşgeldiniz.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              height: 35,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SocialLoginButton(
                  buttonColor: Colors.teal.shade600,
                  textColor: Colors.white,
                  genislik: 142,
                  buttonText: "Giriş Yap",
                  onPressed: () => _emailSifreGiris(context),
                ),
                SocialLoginButton(
                  genislik: 142,
                  buttonColor: Colors.teal.shade600,
                  textColor: Colors.white,
                  buttonText: "Kayıt ol",
                  onPressed: () => _emailSifreKayit(context),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            FlatButton(child: Text("Misafir Olarak Giriş Yap",style: TextStyle(color: Colors.black54),),
              onPressed: () => _anonimGiris(context),
            ),
          ],
        ),
      ),
    );
  }

}
