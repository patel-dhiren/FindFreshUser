import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fresh_find_user/routing/app_route.dart';
import 'package:fresh_find_user/themes/app_theme.dart';


import 'constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyCAAvai19QRsN8T7_j01h6Xz7dkJkd8deQ',
        appId: '1:425734009309:android:7f2d9c5e14352881658634',
        messagingSenderId: '425734009309',
        projectId: 'fir-example-app-69765',
        storageBucket: 'fir-example-app-69765.appspot.com'
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: AppConstant.splashView,
      onGenerateRoute: AppRoute.generateRoute,
    );
  }
}
