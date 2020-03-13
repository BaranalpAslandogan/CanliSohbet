import 'package:canli_sohbet3/app/home_page.dart';
import 'package:canli_sohbet3/app/sign_in/sign_in_page.dart';
import 'package:canli_sohbet3/view_models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: camel_case_types
class Landing_page extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final _userModel=Provider.of<UserModel>(context);
    if(_userModel.state == ViewState.Idle){
      if(_userModel.user==null){
        return SignInPage();
      }
      else{
        return HomePage(user: _userModel.user);
      }
    }
    else{
      return Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Center(
          child: CircularProgressIndicator(backgroundColor: (Colors.purple),),
        ),
      );
    }
  }
}
