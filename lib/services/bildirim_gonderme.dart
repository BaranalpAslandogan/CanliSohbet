import 'package:canli_sohbet3/models/mesaj.dart';
import 'package:canli_sohbet3/models/user.dart';
import 'package:http/http.dart' as http;

class BildirimGonderim {
  // ignore: missing_return
  Future<bool> notificationGonder(
      Mesaj gonderilecekBildirim, User gonderenUser, String token) async {
    String endURL = "https://fcm.googleapis.com/fcm/send";
    String firebaseKey =
        "AAAALYC42L0:APA91bHPTxiiGHZegfQepfYCkBSsZtRwSL9ZFxcQMsGPUFRvPPsigKGBCnH4kADXuQQIrJFk4C08oHBODYPlriZo3IUzKq-smOHO4dijlgf0ozvAj8DKA6BO6j82HnMk9YNfaRk7DAgX";
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "key=$firebaseKey"
    };

    String json =
        '{ "to" : "$token", "data" : { "message" : "${gonderilecekBildirim.mesaj}", "title": "${gonderenUser.userName} yeni mesaj", "profilFotoURL": "${gonderenUser.profilFotoURL}", "gonderenUserID" : "${gonderenUser.userID}" } }';

    http.Response response =
        await http.post(endURL, headers: headers, body: json);

    if (response.statusCode == 200) {
      print("işlem basarılı");
    } else {
      /*print("işlem basarısız:" + response.statusCode.toString());
      print("jsonumuz:" + json);*/
    }
  }
}
