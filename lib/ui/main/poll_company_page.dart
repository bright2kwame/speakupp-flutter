import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:speakupp/api/polls/poll_call.dart';
import 'package:speakupp/common/app_enums.dart';
import 'package:speakupp/common/app_navigate.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/poll/poll_company_item.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/ui/common/app_progress_indicator.dart';
import 'package:speakupp/ui/polls/corporate_detail_page.dart';
import 'package:speakupp/ui/polls/poll_item_view.dart';

class PollCompanyPage extends StatefulWidget {
  const PollCompanyPage({super.key});

  @override
  State<PollCompanyPage> createState() => _PollCompanyPageState();
}

class _PollCompanyPageState extends State<PollCompanyPage> {
  bool _loading = false;
  final PollCall pollCall = GetIt.instance.get<PollCall>();
  final UserItemProvider userItemProvider =
      GetIt.instance.get<UserItemProvider>();
  List<PollCompanyItem> items = [];
  String nextUrl = "";
  List<String> loadedPages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
  }

  void _uiReady(BuildContext buildContext) {
    Map<String, dynamic> dataParams = {};
    var request = ApiRequest(
        url: AppResourses.appStrings.corporatesUrl, data: dataParams);
    _fetchData(request, true);
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
        children: [
          AppProgressIndicator().inderminateProgress(_loading,
              color: AppResourses.appColors.primaryColor),
          _companyPollsView()
        ],
      ),
    );
  }

  Widget _companyPollsView() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int position) {
          if (position == items.length - 5 && !loadedPages.contains(nextUrl)) {
            _fetchData(ApiRequest(url: nextUrl, data: {}), false);
          }
          PollCompanyItem pollItem = items[position];
          return PollItemView(buildContext: context).coporate(pollItem,
              (PollAction action) {
            if (action == PollAction.detail) {
              AppNavigate(context)
                  .navigateWithPush(CorporateDetailPage(id: pollItem.id));
            }
          });
        },
        separatorBuilder: (BuildContext context, int position) {
          return const SizedBox(
            height: 8,
          );
        },
        itemCount: items.length);
  }

  void _fetchData(ApiRequest request, bool clear) {
    if (loadedPages.contains(request.url) || request.url.isEmpty) {
      return;
    }
    loadedPages.add(request.url);
    setState(() {
      _loading = true;
    });
    pollCall.allCorporates(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      if (clear) {
        items.clear();
      }
      setState(() {
        items.addAll(value.items);
        nextUrl = value.nextUrl ?? "";
      });
    }).onError((error, stackTrace) {});
  }
}
