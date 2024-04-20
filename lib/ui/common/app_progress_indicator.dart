import 'package:flutter/material.dart';
import 'package:speakupp/common/app_resourses.dart';

class AppProgressIndicator {
  Widget inderminateProgress(bool isLoading, {Color color = Colors.green}) {
    return Container(
      color: AppResourses.appColors.whiteColor,
      height: 2,
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      child: LinearProgressIndicator(
        color: color,
        backgroundColor: AppResourses.appColors.background,
        value: isLoading ? null : 0,
      ),
    );
  }
}
