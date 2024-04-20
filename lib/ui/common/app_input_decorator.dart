import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';

class AppInputDecorator {
  static TextStyle textStyle = GoogleFonts.nunito(
      color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16);

  static TextStyle helperTextStyle = GoogleFonts.nunito(
      color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16);

  static EdgeInsets contentPadding = const EdgeInsets.all(12.0);

  static InputDecoration outlinedDecoration(String hint,
      {EdgeInsets? contentPadding = const EdgeInsets.all(12.0)}) {
    return InputDecoration(
      hintStyle: textStyle,
      labelText: hint,
      labelStyle: helperTextStyle,
      helperStyle: helperTextStyle,
      contentPadding: contentPadding,
      counterText: "",
      alignLabelWithHint: true,
      filled: true,
      fillColor: Colors.transparent,
      focusedBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.transparent, width: 0.0),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
      border: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
    );
  }

  static InputDecoration pickerInputDecoration(String hint, Function actionDone,
      {IconData? pickerIcon}) {
    return InputDecoration(
      contentPadding: contentPadding,
      labelStyle: helperTextStyle,
      helperStyle: helperTextStyle,
      counterText: "",
      alignLabelWithHint: true,
      suffixIcon: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () => {actionDone()},
          child: Icon(
            pickerIcon ?? LineIcons.businessTime,
            size: 16,
          ),
        ),
      ),
      hintStyle: textStyle,
      labelText: hint,
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
      ),
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
      ),
    );
  }

  static InputDecoration searchInputDecoration(
      String hint, Function actionDone) {
    return InputDecoration(
      contentPadding: contentPadding,
      suffixIcon: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () {
            actionDone();
          },
          child: const Icon(
            LineIcons.search,
            size: 16,
          ),
        ),
      ),
      counterText: "",
      alignLabelWithHint: true,
      hintStyle: textStyle,
      labelText: hint,
      labelStyle: helperTextStyle,
      helperStyle: helperTextStyle,
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
        color: Colors.white,
        width: 0.0,
      )),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.0,
        ),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0.0,
        ),
      ),
    );
  }

  static InputDecoration passwordInputDecoration(
      String hint, Function toggle, bool showPassword) {
    return InputDecoration(
      labelStyle: helperTextStyle,
      helperStyle: helperTextStyle,
      alignLabelWithHint: true,
      counterText: "",
      contentPadding: contentPadding,
      suffixIcon: GestureDetector(
        onTap: () => {toggle()},
        child: Icon(
          showPassword ? LineIcons.eyeSlash : LineIcons.eye,
          color: Colors.white,
        ),
      ),
      hintStyle: textStyle,
      labelText: hint,
      focusedBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.transparent, width: 0.0),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
      border: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
    );
  }
}
