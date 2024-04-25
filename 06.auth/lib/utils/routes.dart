import 'package:auth/ui/home_screen.dart';
import 'package:auth/ui/login.dart';
import 'package:auth/ui/register.dart';
import 'package:flutter/material.dart';

MaterialPageRoute _pageRoute(
        {required Widget body, required RouteSettings settings}) =>
    MaterialPageRoute(builder: (_) => body, settings: settings);
Route? generateRoute(RouteSettings settings) {
  Route? route;
  final args = settings.arguments;
  switch (settings.name) {
    case rLogin:
      route = _pageRoute(body: LoginScreen(), settings: settings);
      break;
    case rRegister:
      route = _pageRoute(body: RegisterScreen(), settings: settings);
      break;
    case rHome:
      route = _pageRoute(body: HomeScreen(), settings: settings);
      break;
  }
  return route;
}

final NAV_KEY = GlobalKey<NavigatorState>();
const String rLogin = '/login';
const String rRegister = '/register';
const String rHome = '/home';
