import 'package:canli_sohbet3/models/user.dart';
import 'package:canli_sohbet3/services/auth_base.dart';


class FakeAuthService implements AuthBase {
  String userId = "kaws123SAD52swAV2158";

  @override
  Future<User> currentUser() async {
    return await Future.value(User(userID: userId, email: "fake123@fake.fake"));
  }

  @override
  Future<User> signInAnonymously() async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userID: userId, email: "fake123@fake.fake"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<User> signInWithGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userID: "google_id_123321", email: "fake123@fake.fake"));
  }

  @override
  Future<User> signInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userID: "facebook_id_123321", email: "fake123@fake.fake"));
  }

  @override
  Future<User> convertFacebook() async{
    return await Future.delayed(
        Duration(seconds: 2), () => User(userID: "convert_facebook_id_123321", email: "fake123@fake.fake"));
  }

  @override
  Future<User> createEmailPassword(String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userID: "Kayit_Eposta_id_123321", email: "fake123@fake.fake"));
  }

  @override
  Future<User> signInEmailPassword(String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userID: "Giris_Eposta_id_123321", email: "fake123@fake.fake"));
  }

  @override
  Future<User> convertWithGoogle() async{
    return await Future.delayed(
        Duration(seconds: 2), () => User(userID: "Convert google_id_12234412", email: "fake123@fake.fake"));
  }

  @override
  Future<User> convertEmailPassword(String email, String password) async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userID: "Convert google_id_12234412", email: "fake123@fake.fake"));
  }

}
