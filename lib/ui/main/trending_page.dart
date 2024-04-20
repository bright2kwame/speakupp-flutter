import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:speakupp/api/auth/auth_call.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/ui/common/app_progress_indicator.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({super.key});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  bool _loading = false;
  final AuthCall authCall = GetIt.instance.get<AuthCall>();
  final UserItemProvider userItemProvider =
      GetIt.instance.get<UserItemProvider>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
  }

  void _uiReady(BuildContext buildContext) {
    Map<String, dynamic> dataParams = {};
    var request = ApiRequest(
        url: AppResourses.appStrings.trendingPolls, data: dataParams);
    _fetchData(request);
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }

  Widget _mainView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [AppProgressIndicator().inderminateProgress(_loading)],
      ),
    );
  }

  void _fetchData(ApiRequest request) {
    setState(() {
      _loading = true;
    });
    authCall
        .signIn(request)
        .whenComplete(() {
          setState(() {
            _loading = false;
          });
        })
        .then((value) {})
        .onError((error, stackTrace) {});
  }
}
