import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum AcilanHesap { None, Anonymous, Facebook, Google, EmailPassword }

class User {
  String userID, email, userName, profilFotoURL;
  DateTime createdAt, updatedAt;
  int seviye;

  //AcilanHesap type;

  User({@required this.userID, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName':
          userName ?? email.substring(0, email.indexOf('@')) + randomSayiUret(),
      'profilFotoURL': profilFotoURL ??
          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT57wkqEHAxTCbIEB6fdNMnczglRodkuBYTKMLKGU4m34GRWa-F',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilFotoURL = map['profilFotoURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        seviye = map['seviye'];

  User.idveResim({@required this.userID, @required this.profilFotoURL});

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, userName: $userName, profilFotoURL: $profilFotoURL, createdAt: $createdAt, updatedAt: $updatedAt, seviye: $seviye}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999999);
    return rastgeleSayi.toString();
  }
}
