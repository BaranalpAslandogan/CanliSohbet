import 'package:canli_sohbet3/models/user.dart';


abstract class AuthBase{

  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<bool> signOut();
  Future<User> signInWithGoogle();
  Future<User> convertWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> convertFacebook();
  Future<User> signInEmailPassword(String email, String password);
  Future<User> createEmailPassword(String email, String password);
  Future<User> convertEmailPassword(String email, String password);

}