import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/screens/controller/LanguageProvider.dart';
import 'package:kmschool/utils/shared_prefs.dart';
import 'package:kmschool/utils/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'app/app.dart';
import 'app/router.dart';
import 'firebase_options.dart';
FirebaseMessaging messaging = FirebaseMessaging.instance;

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
  messaging.getToken().then((token) {

    SharedPrefs().setTokenKey(token!);

  });

// Handle the onMessage when the app is in foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle the message here
    print('Received a foreground message: ${message.notification!.title}');
  });

  // Handle the onMessageOpenedApp when the app is in background or terminated
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle the message here
    print('User tapped on the notification when the app is in background or terminated: ${message.notification!.title}');

    // Navigate to the desired screen here
    // For example:
    // Navigator.pushNamed(context, '/desired-screen');
  });

  // Handle background messages if necessary
  FirebaseMessaging.onBackgroundMessage((message) async {
    // Handle background message here
    //_handleNotification(message.data, context);
    print('Handling a background message ${message.messageId}');
  });

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
/*
void _configureFirebaseMessaging() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print("onMessage: $message");
    }
    // Handle notification when the app is in the foreground
    _handleNotification(message.data);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (kDebugMode) {
      print("onMessageOpenedApp: $message");
    }
    // Handle notification when the app is in the background and opened by tapping on the notification
    _handleNotification(message.data);

  });

  FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
    if (kDebugMode) {
      print("onBackgroundMessage: $message");
    }
    // Handle notification when the app is terminated
    _handleNotification(message.data);
  });
}*/

void _handleNotification(Map<String, dynamic> message,BuildContext context) {
  // Extract the screen name from the data payload
  String screenName = message['screen'];

  // Navigate to the corresponding screen
  if (screenName == "calendar") {
    // Example of using named routes for navigation
    context.push(Routes.schoolCalender);
    //Navigator.pushNamed(context, '/$screenName');
  }else if (screenName == "message_to_parent") {
    // Example of using named routes for navigation
    context.push(Routes.messageToTeacher);
    //Navigator.pushNamed(context, '/$screenName');
  }else if (screenName == "Lunch") {
    // Example of using named routes for navigation
    context.push(Routes.lunchMenu);
    //Navigator.pushNamed(context, '/$screenName');
  }else if (screenName == "Snack") {
    // Example of using named routes for navigation
    context.push(Routes.snackMenu);
    //Navigator.pushNamed(context, '/$screenName');
  }else if (screenName == "photos") {
    // Example of using named routes for navigation
    context.push(Routes.studentPhotos);
    //Navigator.pushNamed(context, '/$screenName');
  }else  {
    // Example of using named routes for navigation
    context.push(Routes.mainHome);
    //Navigator.pushNamed(context, '/$screenName');
  }
}
