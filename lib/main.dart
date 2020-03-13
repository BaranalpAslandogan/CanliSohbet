import 'package:canli_sohbet3/app/landing_page.dart';
import 'package:canli_sohbet3/locator.dart';
import 'package:canli_sohbet3/view_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(){
  setuplocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (context)=>UserModel(),
      child: MaterialApp(
        title: "Canlı Sohbet",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple.shade700,
        ),
        home: Landing_page(),
      ),
    );
  }
}
