import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem{Kullanicilar, Konusmalar, Profil}

class TabItemData{
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTab = {
    TabItem.Kullanicilar: TabItemData("Kullanıcılar", Icons.people),
    TabItem.Konusmalar: TabItemData("Konusmalar", Icons.message),
    TabItem.Profil: TabItemData("Profil", Icons.account_box),
  };
}