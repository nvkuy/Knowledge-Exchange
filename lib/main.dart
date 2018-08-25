import 'package:flutter/material.dart';
import 'package:knowledge_exchange/navigation.dart';
import 'colors.dart';
// import 'login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  MyApp() {
    Navigation.initPaths();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Knowledge Exchange',
      theme: buildThemeData(),
      // home: new LoginPage(),
      onGenerateRoute: Navigation.router.generator,
    );
  }
}

ThemeData buildThemeData() {
  final baseTheme = ThemeData.light();
  return baseTheme.copyWith(
    primaryColor: mPrimaryColor,
    primaryColorDark: mPrimaryDarkColor,
    primaryColorLight: mPrimaryLightColor,
    accentColor: mSecondaryColor,
    buttonColor: mSecondaryColor,
    cardColor: mSecondaryLightColor,
    indicatorColor: mSecondaryLightColor,
  );
}
