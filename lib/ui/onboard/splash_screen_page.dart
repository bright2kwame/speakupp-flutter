import 'package:flutter/material.dart';
import 'package:speakupp/common/app_navigate.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/user/user_item.dart';
import 'package:speakupp/ui/main/home_tab_page.dart';
import 'package:speakupp/ui/onboard/walkthrough_page.dart';

class SplashScreenPage extends StatefulWidget {
  final List<UserItem> users;
  const SplashScreenPage({super.key, required this.users});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  double value = 0.1;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() => setState(() {
          value = _controller.value;
        }));
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
  }

  Future<void> _uiReady(BuildContext buildContext) async {
    await _controller.forward();
    // ignore: use_build_context_synchronously
    AppNavigate(buildContext)
        .navigateAndDismissAll(_desinationWidget(widget.users));
  }

  Widget _desinationWidget(List<UserItem> users) {
    if (users.isEmpty) {
      return const WalkthroughPage();
    }
    return const HomeTabPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppResourses.appColors.primaryColor,
        body: _mainView());
  }

  Widget _mainView() {
    return Container(
      decoration: AppResourses.appDecoration.gradientBoxDecoration,
      child: Center(
        child: Image.asset(
          AppResourses.appImages.mainLogo,
          height: 200,
          width: 300,
        ),
      ),
    );
  }
}
