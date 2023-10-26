import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
          locale: Provider.of<LanguageProvider>(context)
              .selectedLocale /* SharedPrefs().getLocale()*/,

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
}
