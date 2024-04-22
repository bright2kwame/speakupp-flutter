import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:speakupp/api/polls/poll_call.dart';
import 'package:speakupp/common/app_enums.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/poll/poll_item.dart';
import 'package:speakupp/ui/common/app_progress_indicator.dart';
import 'package:speakupp/ui/common/custom_app_bar.dart';
import 'package:speakupp/ui/polls/poll_item_view.dart';

class CorporateDetailPage extends StatefulWidget {
  final String id;
  const CorporateDetailPage({super.key, required this.id});

  @override
  State<CorporateDetailPage> createState() => _CorporateDetailPageState();
}

class _CorporateDetailPageState extends State<CorporateDetailPage> {
  bool _loading = false;
  final PollCall pollCall = GetIt.instance.get<PollCall>();
  List<PollItem> items = [];
  String nextUrl = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
  }

  void _uiReady(BuildContext buildContext) {
    items.clear();
    Map<String, dynamic> dataParams = {};
    var request = ApiRequest(
        url: AppResourses.appStrings.getCoporatePollsUrl(widget.id),
        data: dataParams);
    _fetchData(request);
  }

  void _fetchData(ApiRequest request) {
    setState(() {
      _loading = true;
    });
    pollCall.allPolls(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      setState(() {
        items.addAll(value.items);
        nextUrl = value.nextUrl ?? "";
      });
    }).onError((error, stackTrace) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainView(),
      appBar: CustomAppBar.subBar(
          leadingAction: () {
            Navigator.of(context).pop();
          },
          title: "Polls",
          textColor: Colors.white,
          backgroundColor: AppResourses.appColors.primaryColor),
      backgroundColor: AppResourses.appColors.background,
    );
  }

  Widget _mainView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppProgressIndicator().inderminateProgress(_loading,
              color: AppResourses.appColors.primaryColor),
          _coporatePollsView()
        ],
      ),
    );
  }

  Widget _coporatePollsView() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int position) {
          PollItem pollItem = items[position];
          return PollItemView(buildContext: context)
              .single(pollItem, (PollAction action) {});
        },
        separatorBuilder: (BuildContext context, int position) {
          return const SizedBox(
            height: 8,
          );
        },
        itemCount: items.length);
  }
}
