import 'package:canli_sohbet3/app/tabb_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({
    Key key,
    @required this.currentTab,
    @required this.onSelectedTab,
    @required this.sayfaCreator,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaCreator;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      backgroundColor: Colors.grey.shade900,
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.grey.shade700,
        inactiveColor: Colors.black54,
        activeColor: Theme.of(context).primaryColor,
        items: [
          _navItemCreate(TabItem.Kullanicilar),
          _navItemCreate(TabItem.Konusmalar),
          _navItemCreate(TabItem.Profil),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final showItem = TabItem.values[index];

        return CupertinoTabView(
          navigatorKey: navigatorKeys[showItem],
          builder: (context) {
            return sayfaCreator[showItem];
          },
        );
      },
    );
  }

  BottomNavigationBarItem _navItemCreate(TabItem tabItem) {
    final createdTab = TabItemData.allTab[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(createdTab.icon),
      title: Text(createdTab.title,style: TextStyle(fontSize: 12),),
    );
  }
}
