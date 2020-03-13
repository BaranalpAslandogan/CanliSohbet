import 'package:canli_sohbet3/app/konusmalar.dart';
import 'package:canli_sohbet3/models/konusma.dart';
import 'package:canli_sohbet3/models/user.dart';
import 'package:canli_sohbet3/view_models/chat_model.dart';
import 'package:canli_sohbet3/view_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KonusmalarTab extends StatefulWidget {
  @override
  _KonusmalarTabState createState() => _KonusmalarTabState();
}

class _KonusmalarTabState extends State<KonusmalarTab> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text("Konuşmalarım sayfası"),
      ),
      body: FutureBuilder<List<Konusma>>(
        future: _userModel.getAllConversations(_userModel.user.userID),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = konusmaListesi.data;

            if (tumKonusmalar.length > 0) {
              return RefreshIndicator(
                onRefresh: _konusmalariYenile,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var anlikKonusma = tumKonusmalar[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => ChatModel(
                              currentUser: _userModel.user,
                              sohbetUser: User.idveResim(
                                  userID: anlikKonusma.kimle_konusuyor,
                                  profilFotoURL:
                                  anlikKonusma.konusulanUserProfilURL),
                              ),
                              child: Konusmalar(),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.deepPurple.shade700,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(anlikKonusma.konusulanUserProfilURL),
                          ),
                          title: Text(anlikKonusma.konusulanUserName,style: TextStyle(color: Colors.white70),),
                          subtitle: Text(anlikKonusma.son_atilan_mesaj +
                              "  -->  " +
                              anlikKonusma.aradakiFark.toString(),style: TextStyle(color: Colors.white38),),
                        ),
                      ),
                    );
                  },
                  itemCount: tumKonusmalar.length,
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _konusmalariYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.speaker_notes_off,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          Text(
                            "Kimseye Ait Bir Mesajınız Yok!",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.black54, fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height - 150,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  /*void _konusmalariGetir() async {
    final _userModel = Provider.of<UserModel>(context);
    var konusmalarim = await Firestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _userModel.user.userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();

    for (var konusma in konusmalarim.documents) {
      print("Konuşma: ${konusma.data}");
    }
  }*/

  Future<void> _konusmalariYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
