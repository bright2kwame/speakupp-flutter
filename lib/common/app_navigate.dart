import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speakupp/common/app_router_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AppNavigate {
  final BuildContext context;

  AppNavigate(this.context);

  void navigateWithPush(Widget destinationScreen,
      {dynamic data, Function(bool)? callback}) {
    RouteSettings settings =
        RouteSettings(name: AppRouterConfig.item, arguments: data);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => destinationScreen,
          settings: settings),
    ).then((value) => {
          if (callback != null && value is bool) {callback(value)}
        });
  }

  void navigateWithRoute(Route<dynamic> destinationRoute,
      {Function(bool)? callback}) {
    dynamic result = Navigator.push(context, destinationRoute);
    if (callback != null && result is bool) {
      callback(result);
    }
  }

  Future<void> navigateNameWithPush(String destinationRoute,
      {dynamic data, Function(bool)? callback}) async {
    dynamic result = await Navigator.pushNamed(
      context,
      destinationRoute,
      arguments: data,
    );
    if (callback != null && result is bool) {
      callback(result);
    }
  }

  void navigateAndDismissAll(Widget destinationScreen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destinationScreen),
      (Route<dynamic> route) => false,
    );
  }

  static Future<void> startlaunchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> startSharingContent(String content,
      {String? title = "Hanfie - No Advance"}) async {
    await Share.share(content, subject: title);
  }
}
