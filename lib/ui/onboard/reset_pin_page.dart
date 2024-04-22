import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_toast_message/simple_toast.dart';
import 'package:speakupp/api/auth/auth_call.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/common/detail_item.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/persistence/shared_preference_module.dart';
import 'package:speakupp/ui/common/app_fullscreen_progree_view.dart';
import 'package:speakupp/ui/common/app_input_decorator.dart';
import 'package:speakupp/ui/common/app_popup_dialog.dart';
import 'package:speakupp/ui/common/custom_app_bar.dart';
import 'package:speakupp/ui/common/primary_outline.dart';
import 'package:speakupp/ui/common/size_config.dart';

class ResetPinPage extends StatefulWidget {
  final String phoneNumber;
  const ResetPinPage({super.key, required this.phoneNumber});

  @override
  State<ResetPinPage> createState() => _ResetPinPageState();
}

class _ResetPinPageState extends State<ResetPinPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  final TextEditingController _uniqueCodeController = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;
  final AuthCall authCall = GetIt.instance.get<AuthCall>();
  final UserItemProvider userItemProvider =
      GetIt.instance.get<UserItemProvider>();
  final SharedPreferenceModule preferenceModule =
      GetIt.instance.get<SharedPreferenceModule>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
  }

  void _uiReady(BuildContext buildContext) {
    _initPinResetCode();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppResourses.appDecoration.gradientBoxDecoration,
      child: Scaffold(
          appBar: CustomAppBar.onBoardBar(
              closingAction: () {
                Navigator.of(context).pop();
              },
              backgroundColor: Colors.transparent),
          backgroundColor: Colors.transparent,
          body: _loading
              ? const AppFullscreenProgressView(message: "")
              : _mainView()),
    );
  }

  Widget _mainView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 64,
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            child: Image.asset(AppResourses.appImages.headerLogo),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: 'Hello there,\n',
                style: AppResourses.appTextStyles
                    .textStyle(16, fontColor: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                      text: "Reset PIN.",
                      style: AppResourses.appTextStyles.textStyle(
                        14,
                        weight: FontWeight.normal,
                        fontColor:
                            AppResourses.appColors.whiteColor.withAlpha(100),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 80,
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "OTP\nCODE",
                  style: AppResourses.appTextStyles.textStyle(14,
                      weight: FontWeight.normal,
                      fontColor: Colors.white.withAlpha(100)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _uniqueCodeController,
                    maxLength: 6,
                    style: AppResourses.appTextStyles
                        .textStyle(16, fontColor: Colors.white),
                    decoration:
                        AppInputDecorator.outlinedDecoration("Unique Code"),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: Colors.white.withAlpha(100),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 80,
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "4 DIGIT\nPIN",
                  style: AppResourses.appTextStyles.textStyle(14,
                      weight: FontWeight.normal,
                      fontColor: Colors.white.withAlpha(100)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _passwordController,
                    maxLength: 4,
                    obscureText: !_showPassword,
                    style: AppResourses.appTextStyles
                        .textStyle(16, fontColor: Colors.white),
                    decoration: AppInputDecorator.passwordInputDecoration(
                        "4 Digit PIN", () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    }, _showPassword),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: Colors.white.withAlpha(100),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 80,
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "PIN\nCONFIRM",
                  style: AppResourses.appTextStyles.textStyle(14,
                      weight: FontWeight.normal,
                      fontColor: Colors.white.withAlpha(100)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _passwordAgainController,
                    maxLength: 4,
                    obscureText: !_showPassword,
                    style: AppResourses.appTextStyles
                        .textStyle(16, fontColor: Colors.white),
                    decoration: AppInputDecorator.passwordInputDecoration(
                        "Confirm PIN", () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    }, _showPassword),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 1,
            color: Colors.white.withAlpha(100),
          ),
          const SizedBox(
            height: 64,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: PrimaryOutlineButton(
              text: "Reset PIN",
              onClick: _resetPassword,
              size: Size(SizeConfig(context).screenW! - 32, 50),
            ),
          ),
        ],
      ),
    );
  }

  void _initPinResetCode() {
    Map<String, dynamic> data = {
      "phone_number": widget.phoneNumber,
    };
    var request =
        ApiRequest(url: AppResourses.appStrings.initResetUrl, data: data);
    setState(() {
      _loading = true;
    });
    authCall.initResetPassword(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      AppPopupDialog(buildContext: context).presentDailog(value.result!);
    }).onError((error, stackTrace) {
      AppPopupDialog(buildContext: context).presentDailog(error.toString());
    });
  }

  void _resetPassword() {
    String pin = _passwordController.text.trim();
    String pinAgain = _passwordAgainController.text.trim();
    String uniqueCode = _uniqueCodeController.text.trim();

    if (pin.isEmpty || pinAgain.isEmpty || uniqueCode.isEmpty) {
      SimpleToast.showErrorToast(
          context, "SpeakUpp", "Provide all required fields and proceed");
      return;
    }
    Map<String, dynamic> data = {
      "phone_number": widget.phoneNumber,
      "pin": pin,
      "code": uniqueCode,
    };
    var request =
        ApiRequest(url: AppResourses.appStrings.confirmResetUrl, data: data);
    setState(() {
      _loading = true;
    });
    authCall.resetPassword(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      progressToVerify(value);
    }).onError((error, stackTrace) {
      AppPopupDialog(buildContext: context).presentDailog(error.toString());
    });
  }

  Future<void> progressToVerify(DetailItem userItem) async {
    SimpleToast.showSuccessToast(
        context, "SpeakUpp", "Pin reset successful, proceed to login");
    Navigator.pop(context);
  }
}
