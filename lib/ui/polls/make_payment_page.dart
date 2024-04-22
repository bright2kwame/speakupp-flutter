import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/common/app_utility.dart';
import 'package:speakupp/model/user/user_item.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/ui/common/app_popup_dialog.dart';
import 'package:speakupp/ui/common/custom_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MakePaymentPage extends StatefulWidget {
  final String url;
  const MakePaymentPage({super.key, required this.url});
  @override
  State<MakePaymentPage> createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage> {
  final UserItemProvider userItemProvider =
      GetIt.instance.get<UserItemProvider>();
  late UserItem? userItem;

  @override
  void initState() {
    userItem = null;
    userItemProvider.list().then((value) {
      setState(() {
        userItem = value[0];
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
    super.initState();
  }

  void _uiReady(BuildContext buildContext) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.leaderClosingBar("Make Payment",
          backgroundColor: AppResourses.appColors.whiteColor,
          closingAction: () {
        _promtForDismis();
      }),
      backgroundColor: AppResourses.appColors.whiteColor,
      body: SafeArea(
        child: _paymentView(),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _promtForDismis() {
    AppPopupDialog(buildContext: context).presentDailog(
        "If you wish to cancel this payment then proceed to click the cancel button else click on and then click 'Back to Website' when you complete making payment",
        onCompleted: () {}, onCancelled: () {
      Navigator.of(context).pop();
    });
  }

  Widget _paymentView() {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      backgroundColor: Colors.white,
      onWebViewCreated: (WebViewController webViewController) {},
      navigationDelegate: (NavigationRequest request) {
        return NavigationDecision.navigate;
      },
      onPageFinished: (String url) {
        if (url.startsWith(AppResourses.appStrings.paymentCallback)) {
          Navigator.of(context).pop(true);
        }
        AppUtility.printLogMessage(url, "PAGE_LOADING");
      },
      gestureNavigationEnabled: true,
    );
  }
}
