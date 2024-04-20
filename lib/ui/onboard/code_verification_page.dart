import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_toast_message/simple_toast.dart';
import 'package:speakupp/api/auth/auth_call.dart';
import 'package:speakupp/common/app_navigate.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/user/user_item.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/persistence/shared_preference_module.dart';
import 'package:speakupp/ui/common/app_fullscreen_progree_view.dart';
import 'package:speakupp/ui/common/app_input_decorator.dart';
import 'package:speakupp/ui/common/app_popup_dialog.dart';
import 'package:speakupp/ui/common/custom_app_bar.dart';
import 'package:speakupp/ui/common/primary_outline.dart';
import 'package:speakupp/ui/common/size_config.dart';

class CodeVerificationPage extends StatefulWidget {
  final String phoneNumber;
  const CodeVerificationPage({super.key, required this.phoneNumber});

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final TextEditingController _codeController = TextEditingController();
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

  void _uiReady(BuildContext buildContext) {}

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
                text: 'Enter the code sent to: ',
                style: AppResourses.appTextStyles
                    .textStyle(16, fontColor: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                      text: widget.phoneNumber,
                      style: AppResourses.appTextStyles.textStyle(
                        16,
                        weight: FontWeight.bold,
                        fontColor: AppResourses.appColors.whiteColor,
                      )),
                  TextSpan(
                      text:
                          "\n\nPlease enter the verification code you received from SpeakUpp to proceed.",
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: _codeController,
              textAlign: TextAlign.center,
              maxLength: 6,
              keyboardType: TextInputType.number,
              style: AppResourses.appTextStyles
                  .textStyle(16, fontColor: Colors.white),
              decoration:
                  AppInputDecorator.outlinedDecoration("Verification Code"),
            ),
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
              text: "Verify Account",
              onClick: verifyAccount,
              size: Size(SizeConfig(context).screenW! - 32, 50),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: GestureDetector(
              onTap: _resendCode,
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'Haven\'t received code ? ',
                  style: AppResourses.appTextStyles
                      .textStyle(16, fontColor: Colors.white),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Resend Code',
                        style: AppResourses.appTextStyles.textStyle(
                          16,
                          weight: FontWeight.bold,
                          fontColor: AppResourses.appColors.whiteColor,
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _resendCode() {
    Map<String, dynamic> data = {
      "phone_number": widget.phoneNumber,
    };
    var request = ApiRequest(url: "users/resend_otp/", data: data);
    setState(() {
      _loading = true;
    });
    authCall.resendCode(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      AppPopupDialog(buildContext: context).presentDailog(value.result!);
    }).onError((error, stackTrace) {
      AppPopupDialog(buildContext: context).presentDailog(error.toString());
    });
  }

  void verifyAccount() {
    String code = _codeController.text.trim();
    if (code.isEmpty) {
      SimpleToast.showErrorToast(
          context, "SpeakUpp", "Provide all required fields and proceed");
      return;
    }
    Map<String, dynamic> data = {
      "phone_number": widget.phoneNumber,
      "unique_code": code,
    };
    var request = ApiRequest(url: "users/validate_account/", data: data);
    setState(() {
      _loading = true;
    });
    authCall.verifyAccount(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      progressToVerify(value);
    }).onError((error, stackTrace) {
      AppPopupDialog(buildContext: context).presentDailog(error.toString());
    });
  }

  Future<void> progressToVerify(UserItem userItem) async {
    await userItemProvider.insert(userItem);
    preferenceModule.saveUserData(userItem.authToken!);
    // ignore: use_build_context_synchronously
    AppNavigate(context).navigateAndDismissAll(Container());
  }
}
