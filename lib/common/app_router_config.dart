import 'package:flutter/material.dart';
import 'package:speakupp/ui/onboard/splash_screen_page.dart';

class AppRouterConfig {
  static const routeOnboard = "/";
  static const data = "data";
  static const phoneNumber = "phoneNumber";
  static const countryCode = "countryCode";
  static const country = "country";
  static const item = "item";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeOnboard:
        return MaterialPageRoute(
            builder: (_) => const SplashScreenPage(
                  users: [],
                ),
            settings: settings);
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                body: Center(child: Text("Sorry, Route not found"))));
    }
  }
}
