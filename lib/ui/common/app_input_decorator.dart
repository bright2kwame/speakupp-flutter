import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:speakupp/common/app_resourses.dart';

class AppInputDecorator {
  static TextStyle textStyle = GoogleFonts.nunito(
      color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16);

  static TextStyle helperTextStyle = GoogleFonts.nunito(
      color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16);

  static TextStyle darkHelperTextStyle = GoogleFonts.nunito(
      color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16);

  static EdgeInsets contentPadding = const EdgeInsets.all(12.0);

  static InputDecoration underlineDecoration(String hint,
      {EdgeInsets? contentPadding = const EdgeInsets.all(12.0),
      TextStyle? textStyle}) {
    return InputDecoration(
      hintStyle: textStyle,
      labelText: hint,
      labelStyle: textStyle ?? helperTextStyle,
      helperStyle: textStyle ?? helperTextStyle,
      contentPadding: contentPadding,
      floatingLabelAlignment: FloatingLabelAlignment.center,
      counterText: "",
      filled: true,
      fillColor: Colors.transparent,
      focusedBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      border: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
    );
  }

  static InputDecoration outlinedDecoration(String hint,
      {EdgeInsets? contentPadding = const EdgeInsets.all(12.0),
      TextStyle? textStyle}) {
    return InputDecoration(
      hintStyle: textStyle,
      labelText: hint,
      labelStyle: textStyle ?? helperTextStyle,
      helperStyle: textStyle ?? helperTextStyle,
      contentPadding: contentPadding,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      counterText: "",
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

  static InputDecoration commentInputDecoration(
    String hint,
    Function actionDone,
  ) {
    return InputDecoration(
      contentPadding: contentPadding,
      suffixIcon: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: IconButton(
          onPressed: () {
            actionDone();
          },
          icon: const Icon(
            Icons.send,
            size: 30,
            color: Colors.grey,
          ),
        ),
      ),
      prefixIcon: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: const Icon(
          LineIcons.comment,
          size: 16,
          color: Colors.grey,
        ),
      ),
      counterText: "",
      alignLabelWithHint: true,
      hintStyle: darkHelperTextStyle,
      labelText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelStyle: darkHelperTextStyle,
      helperStyle: darkHelperTextStyle,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.grey,
        width: 0.5,
      )),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.6,
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.2,
        ),
      ),
    );
  }

  static InputDecoration searchInputDecoration(String hint, Function actionDone,
      {IconData? trailingIcon, IconData? leadingIcon}) {
    return InputDecoration(
      contentPadding: contentPadding,
      suffixIcon: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: IconButton(
          onPressed: () {
            actionDone();
          },
          icon: Icon(
            trailingIcon ?? Icons.close,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
      prefixIcon: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Icon(
          leadingIcon ?? LineIcons.search,
          size: 16,
          color: Colors.white,
        ),
      ),
      counterText: "",
      alignLabelWithHint: true,
      hintStyle: textStyle,
      labelText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelStyle: helperTextStyle,
      helperStyle: helperTextStyle,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
        color: Colors.white,
        width: 0.5,
      )),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.6,
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.2,
        ),
      ),
    );
  }

  static InputDecoration linePasswordInputDecoration(
      String hint, Function toggle, bool showPassword) {
    return InputDecoration(
      labelStyle: AppResourses.appTextStyles.textStyle(16),
      helperStyle: AppResourses.appTextStyles.textStyle(16),
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
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.black, width: 1.5),
      ),
      border: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(color: Colors.black, width: 1),
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
      floatingLabelBehavior: FloatingLabelBehavior.never,
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
