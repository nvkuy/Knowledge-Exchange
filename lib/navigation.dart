import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'forgot_pass.dart';

class Navigation {
  static Router router;

  static void initPaths() {
    router = Router()
      ..define('/', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return LoginPage();
      }))
      ..define('forgot_pass_page', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return forgot_pass('Khôi phục tài khoản');
      }))
      ..define('home_page', handler: Handler(
          handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return MyHomePage(title: 'Knowledge Exchange');
      }));
  }

  static void navigateTo(
    BuildContext context,
    String path, {
    bool replace = false,
    TransitionType transition = TransitionType.native,
    Duration transitionDuration = const Duration(milliseconds: 250),
    RouteTransitionsBuilder transitionBuilder,
  }) {
    router.navigateTo(
      context,
      path,
      replace: replace,
      transition: transition,
      transitionDuration: transitionDuration,
      transitionBuilder: transitionBuilder,
    );
  }
}
