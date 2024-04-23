import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:line_icons/line_icons.dart';
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
import 'package:speakupp/ui/common/app_popup_dialog.dart';
import 'package:speakupp/ui/common/app_progress_indicator.dart';
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
  final AuthCall authCall = GetIt.instance.get<AuthCall>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    userItem = null;
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
    return _mainView();
  }

  Widget _mainView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppProgressIndicator().inderminateProgress(_loading,
              color: AppResourses.appColors.primaryColor),
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
          _profileItem("Change PIN", LineIcons.cog, onTap: () {
            _gotoPinChangePage();
          }),
          _profileItem("Share SpeakUpp", LineIcons.shareSquare, onTap: () {
            AppUtility.startSharingContent(
                "I use SpeakUpp to cast vote and rate things. Join me here: https://www.speakupp.com/");
          }),
          _profileItem("Remove SpeakUpp Account", LineIcons.removeUser,
              onTap: () {
            _deleteAccount();
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Support",
              style: AppResourses.appTextStyles.textStyle(20),
            ),
          ),
          _profileItem("Visit the help center", LineIcons.link, onTap: () {
            AppUtility.startlaunchUrl(
                Uri.parse("https://www.speakupp.com/contact/"));
          }),
          _profileItem("Give feedback", LineIcons.heart, onTap: () {
            AppUtility.startlaunchUrl(
                Uri.parse("https://www.speakupp.com/contact/"));
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Legal",
              style: AppResourses.appTextStyles.textStyle(20),
            ),
          ),
          _profileItem("Terms of service", LineIcons.trademark, onTap: () {
            AppUtility.startlaunchUrl(
                Uri.parse(AppResourses.appStrings.privacyUrl));
          }),
          _profileItem("Privacy policy", LineIcons.userSecret, onTap: () {
            AppUtility.startlaunchUrl(
                Uri.parse(AppResourses.appStrings.privacyUrl));
          }),
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

  //delete the account
  void _deleteAccount() {
    AppPopupDialog(buildContext: context).presentDailog(
        "SpeakUpp Digital Services will suspend and remove your account from our system. This means you will not be able to cast vote for your favourite candidates anymore.",
        title: "Delete SpeakUpp Account", onCompleted: () {
      _deleteAccountRequst();
    });
  }

  //logout out of acccount
  void _logoutAccount() {
    AppPopupDialog(buildContext: context).presentDailog(
        "You may have to provide your phone number and pin next time you return to login into SpeakUpp.",
        title: "Log out of SpeakUpp", onCompleted: () {
      _clearAndNavigateHome();
    });
  }

  Widget _profileItem(String title, IconData iconData, {Function? onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
    AppPopupDialog(buildContext: context).presentProfileInputView(
        firstName: userItem?.firstName,
        lastName: userItem?.lastName,
        actionTaken: (String result) {
          _updateData(ApiRequest(
              url: AppResourses.appStrings.profileUrl,
              data: {
                "first_name": result.split("@")[0],
                "last_name": result.split("@")[1]
              }));
        });
  }

  void _gotoPinChangePage() {
    AppPopupDialog(buildContext: context).presentPasswordInputView(
        actionTaken: (String result) {
      _changePassword(ApiRequest(
          url: AppResourses.appStrings.completeResetUrl,
          data: {"phone_number": userItem?.phoneNumber, "password": result}));
    });
  }

  void _deleteAccountRequst() {
    ApiRequest request = ApiRequest(
        url: AppResourses.appStrings.getDeleteUserUrl(userItem!.id), data: {});
    setState(() {
      _loading = true;
    });
    authCall.deleteAccount(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      _clearAndNavigateHome();
    }).onError((error, stackTrace) {
      SimpleToast.showErrorToast(
          context, "SpeakUpp", (error as ApiException).message);
    });
  }

  void _clearAndNavigateHome() {
    preferenceModule.saveUserData("");
    userItemProvider.deleteAll().then((value) {
      AppNavigate(context).navigateAndDismissAll(const SplashScreenPage(
        users: [],
      ));
    });
  }

  void _changePassword(ApiRequest request) {
    setState(() {
      _loading = true;
    });
    authCall.changePassword(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      SimpleToast.showSuccessToast(
          context, "SpeakUpp", "PIN changed successfully");
    }).onError((error, stackTrace) {
      SimpleToast.showErrorToast(
          context, "SpeakUpp", (error as ApiException).message);
    });
  }

  void _updateData(ApiRequest request) {
    setState(() {
      _loading = true;
    });
    authCall.updateUser(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      setState(() {
        userItem = value;
      });
      SimpleToast.showSuccessToast(
          context, "SpeakUpp", "Profile update successfully");
    }).onError((error, stackTrace) {
      SimpleToast.showErrorToast(
          context, "SpeakUpp", (error as ApiException).message);
    });
  }

  Widget _profileView() {
    return ListTile(
      contentPadding: const EdgeInsets.all(12),
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
                child: (userItem == null)
                    ? Image.asset(
                        AppResourses.appImages.userAvatar,
                        height: 50,
                        width: 50,
                      )
                    : Center(
                        child: ClipOval(
                          child: Text(
                            userItem!.firstName!.characters.first,
                            style: AppResourses.appTextStyles
                                .textStyle(24, fontColor: Colors.white),
                          ),
                        ),
                      )),
          ),
        ),
      ),
      title: Text(
          userItem != null
              ? "${userItem!.firstName} ${userItem!.lastName}"
              : "N/A",
          style: AppResourses.appTextStyles.textStyle(16)),
    );
  }
}
