import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
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
import 'package:speakupp/ui/onboard/code_verification_page.dart';

class SignUpScreenPage extends StatefulWidget {
  const SignUpScreenPage({super.key});

  @override
  State<SignUpScreenPage> createState() => _SignUpScreenPageState();
}

class _SignUpScreenPageState extends State<SignUpScreenPage> {
  bool _showPassword = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

  bool _loading = false;
  String _phoneNumber = "";
  final AuthCall authCall = GetIt.instance.get<AuthCall>();
  final UserItemProvider userItemProvider =
      GetIt.instance.get<UserItemProvider>();
  final SharedPreferenceModule preferenceModule =
      GetIt.instance.get<SharedPreferenceModule>();
  List gender = ["Male", "Female"];
  String genderSelect = "Male";

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
              "Hello!\nSign up to get started.",
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
                  "FULL\nNAME",
                  style: AppResourses.appTextStyles.textStyle(14,
                      weight: FontWeight.normal,
                      fontColor: Colors.white.withAlpha(100)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _fullNameController,
                    style: AppResourses.appTextStyles
                        .textStyle(16, fontColor: Colors.white),
                    decoration:
                        AppInputDecorator.outlinedDecoration("Full Name"),
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
                    keyboardType: TextInputType.number,
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
                  "GENDER",
                  style: AppResourses.appTextStyles.textStyle(14,
                      weight: FontWeight.normal,
                      fontColor: Colors.white.withAlpha(100)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Radio(
                        activeColor: Theme.of(context).primaryColor,
                        value: gender[0],
                        groupValue: genderSelect,
                        onChanged: (value) {
                          setState(() {
                            genderSelect = value;
                          });
                        },
                      ),
                      Text(
                        gender[0],
                        style: AppResourses.appTextStyles
                            .textStyle(16, fontColor: Colors.white),
                      ),
                      Radio(
                        activeColor: Theme.of(context).primaryColor,
                        value: gender[1],
                        groupValue: genderSelect,
                        onChanged: (value) {
                          setState(() {
                            genderSelect = value;
                          });
                        },
                      ),
                      Text(
                        gender[1],
                        style: AppResourses.appTextStyles
                            .textStyle(16, fontColor: Colors.white),
                      )
                    ],
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
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    keyboardType: TextInputType.number,
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
                    keyboardType: TextInputType.number,
                    obscureText: !_showPassword,
                    style: AppResourses.appTextStyles
                        .textStyle(16, fontColor: Colors.white),
                    decoration: AppInputDecorator.passwordInputDecoration(
                        "CONFIRM 4 Digit PIN", () {
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PrimaryOutlineButton(
                size: Size(SizeConfig(context).screenW! - 32, 50),
                text: "Sing Up",
                onClick: _startSignUp),
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

  void _startSignUp() {
    String name = _fullNameController.text.trim();
    String pin = _passwordController.text.trim();
    String pinAgain = _passwordAgainController.text.trim();

    if (name.isEmpty ||
        pin.isEmpty ||
        _phoneNumber.isEmpty ||
        genderSelect.isEmpty) {
      SimpleToast.showErrorToast(
          context, "Sign Up", "Enter all fields and proceed");
      return;
    }

    if (pin.isEmpty != pinAgain.isEmpty) {
      SimpleToast.showErrorToast(context, "Sign Up", "Pin does not match");
      return;
    }

    _registerAccount({
      "first_name": name.split(" ")[0],
      "last_name": name.split(" ")[1],
      "phone_number": _phoneNumber,
      "username": name,
      "birthday": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "gender": genderSelect.characters.first.toString().toUpperCase(),
      "password": pin,
    });
  }

  void _registerAccount(Map<String, dynamic> data) {
    setState(() {
      _loading = true;
    });
    var request =
        ApiRequest(url: AppResourses.appStrings.signUpUrl, data: data);
    authCall.signUp(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      _handleAccount(value);
    }).onError((error, stackTrace) {
      _handleSignInError(error as ApiException);
    });
  }

  void _handleSignInError(ApiException exception) {
    AppPopupDialog(buildContext: context)
        .presentDailog(exception.message.toString(), onCompleted: () {
      if (exception.code == 102) {}
    });
  }

  Future<void> _handleAccount(UserItem userItem) async {
    await userItemProvider.insert(userItem);
    preferenceModule.saveUserData(userItem.authToken!);

    _startVerificationPage(userItem.phoneNumber ?? "");
  }

  void _startTermsPage() {
    AppUtility.startlaunchUrl(Uri.parse(AppResourses.appStrings.privacyUrl));
  }

  void _startVerificationPage(String phone) {
    AppNavigate(context)
        .navigateWithPush(CodeVerificationPage(phoneNumber: phone));
  }
}
