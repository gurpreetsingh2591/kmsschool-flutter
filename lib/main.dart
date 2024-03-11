import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/screens/controller/LanguageProvider.dart';
import 'package:kmschool/utils/shared_prefs.dart';
import 'package:kmschool/utils/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'app/FirebaseService.dart';
import 'app/app.dart';
import 'app/router.dart';
import 'firebase_options.dart';
FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    SharedPrefs.init(await SharedPreferences.getInstance());
  } catch (e) {
    if (kDebugMode) {
      print("Firebase initialization error: $e");
    }
  }
  await FirebaseService.initializeFirebase();

  messaging.getToken().then((token) {

    SharedPrefs().setTokenKey(token!);

  });
 // _configureFirebaseMessaging();
 // initializeNotificationChannel();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: appBaseColor),
          dialogBackgroundColor: Colors.black54,
          // Set the background color for dialogs
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
                color: Colors.white), // Set the text color for dialogs
            // Customize other text styles as needed
          ),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary, // Set button text color
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: MultiProvider(
          // Use MultiProvider to provide both LanguageProvider and MyApp
          providers: [
            ChangeNotifierProvider(create: (context) => LanguageProvider()),
          ],
          child:UpgradeAlert(
              dialogStyle: UpgradeDialogStyle.material,
              child: const Scaffold(
                body: MyApp(),
              )),

        ),
      )));

  /* runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));*/
  /* FlutterNativeSplash.remove();*/


}

/*void initializeNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'com.phonegap.kmsobserver', // Change this to your desired channel ID
    'KMSchool', // Change this to your desired channel name
    importance: Importance.high,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  _configureFirebaseMessaging();
}*/
void _configureFirebaseMessaging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print("onMessage: $message");
    }
    // Handle notification when the app is in the foreground
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      print("onMessageOpenedApp: $message");
    }
    // Handle notification when the app is in the background and opened by tapping on the notification

  });

  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    if (kDebugMode) {
      print("onBackgroundMessage: $message");
    }
    // Handle notification when the app is terminated
  });
}

