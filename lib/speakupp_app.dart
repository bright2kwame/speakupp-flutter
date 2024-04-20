import 'package:flutter/material.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/common/app_router_config.dart';
import 'package:speakupp/common/app_theme.dart';
import 'package:speakupp/model/user/user_item.dart';
import 'package:speakupp/ui/onboard/splash_screen_page.dart';

class SpeakuppApp extends StatelessWidget {
  final List<UserItem> users;
  const SpeakuppApp({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppResourses.appStrings.appName,
      theme: AppTheme(context).buildAppTheme(),
      onGenerateRoute: AppRouterConfig.generateRoute,
      home: users.isEmpty ? SplashScreenPage(users: users) : Container(),
    );
  }
}
