import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speakupp/common/app_resourses.dart';

class AppTheme {
  late BuildContext context;

  AppTheme(BuildContext buildContext) {
    context = buildContext;
  }

  ThemeData buildAppTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: AppResourses.appColors.primaryColor,
        primaryColorDark: AppResourses.appColors.primaryColorDark,
        primaryColorLight: AppResourses.appColors.primaryColorLight,
        buttonTheme: base.buttonTheme.copyWith(
          buttonColor: AppResourses.appColors.secondaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
        cardTheme: base.cardTheme.copyWith(
          color: AppResourses.appColors.background,
          elevation: 0.5,
          shadowColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
        ),
        scaffoldBackgroundColor: AppResourses.appColors.whiteColor,
        cardColor: AppResourses.appColors.background,
        primaryIconTheme: base.iconTheme.copyWith(color: Colors.grey),
        dialogTheme: base.dialogTheme.copyWith(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            )),
        dialogBackgroundColor: Colors.white,
        listTileTheme: base.listTileTheme.copyWith(tileColor: Colors.white),
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ));
  }
}
