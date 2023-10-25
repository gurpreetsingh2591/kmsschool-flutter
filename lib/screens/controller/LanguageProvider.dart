
import 'package:flutter/cupertino.dart';

class LanguageProvider with ChangeNotifier {
  Locale _selectedLocale = const Locale('en');

  Locale get selectedLocale => _selectedLocale;

  void changeLanguage(Locale newLocale) {
    _selectedLocale = newLocale;
    notifyListeners();
  }
}