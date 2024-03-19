import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/constants.dart';
import '../../firebase/firebase_service.dart';
import '../../gen/assets.gen.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if(FirebaseAuth.instance.currentUser!=null){

        FirebaseService().getUserData().then((user){
          if(user!=null && user.isActive){
            Navigator.of(context).pushReplacementNamed(AppConstant.homeView);
          }else{
            showRestrictedDialog(context);
          }
        });


      }else{
        Navigator.of(context).pushReplacementNamed(AppConstant.loginView);
      }
    });
  }

  showRestrictedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Access Restricted'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have been restricted by the admin.'),
                Text('Please try again later.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                SystemNavigator.pop(); // Attempts to close the application
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        Assets.images.background.image(fit: BoxFit.cover),
        Positioned(
          top: 100,
          child: Assets.images.logo.image(
            height: 300,
            width: 400
          ),
        )
      ],
    ));
  }
}
