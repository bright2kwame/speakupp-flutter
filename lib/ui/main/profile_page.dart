import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:line_icons/line_icons.dart';
import 'package:speakupp/common/app_navigate.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/user/user_item.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/persistence/shared_preference_module.dart';
import 'package:speakupp/ui/common/app_popup_dialog.dart';
import 'package:speakupp/ui/onboard/splash_screen_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserItemProvider userItemProvider =
      GetIt.instance.get<UserItemProvider>();
  late UserItem? userItem;
  final SharedPreferenceModule preferenceModule =
      GetIt.instance.get<SharedPreferenceModule>();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return userItem == null ? Container() : _mainView();
  }

  Widget _mainView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _profileView(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Settings",
              style: AppResourses.appTextStyles.textStyle(20),
            ),
          ),
          _profileItem("Personal information", LineIcons.userAlt, onTap: () {
            _gotoProfilePage();
          }),
          _profileItem("My Bookings", LineIcons.bookmark, onTap: () {}),
          _profileItem("Transactions", LineIcons.wallet, onTap: () {}),
          _profileItem("Investments", LineIcons.thumbsUpAlt),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Support",
              style: AppResourses.appTextStyles.textStyle(20),
            ),
          ),
          _profileItem("Visit the help center", LineIcons.link),
          _profileItem("How Hanfie works", LineIcons.wiredNetwork),
          _profileItem("Give feedback", LineIcons.heart),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Legal",
              style: AppResourses.appTextStyles.textStyle(20),
            ),
          ),
          _profileItem("Terms of service", LineIcons.trademark),
          _profileItem("Privacy policy", LineIcons.userSecret),
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            child: TextButton(
                onPressed: _logoutAccount,
                child: Text(
                  "Log out",
                  style: AppResourses.appTextStyles.textStyle(16,
                      fontColor: AppResourses.appColors.primaryColor),
                )),
          )
        ],
      ),
    );
  }

  //logout out of acccount
  void _logoutAccount() {
    AppPopupDialog(buildContext: context).presentDailog(
        "You may have to provide your email and password next time you return to login into HANFIE.",
        title: "Log out of SpeakUpp", onCompleted: () {
      preferenceModule.saveUserData("");
      userItemProvider.deleteAll().then((value) {
        AppNavigate(context).navigateAndDismissAll(const SplashScreenPage(
          users: [],
        ));
      });
    });
  }

  Widget _profileSubItem(String title, String subTitle, IconData iconData,
      {Function? onTap}) {
    return Column(
      children: [
        ListTile(
          onTap: onTap != null ? onTap() : null,
          leading: Icon(
            iconData,
            color: Colors.black,
          ),
          title: Text(
            title,
            style: AppResourses.appTextStyles.textStyle(12),
          ),
          subtitle: Text(
            subTitle,
            style: AppResourses.appTextStyles.textStyle(16),
          ),
          trailing: const Icon(
            Icons.arrow_right,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 12, right: 12),
          child: Divider(
            height: 2,
            color: Colors.grey.withAlpha(100),
          ),
        )
      ],
    );
  }

  Widget _profileItem(String title, IconData iconData, {Function? onTap}) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            onTap != null ? onTap() : null;
          },
          leading: Icon(
            iconData,
            color: Colors.black,
          ),
          title: Text(
            title,
            style: AppResourses.appTextStyles.textStyle(16),
          ),
          trailing: const Icon(
            Icons.arrow_right,
            color: Colors.black,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2, left: 12, right: 12),
          child: Divider(
            height: 2,
            color: Colors.grey.withAlpha(100),
          ),
        )
      ],
    );
  }

  void _gotoProfilePage() {
    AppNavigate(context).navigateWithPush(Container());
  }

  Widget _profileView() {
    return ListTile(
      onTap: _gotoProfilePage,
      leading: ClipOval(
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(AppResourses.appImages.baseGradient),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: ClipOval(
              child: userItem != null
                  ? Image.network(userItem!.avatar!)
                  : Image.asset(AppResourses.appImages.userAvatar),
            ),
          ),
        ),
      ),
      title: Text(
          userItem != null
              ? "${userItem!.firstName} ${userItem!.lastName}"
              : "",
          style: AppResourses.appTextStyles.textStyle(16)),
    );
  }
}
