import 'package:flutter/material.dart';
import '../i18n/strings.dart';

class LanguageService extends ChangeNotifier {
  String lang = 'en';

  Map<String, String> get text =>
      lang == 'en' ? AppStrings.en : AppStrings.bn;

  void switchLang(String l) {
    lang = l;
    notifyListeners();
  }
}
