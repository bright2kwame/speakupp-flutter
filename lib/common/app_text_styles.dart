import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  TextStyle textStyle(double fontSize,
      {Color? fontColor = Colors.black,
      FontWeight? weight = FontWeight.normal,
      bool? underline = false}) {
    TextStyle textStyle = GoogleFonts.roboto(
        fontSize: fontSize,
        color: fontColor,
        fontWeight: weight,
        decoration:
            underline! ? TextDecoration.underline : TextDecoration.none);

    return textStyle;
  }

  TextStyle buttonTextStyle(double fontSize,
      {Color? fontColor = Colors.black}) {
    TextStyle textStyle = GoogleFonts.roboto(
        fontSize: fontSize, color: fontColor, fontWeight: FontWeight.bold);
    return textStyle;
  }
}
