import 'package:canli_sohbet3/app/bottom_navbar.dart';
import 'package:canli_sohbet3/app/konusmalarim_page.dart';
import 'package:canli_sohbet3/app/kullanicilar.dart';
import 'package:canli_sohbet3/app/profil.dart';
import 'package:canli_sohbet3/app/tabb_items.dart';
import 'package:canli_sohbet3/notifications.dart';
import 'package:canli_sohbet3/view_models/all_users_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:canli_sohbet3/models/user.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Kullanicilar;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Konusmalar: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (context) => AllUserModel(),
        child: KullanicilarTab(),
      ),
      TabItem.Konusmalar: KonusmalarTab(),
      TabItem.Profil: ProfilTab(),
    };
  }

  @override
  void initState() {
    super.initState();
    Notifications().initializeFCMNotification(context);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: BottomNavbar(
        sayfaCreator: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
            print("Seçilen tabbitem: $secilenTab");
          }
        },
      ),
    );
  }
}

/* ÖNCEKİ ÇIKIŞ YAP METODU

Future<bool> _cikisyap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  void _girisyap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          fullscreenDialog: true, builder: (context) => EmailSifreLoginPage()),
    );
  }

 */

/*  ÖNCEKİ SCAFFOLD YAPISI

Scaffold(
      appBar: AppBar(
        title: Text("Anasayfa"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _girisyap(context),
            child: Text(
              "Giriş Yap",
              style: TextStyle(color: Colors.white),
            ),
          ),
          FlatButton(
            onPressed: () => _cikisyap(context),
            child: Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: BottomNavbar(
          sayfaCreator: tumSayfalar(),
          currentTab: _currentTab,
          onSelectedTab: (secilenTab) {
            setState(() {
              _currentTab = secilenTab;
            });
            print("Seçilen tabbitem: $secilenTab");
          },
        ),
      ),
    );

 */
