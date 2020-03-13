import 'package:canli_sohbet3/models/user.dart';
import 'package:canli_sohbet3/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService with ChangeNotifier implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  //UserRepo _repoType;

  //UserRepo get repotype => _repoType;

  @override
  Future<User> currentUser() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user); //user.
    } catch (e) {
      print("Hata: " + e.toString());
      return null;
    }
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(userID: user.uid,email: user.email);
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      AuthResult sonuc = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("Anonim giriş hatası: $e");
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      final _facebookSignIn = FacebookLogin();
      await _facebookSignIn.logOut();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("SignOut Hatası: $e");
      return false;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try{
      GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      if (_googleUser != null) {
        GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
        if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
          AuthResult sonuc = await _firebaseAuth
              .signInWithCredential(GoogleAuthProvider.getCredential(
            idToken: _googleAuth.idToken,
            accessToken: _googleAuth.accessToken,
          ));
          FirebaseUser _user = sonuc.user;
          return _userFromFirebase(_user);
        }
        else {
          return null;
        }
      } else {
        return null;
      }
    }
    catch(e){
      debugPrint("Google Sign in service hatası $e");
      return null;
    }

  }

  @override
  // ignore: missing_return
  Future<User> convertWithGoogle() async {
    final currentUser = await _firebaseAuth.currentUser();
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken,);
    await currentUser.linkWithCredential(credential);
  }


  @override
  // ignore: missing_return
  Future<User> convertFacebook() async{
    final currentUser = await _firebaseAuth.currentUser();
    final FacebookLoginResult _facebookResult = await _facebookLogin.logIn(['public_profile', 'email']);

    AuthCredential _convert = FacebookAuthProvider.getCredential(accessToken: _facebookResult.accessToken.token);
    await currentUser.linkWithCredential(_convert);
  }

  @override
  Future<User> signInWithFacebook() async {
    final _facebookLogin = FacebookLogin();

    FacebookLoginResult _facebookResult =
        await _facebookLogin.logIn(['public_profile', 'email']);

    switch (_facebookResult.status) {
      case FacebookLoginStatus.loggedIn:
        if (_facebookResult.accessToken != null) {
          AuthResult _firebaseResult = await _firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(
              accessToken: _facebookResult.accessToken.token));

          FirebaseUser _user = _firebaseResult.user;
          return _userFromFirebase(_user);
        }
        break;

      case FacebookLoginStatus.cancelledByUser:
        print("Kullanıcı Facebook Girişini İptal Etti.");
        break;

      case FacebookLoginStatus.error:
        print("Hata Çıkış Yaptı: " + _facebookResult.errorMessage);
        break;
    }

    return null;
  }



  @override
  Future<User> createEmailPassword(String email, String password) async{
      AuthResult sonuc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(sonuc.user);
  }

  @override
  Future<User> signInEmailPassword(String email, String password) async{
      AuthResult sonuc = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(sonuc.user);
  }

  @override
  // ignore: missing_return
  Future<User> convertEmailPassword(String email, String password) async{
    final currentUser = await _firebaseAuth.currentUser();
    AuthCredential credential = EmailAuthProvider.getCredential(email:email, password:password);
    await currentUser.linkWithCredential(credential);
  }

}





















