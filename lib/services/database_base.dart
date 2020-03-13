import 'package:canli_sohbet3/models/konusma.dart';
import 'package:canli_sohbet3/models/mesaj.dart';
import 'package:canli_sohbet3/models/user.dart';

abstract class DBBase{

  Future<bool> saveUser(User user);
  Future<User> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updateProfilFoto(String userID,String profilFotoURL);
  Future<List<User>> getUserWithPagination(User enSonGetirilenKullanici, int elemanSayisi);
  Future<List<Konusma>> getAllConversations(String userID);
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<bool> saveMessage(Mesaj kaydedilecekMesaj);
  Future<DateTime> showTime(String userID);
}