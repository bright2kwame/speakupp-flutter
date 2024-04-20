import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/di/injection.dart';
import 'package:speakupp/model/user/user_item.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/speakupp_app.dart';

Future<void> main() async {
  final sl = GetIt.instance;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: AppResourses.appColors.primaryColor,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  await init();
  await sl.allReady();
  var userItemProvider = sl.get<UserItemProvider>();
  List<UserItem> users = await userItemProvider.list();
  runApp(SpeakuppApp(
    users: users,
  ));
}
