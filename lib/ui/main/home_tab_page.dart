import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:line_icons/line_icons.dart';
import 'package:speakupp/api/auth/auth_call.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/user/user_item.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/ui/common/custom_app_bar.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final AuthCall authCall = GetIt.instance.get<AuthCall>();
  final UserItemProvider userItemProvider =
      GetIt.instance.get<UserItemProvider>();
  late UserItem? userItem;

  int _selectedTab = 0;
  final List<BottomNavigationBarItem> _baseItems = const [
    BottomNavigationBarItem(
        icon: Icon(
          LineIcons.list,
          size: 24,
        ),
        label: "Trending",
        tooltip: "Trending"),
    BottomNavigationBarItem(
        icon: Icon(
          LineIcons.voteYea,
          size: 24,
        ),
        tooltip: "Polls",
        label: "Polls"),
    BottomNavigationBarItem(
        icon: Icon(
          LineIcons.search,
          size: 24,
        ),
        tooltip: "Search",
        label: "Search"),
    BottomNavigationBarItem(
        icon: Icon(
          LineIcons.userAlt,
          size: 24,
        ),
        tooltip: "Profile",
        label: "Profile"),
  ];

  final List<Widget> _pages = [
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void initState() {
    userItem = null;
    super.initState();
    userItemProvider.list().then((value) {
      setState(() {
        userItem = value.first;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
  }

  void _uiReady(BuildContext buildContext) {}

  List<Widget> actions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.mainBar(
            actions: actions,
            backgroundColor: AppResourses.appColors.primaryColor),
        backgroundColor: AppResourses.appColors.background,
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppResourses.appColors.grayColor.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: BottomNavigationBar(
              backgroundColor: AppResourses.appColors.whiteColor,
              currentIndex: _selectedTab,
              type: BottomNavigationBarType.fixed,
              onTap: (index) => _changeTab(index),
              selectedItemColor: AppResourses.appColors.primaryColor,
              unselectedItemColor: AppResourses.appColors.tabIconColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedLabelStyle: AppResourses.appTextStyles.textStyle(14,
                  fontColor: AppResourses.appColors.primaryColor),
              unselectedLabelStyle: AppResourses.appTextStyles.textStyle(14),
              items: _baseItems,
            )),
        body: _pages[_selectedTab]);
  }
}
