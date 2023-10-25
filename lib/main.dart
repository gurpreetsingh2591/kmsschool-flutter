import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kmschool/screens/controller/LanguageProvider.dart';
import 'package:kmschool/utils/shared_prefs.dart';
import 'package:kmschool/utils/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    SharedPrefs.init(await SharedPreferences.getInstance());
  } catch (e) {
    if (kDebugMode) {
      print("Firebase initialization error: $e");
    }
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MultiProvider(
          // Use MultiProvider to provide both LanguageProvider and MyApp
          providers: [
            ChangeNotifierProvider(create: (context) => LanguageProvider()),
          ],
          child: const MyApp(),
        ),
      )));

  /* runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));*/
  /* FlutterNativeSplash.remove();*/
}
