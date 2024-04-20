import 'package:flutter/material.dart';
import 'package:speakupp/common/app_resourses.dart';

class AppFullscreenProgressView extends StatelessWidget {
  final String message;
  const AppFullscreenProgressView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: AppResourses.appColors.progressColorLight,
          valueColor: AlwaysStoppedAnimation<Color>(
              AppResourses.appColors.primaryColor),
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppResourses.appTextStyles.textStyle(16),
        ),
      ],
    ));
  }
}
