import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:canli_sohbet3/app/konusmalar.dart';
import 'package:canli_sohbet3/view_models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:canli_sohbet3/view_models/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'models/user.dart';
import 'package:path_provider/path_provider.dart';

// ignore: implementation_imports
import 'package:provider/src/change_notifier_provider.dart';
import 'package:http/http.dart' as http;

// ignore: implementation_imports
import 'package:provider/src/provider.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("Background gelen mesaj: ${message["data"]}");
    Notifications.showNotification(message);
  }
  return Future<void>.value();
}

class Notifications {
  FirebaseMessaging _fcm = FirebaseMessaging();

  static final Notifications _singleton = Notifications._internal();

  factory Notifications() {
    return _singleton;
  }

  Notifications._internal();

  BuildContext myContext;

  initializeFCMNotification(BuildContext context) async {
    myContext = context;
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);


    /*
    _fcm.subscribeToTopic("baran");
    String token = await _fcm.getToken();
    print("token:$token");
    */

    _fcm.onTokenRefresh.listen((newToken) async {
      FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();
      await Firestore.instance
          .document("tokens/" + _currentUser.uid)
          .setData({"token": newToken});
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch: $message");
        showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume: $message");
        showNotification(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
    );
  }

  static void showNotification(Map<String, dynamic> message) async {
    await _downloadAndSaveImage(message["data"]["profilFotoURL"], 'largeIcon');

    var mesaj = Person(
        name: message["data"]["title"],
        key: '1',
        //icon: userURLPath,
        iconSource: IconSource.FilePath);
    var mesajStyle = MessagingStyleInformation(mesaj,
        messages: [Message(message["data"]["message"], DateTime.now(), mesaj)]);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1234', 'Yeni Mesaj', 'your channel description',
        style: AndroidNotificationStyle.Messaging,
        styleInformation: mesajStyle,
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message["data"]["title"],
        message["data"]["message"], platformChannelSpecifics,
        payload: jsonEncode(message));
  }

  // ignore: missing_return
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {}

  Future onSelectNotification(String payload) async {
    final _userModel = Provider.of<UserModel>(myContext);

    if (payload != null) {
      // debugPrint('notification payload: ' + payload);

      Map<String, dynamic> gelenBildirim = await jsonDecode(payload);

      Navigator.of(myContext, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ChatModel(
                currentUser: _userModel.user,
                sohbetUser: User.idveResim(
                    userID: gelenBildirim["data"]["gonderenUserID"],
                    profilFotoURL: gelenBildirim["data"]["profilFotoURL"])),
            child: Konusmalar(),
          ),
        ),
      );
    }
  }

  static _downloadAndSaveImage(String url, String name) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$name';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
