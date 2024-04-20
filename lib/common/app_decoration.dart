import 'package:flutter/material.dart';
import 'package:speakupp/common/app_resourses.dart';

class AppDecoration {
  BoxDecoration gradientBoxDecoration = BoxDecoration(
      image: DecorationImage(
    image: AssetImage(AppResourses.appImages.baseGradient),
    fit: BoxFit.cover,
  ));
}
