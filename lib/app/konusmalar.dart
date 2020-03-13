import 'package:canli_sohbet3/models/mesaj.dart';
import 'package:canli_sohbet3/view_models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Konusmalar extends StatefulWidget {
  @override
  _KonusmalarState createState() => _KonusmalarState();
}

class _KonusmalarState extends State<Konusmalar> {
  var _mesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatModel>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: _chatModel.state == ChatState.Busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
              children: <Widget>[
                _buildMesajListe(),
                _buildYeniMesajGir(),
              ],
            )),
    );
  }

  Widget _buildMesajListe() {
    return Consumer<ChatModel>(
      builder: (context, chatModel, child) {
        return Expanded(
          child: ListView.builder(
            controller: _scrollController,
            reverse: true,
            itemBuilder: (context, index) {
              if (chatModel.hasMoreLoading &&
                  chatModel.mesajlar.length == index) {
                return _yeniElemanYukleIndicator();
              } else
                return konusmaBalonuOlustur(chatModel.mesajlar[index]);
            },
            itemCount: chatModel.hasMoreLoading
                ? chatModel.mesajlar.length + 1
                : chatModel.mesajlar.length,
          ),
        );
      },
    );
  }

  Widget _buildYeniMesajGir() {
    final _chatModel = Provider.of<ChatModel>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _mesajController,
              cursorColor: Colors.blueGrey,
              style: new TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                fillColor: Colors.grey,
                filled: true,
                hintText: "Mesaj Yaz...",
                hintStyle: TextStyle(color: Colors.white70),
                border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: Colors.purple.shade400,
              child: Icon(
                Icons.send,
                size: 30,
                color: Colors.tealAccent,
              ),
              onPressed: () async {
                if (_mesajController.text.trim().length > 0) {
                  Mesaj _kaydedilecekMesaj = Mesaj(
                    gonderici: _chatModel.currentUser.userID,
                    alici: _chatModel.sohbetUser.userID,
                    bendenMi: true,
                    mesaj: _mesajController.text,
                    konusmaSahibi: _chatModel.currentUser.userID,
                  );
                  var sonuc = await _chatModel.saveMessage(
                      _kaydedilecekMesaj, _chatModel.currentUser);
                  if (sonuc) {
                    _mesajController.clear();
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 100),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget konusmaBalonuOlustur(Mesaj anlikMesaj) {
    Color _alinanMesajRenk = Colors.teal.shade500;
    Color _gonderilenMesajRenk = Theme.of(context).primaryColor;
    final _chatModel = Provider.of<ChatModel>(context);

    var _zamanDegeri = "";

    try {
      _zamanDegeri = _zamanGoster(anlikMesaj.date ?? Timestamp(1, 2));
    } catch (e) {
      print("Error:$e");
    }

    var _isMyMessage = anlikMesaj.bendenMi;
    if (_isMyMessage) {
      return Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  _zamanDegeri,
                  style: TextStyle(color: Colors.white54),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _gonderilenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      anlikMesaj.mesaj,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(_chatModel.sohbetUser.profilFotoURL),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _alinanMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    child: Text(
                      anlikMesaj.mesaj,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Text(
                  _zamanDegeri,
                  style: TextStyle(color: Colors.white54),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ],
        ),
      );
    }
  }

  String _zamanGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      eskiMesajlariGetir();
    }
  }

  _yeniElemanYukleIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> eskiMesajlariGetir() async {
    final _chatModel = Provider.of<ChatModel>(context);
    if (_isLoading == false) {
      _isLoading = true;
      await _chatModel.dahaFazlaMesajGetir();
      _isLoading = false;
    }
  }
}
