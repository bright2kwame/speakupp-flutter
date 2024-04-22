import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/ui/common/app_input_decorator.dart';
import 'package:speakupp/ui/common/primary_button.dart';
import 'package:speakupp/ui/common/size_config.dart';

class AppPopupDialog {
  BuildContext buildContext;
  AppPopupDialog({required this.buildContext});

  /*
   * @param 
   * present the dialog to the user with message without action
   * with param context
   */
  void presentDailog(String message,
      {String title = "SPEAKUPP",
      String action = "OK",
      String cancelAction = "CANCEL",
      Function? onCompleted,
      Function? onCancelled}) {
    showCupertinoDialog(
        context: buildContext,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: AppResourses.appTextStyles.textStyle(16),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                message,
                textAlign: TextAlign.center,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actionsOverflowButtonSpacing: 8.0,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onCompleted != null) {
                          onCompleted();
                        }
                      },
                      child: Text(
                        action,
                        style: GoogleFonts.roboto(),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onCancelled != null) {
                          onCancelled();
                        }
                      },
                      child: Text(
                        cancelAction,
                        style: GoogleFonts.roboto(color: Colors.grey),
                      ))
                ],
              )
            ],
          );
        });
  }

  Future<DateTime?> presentDatePicker(BuildContext context,
      {DateTime? initialDateTime, DateTime? lastDateTime}) async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          initialDateTime ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1910),
      lastDate: lastDateTime ?? DateTime(now.year, now.month, now.day),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                  primary: AppResourses.appColors.primaryColor),
              primaryColor: AppResourses.appColors.primaryColor,
              primaryColorDark: AppResourses.appColors.primaryColor,
              splashColor: AppResourses.appColors.primaryColor),
          child: child!,
        );
      },
    );
    return pickedDate;
  }

  Future<TimeOfDay?> presentTimePicker(BuildContext context) async {
    TimeOfDay? pickedDate = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                  primary: AppResourses.appColors.primaryColor),
              primaryColor: AppResourses.appColors.primaryColor,
              primaryColorDark: AppResourses.appColors.primaryColor,
              splashColor: AppResourses.appColors.primaryColor),
          child: child!,
        );
      },
    );
    return pickedDate;
  }

  void presentPasswordInputView({
    Function(String)? actionTaken,
  }) {
    TextEditingController pinEditingController = TextEditingController();
    TextEditingController confirmPinEditingController = TextEditingController();

    showModalBottomSheet(
      context: buildContext,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text(
                  "Update Profile",
                  style: AppResourses.appTextStyles.textStyle(16),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: TextField(
                  controller: pinEditingController,
                  maxLength: 4,
                  decoration: AppInputDecorator.linePasswordInputDecoration(
                      "4 Digit PIN", () {}, true),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: TextField(
                  controller: confirmPinEditingController,
                  maxLength: 4,
                  decoration: AppInputDecorator.linePasswordInputDecoration(
                      "Confirm 4 Digit PIN", () {}, true),
                ),
              ),
              const SizedBox(height: 16.0),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: PrimaryButton(
                      size: Size(SizeConfig(context).screenW! - 64, 50),
                      text: "Change PIN",
                      color: AppResourses.appColors.primaryColor,
                      onClick: () {
                        String pin = pinEditingController.text.trim();
                        String cPin = confirmPinEditingController.text.trim();
                        if (pin.isNotEmpty && cPin.isNotEmpty && pin == cPin) {
                          actionTaken!(pin);
                        }
                        Navigator.of(context).pop();
                      }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void presentProfileInputView({
    String? firstName = "",
    String? lastName = "",
    Function(String)? actionTaken,
  }) {
    TextEditingController firstNameEditingController = TextEditingController();
    firstNameEditingController.text = firstName ?? "";

    TextEditingController lastNameEditingController = TextEditingController();
    lastNameEditingController.text = lastName ?? "";

    showModalBottomSheet(
      context: buildContext,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text(
                  "Update Profile",
                  style: AppResourses.appTextStyles.textStyle(16),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                child: TextField(
                  controller: firstNameEditingController,
                  decoration:
                      AppInputDecorator.underlineDecoration(firstName ?? ""),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                child: TextField(
                  controller: lastNameEditingController,
                  decoration:
                      AppInputDecorator.underlineDecoration(lastName ?? ""),
                ),
              ),
              const SizedBox(height: 16.0),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: PrimaryButton(
                      size: Size(SizeConfig(context).screenW! - 64, 50),
                      text: "Save Changes",
                      color: AppResourses.appColors.primaryColor,
                      onClick: () {
                        String firstNameText =
                            firstNameEditingController.text.trim();
                        String lastNameText =
                            lastNameEditingController.text.trim();
                        String name = "$firstNameText@$lastNameText";
                        if (firstNameText.isNotEmpty &&
                            lastNameText.isNotEmpty) {
                          actionTaken!(name);
                        }
                        Navigator.of(context).pop();
                      }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void presentMessageView(
    BuildContext context,
    String title,
    String action, {
    String? message = "",
    Function()? actionTaken,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text(
                  title,
                  style: AppResourses.appTextStyles
                      .textStyle(16, weight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: AppResourses.appTextStyles.textStyle(16),
                ),
              ),
              const SizedBox(height: 32.0),
              SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  child: PrimaryButton(
                      size: Size(SizeConfig(context).screenW! - 64, 50),
                      text: action,
                      color: AppResourses.appColors.primaryColor,
                      onClick: () {
                        actionTaken!();
                        Navigator.of(context).pop();
                      }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
