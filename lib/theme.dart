import 'package:flutter/material.dart';

class Theme with ChangeNotifier{
  static bool _isDark =true;

  //Retrieve the theme mode
  ThemeMode currentTheme(){
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  //Switch _isDark and notify users
  void switchTheme(){
    _isDark = !_isDark;
    notifyListeners();
  }
}