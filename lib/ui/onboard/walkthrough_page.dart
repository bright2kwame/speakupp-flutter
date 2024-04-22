import 'package:flutter/material.dart';
import 'package:speakupp/common/app_navigate.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/ui/common/primary_outline.dart';
import 'package:speakupp/ui/common/size_config.dart';
import 'package:speakupp/ui/onboard/sign_in_page.dart';
import 'package:speakupp/ui/onboard/sign_up_page.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  int _currentPage = 0;
  late PageController _controller;

  final List<String> _content = const [
    "Discover and Rate anything you want.",
    "Our mission is to give people this platform to connect and be heard.",
    "Extensive and accurate guide to events and activities."
  ];

  final List<String> _images = [
    AppResourses.appImages.onboardOne,
    AppResourses.appImages.onboardTwo,
    AppResourses.appImages.onboardThree,
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
  }

  void _uiReady(BuildContext buildContext) {}

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: _currentPage == index
              ? const Color(0xFFFFFFFF)
              : const Color(0xFFFFFFFF)),
      margin: const EdgeInsets.only(right: 5),
      height: _currentPage == index ? 20 : 10,
      curve: Curves.easeIn,
      width: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(AppResourses.appImages.baseGradient),
          fit: BoxFit.cover,
        )),
        child: SafeArea(child: _mainView()));
  }

  Widget _mainView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
          child: Image.asset(AppResourses.appImages.headerLogo),
        ),
        Expanded(
          child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _controller,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: _content.length,
              itemBuilder: (context, i) {
                return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Image.asset(_images[_currentPage]),
                          ),
                        ),
                        Text(
                          _content[_currentPage],
                          textAlign: TextAlign.center,
                          style: AppResourses.appTextStyles.textStyle(24,
                              fontColor: Colors.white,
                              weight: FontWeight.normal),
                        )
                      ],
                    ));
              }),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _content.length,
              (int index) => _buildDots(
                index: index,
              ),
            ),
          ),
        ),
        PrimaryOutlineButton(
          text: "Sign Up",
          onClick: _startSignUpPage,
          size: Size((SizeConfig(context).screenW!) - 32, 50),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: GestureDetector(
            onTap: _startSignInPage,
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: 'Already have an account? ',
                style: AppResourses.appTextStyles.textStyle(
                  16,
                  fontColor: AppResourses.appColors.whiteColor,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Log in',
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
    );
  }

  void _startSignInPage() {
    AppNavigate(context).navigateWithPush(const SignInScreenPage());
  }

  void _startSignUpPage() {
    AppNavigate(context).navigateWithPush(const SignUpScreenPage());
  }
}
