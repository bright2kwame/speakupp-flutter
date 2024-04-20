import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/ui/main/home_tab_page.dart';
import 'package:speakupp/ui/onboard/splash_screen_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtility {
  //get the app inforamtion for display

  static startHome(BuildContext context) async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeTabPage()),
      (Route<dynamic> route) => false,
    );
  }

  static startApp(BuildContext context) async {
    final sl = GetIt.instance;
    var userItemProvider = sl.get<UserItemProvider>();
    await userItemProvider.deleteAll();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => const SplashScreenPage(users: [])),
      (Route<dynamic> route) => false,
    );
  }

  static Future<void> startlaunchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Color randomColor() {
    return baseRandomColor().withAlpha(50);
  }

  static Color baseRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  static Future<void> startSharingContent(String content,
      {String? title = "SpeakUpp Digital Services"}) async {
    await Share.share(content, subject: title);
  }

//MARK: print message in debug but hide in production
  static printLogMessage(var data, String tag) {
    const bool prod = bool.fromEnvironment('dart.vm.product');
    if (!kReleaseMode && !prod) {
      if (kDebugMode) {
        print("$tag:- $data");
      }
    }
  }
}
