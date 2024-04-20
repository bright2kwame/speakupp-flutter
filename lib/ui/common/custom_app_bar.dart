import 'package:flutter/material.dart';
import 'package:speakupp/common/app_resourses.dart';

class CustomAppBar {
  static AppBar onBoardBar({
    String? title,
    Widget? action,
    Color? backgroundColor,
    Function? closingAction,
  }) {
    return AppBar(
      leading: IconButton(
          onPressed: closingAction == null
              ? null
              : () {
                  closingAction();
                },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
      title: title != null
          ? Text(title, style: AppResourses.appTextStyles.textStyle(16))
          : null,
      backgroundColor: backgroundColor ?? AppResourses.appColors.background,
      centerTitle: true,
      surfaceTintColor: backgroundColor ?? AppResourses.appColors.whiteColor,
      actions: action == null ? [] : [action],
    );
  }

  static AppBar leaderClosingBar(String title,
      {Function? closingAction, Color? backgroundColor}) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            closingAction!();
          },
          icon: const Icon(Icons.close)),
      title: Text(
        title,
        style:
            AppResourses.appTextStyles.textStyle(14, weight: FontWeight.bold),
      ),
      automaticallyImplyLeading: false,
      surfaceTintColor: backgroundColor ?? AppResourses.appColors.whiteColor,
      backgroundColor: backgroundColor ?? AppResourses.appColors.whiteColor,
      centerTitle: true,
    );
  }

  static AppBar trailingClosingBar(String title,
      {Function? closingAction, Color? backgroundColor}) {
    return AppBar(
      title: Text(
        title,
        style:
            AppResourses.appTextStyles.textStyle(14, weight: FontWeight.bold),
      ),
      surfaceTintColor: backgroundColor ?? AppResourses.appColors.whiteColor,
      backgroundColor: backgroundColor ?? AppResourses.appColors.whiteColor,
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            onPressed: () {
              closingAction!();
            },
            icon: const Icon(Icons.close)),
      ],
    );
  }

  static AppBar subBar(
      {String? title,
      List<Widget>? actions,
      Color? backgroundColor,
      Color? textColor = Colors.black,
      Function? leadingAction}) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: textColor,
        ),
        onPressed: leadingAction == null
            ? null
            : () {
                leadingAction();
              },
      ),
      title: title != null
          ? Text(
              title,
              style: AppResourses.appTextStyles
                  .textStyle(16, fontColor: textColor, weight: FontWeight.bold),
            )
          : null,
      surfaceTintColor: backgroundColor ?? AppResourses.appColors.whiteColor,
      backgroundColor: backgroundColor ?? AppResourses.appColors.whiteColor,
      centerTitle: true,
      actions: actions ?? [],
    );
  }

  static AppBar mainBar({
    List<Widget>? actions,
    Color? backgroundColor,
    Color? textColor = Colors.black,
  }) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      elevation: 0.0,
      shadowColor: AppResourses.appColors.darkColor,
      title: Image.asset(
        AppResourses.appImages.headerLogo,
        height: 32,
      ),
      surfaceTintColor: backgroundColor ?? AppResourses.appColors.whiteColor,
      backgroundColor: backgroundColor ?? AppResourses.appColors.whiteColor,
      centerTitle: true,
      actions: actions ?? [],
    );
  }
}
