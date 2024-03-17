import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fresh_find_user/routing/app_route.dart';
import 'package:fresh_find_user/themes/app_theme.dart';


import 'constants/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyAUzqLJ8bNaFpW9I5EAFNaANB0DUWX2X78',
        appId: '1:651772940713:android:ffb57f6544d2f8ba65b4b8',
        messagingSenderId: '651772940713',
        projectId: 'groceryappmultivendor-53e5b',
        storageBucket: 'groceryappmultivendor-53e5b.appspot.com"'
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
