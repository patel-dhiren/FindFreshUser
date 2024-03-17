import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
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
    Timer(Duration(seconds: 3), () {
      if(FirebaseAuth.instance.currentUser!=null){
        Navigator.of(context).pushReplacementNamed(AppConstant.homeView);
      }else{
        Navigator.of(context).pushReplacementNamed(AppConstant.loginView);
      }
    });
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
