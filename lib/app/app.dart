import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:kmschool/app/router.dart';
import 'package:kmschool/app/theme.dart';
import 'package:kmschool/utils/shared_prefs.dart';
import 'package:provider/provider.dart';

import '../screens/controller/LanguageProvider.dart';
import '../utils/MyCustomScrollBehavior.dart';
import 'AppLocalizationsDelegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Add this line

Locale locale = const Locale('en');

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final _appKey = GlobalKey();
  final _router = buildRouter();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();

   // _configureFirebaseMessaging();
    initializeNotificationChannel();
    /*_firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      // other callback functions like onLaunch, onResume, etc.
    );*/
  }

  void initializeNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'com.phonegap.kmsobserver', // Change this to your desired channel ID
      'kmschool', // Change this to your desired channel name
      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _configureFirebaseMessaging();
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ja'),
            Locale('ko'),
            Locale('fr'),
            Locale('it'),
            Locale('de'),
            Locale('es'),
            Locale('en'),
          ],
          locale: Provider.of<LanguageProvider>(context).selectedLocale /* SharedPrefs().getLocale()*/,

          /// Set the app's current locale
          scrollBehavior: MyCustomScrollBehavior(),
          key: _appKey,
          title: 'kmschool',
          routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          theme: mainTheme,

          debugShowCheckedModeBanner: false,
        );
  }
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

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessage: $message");
      }
      // Handle notification when the app is in the foreground
     // _handleNotification(message.data,context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessageOpenedApp: $message");
      }
      // Handle notification when the app is in the background and opened by tapping on the notification
      _handleNotification(message.data,context);

    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      if (kDebugMode) {
        print("onBackgroundMessage: $message");
      }
      // Handle notification when the app is terminated
      _handleNotification(message.data,context);
    });
  }
}
