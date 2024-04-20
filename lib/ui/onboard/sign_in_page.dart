import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:simple_toast_message/simple_toast.dart';
import 'package:speakupp/api/api_exception.dart';
import 'package:speakupp/api/auth/auth_call.dart';
import 'package:speakupp/common/app_navigate.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/common/app_utility.dart';
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
import 'package:speakupp/ui/main/home_tab_page.dart';
import 'package:speakupp/ui/onboard/reset_pin_page.dart';

class SignInScreenPage extends StatefulWidget {
  const SignInScreenPage({super.key});

  @override
  State<SignInScreenPage> createState() => _SignInScreenPageState();
}

class _SignInScreenPageState extends State<SignInScreenPage> {
  bool _showPassword = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _phoneNumber = "";
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
            child: Text(
              "Hello again,\nWelcome back.",
              textAlign: TextAlign.center,
              style: AppResourses.appTextStyles.textStyle(20,
                  weight: FontWeight.w400, fontColor: Colors.white),
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
                  "PHONE\nNUMBER",
                  style: AppResourses.appTextStyles.textStyle(14,
                      weight: FontWeight.normal,
                      fontColor: Colors.white.withAlpha(100)),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IntlPhoneField(
                    disableLengthCheck: true,
                    showDropdownIcon: false,
                    controller: _phoneController,
                    dropdownTextStyle: AppResourses.appTextStyles
                        .textStyle(16, fontColor: Colors.white),
                    style: AppResourses.appTextStyles
                        .textStyle(16, fontColor: Colors.white),
                    decoration: AppInputDecorator.outlinedDecoration(
                        "Phone Number",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0)),
                    initialCountryCode: 'GH',
                    onChanged: (phone) {
                      _phoneNumber = phone.completeNumber;
                    },
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
                    maxLength: 4,
                    autocorrect: false,
                    controller: _passwordController,
                    keyboardType: TextInputType.number,
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
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 8, top: 4),
            child: Row(
              children: [
                Expanded(child: Container()),
                TextButton(
                  onPressed: _startPasswordPage,
                  child: Text(
                    "Forgot PIN?",
                    textAlign: TextAlign.right,
                    style: AppResourses.appTextStyles
                        .textStyle(16, fontColor: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 64,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryOutlineButton(
                size: Size(SizeConfig(context).screenW! - 32, 50),
                text: "Log In",
                onClick: _startSigningIn),
          ),
          const SizedBox(
            height: 64,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: GestureDetector(
              onTap: _startTermsPage,
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text:
                      'By continuing you indicated that you have read and agree to the ',
                  style: AppResourses.appTextStyles.textStyle(
                    16,
                    fontColor: AppResourses.appColors.whiteColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Terms of Service',
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

  void _startSigningIn() {
    String password = _passwordController.text.trim();
    if (_phoneNumber.isEmpty || password.isEmpty) {
      SimpleToast.showErrorToast(
          context, "Sign In", "Enter phone number and pin to proceed");
      return;
    }
    _performLogin({
      "phone_number": _phoneNumber,
      "password": password,
    });
  }

  void _performLogin(Map<String, dynamic> data) {
    setState(() {
      _loading = true;
    });
    var request = ApiRequest(url: AppResourses.appStrings.loginUrl, data: data);
    authCall.signIn(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      _handleLogin(value);
    }).onError((error, stackTrace) {
      _handleSignInError(error as ApiException);
    });
  }

  void _handleSignInError(ApiException exception) {
    AppPopupDialog(buildContext: context)
        .presentDailog(exception.message.toString(), onCompleted: () {});
  }

  Future<void> _handleLogin(UserItem userItem) async {
    await userItemProvider.insert(userItem);
    preferenceModule.saveUserData(userItem.authToken!);
    // ignore: use_build_context_synchronously
    AppNavigate(context).navigateAndDismissAll(const HomeTabPage());
  }

  void _startTermsPage() {
    AppUtility.startlaunchUrl(Uri.parse(AppResourses.appStrings.privacyUrl));
  }

  void _startPasswordPage() {
    if (_phoneNumber.isEmpty) {
      SimpleToast.showErrorToast(context, "Sign In", "Enter phone number");
      return;
    }
    AppNavigate(context)
        .navigateWithPush(ResetPinPage(phoneNumber: _phoneNumber));
  }
}
