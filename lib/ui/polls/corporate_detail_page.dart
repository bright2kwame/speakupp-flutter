import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_toast_message/simple_toast.dart';
import 'package:speakupp/api/api_exception.dart';
import 'package:speakupp/api/polls/poll_call.dart';
import 'package:speakupp/common/app_enums.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/common/app_utility.dart';
import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/common/poll_action_type.dart';
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
    Map<String, dynamic> dataParams = {};
    var request = ApiRequest(
        url: AppResourses.appStrings.getCoporatePollsUrl(widget.id),
        data: dataParams);
    _fetchData(request, true);
  }

  void _fetchData(ApiRequest request, bool clear) {
    setState(() {
      _loading = true;
    });
    pollCall.allPolls(request).whenComplete(() {
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
          return PollItemView(buildContext: context).single(pollItem,
              (PollActionType action) {
            _handlePollAction(position, action, pollItem);
          });
        },
        separatorBuilder: (BuildContext context, int position) {
          return const SizedBox(
            height: 8,
          );
        },
        itemCount: items.length);
  }

  void _handlePollAction(int pos, PollActionType action, PollItem pollItem) {
    if (action.action == PollAction.share) {
      _sharePoll(pollItem);
    } else if (action.action == PollAction.like) {
      _likeUnlikePoll(pollItem, pos);
    } else if (action.action == PollAction.comment) {
    } else if (action.action == PollAction.vote) {
      if (action.optionItem == null) {
        _updateVotedPoll(pos);
      } else {
        _startPollVote(pos, action, pollItem);
      }
    }
  }

  Future<void> _startPollVote(
      int pos, PollActionType action, PollItem pollItem) async {
    pollCall
        .castVote(ApiRequest(
            url: AppResourses.appStrings.getVotePollUrl(pollItem.id),
            data: {
          "choice_id": action.optionItem!.id,
          "device_model": Platform.isIOS ? "Iphone" : "Android"
        }))
        .then((value) {
      _updateVotedPoll(pos);
    }).onError((error, stackTrace) {
      SimpleToast.showErrorToast(
          context, "SpeakUpp", (error as ApiException).message);
    });
  }

  void _updateVotedPoll(int pos) {
    Map<String, dynamic> dataParams = {};
    var request = ApiRequest(
        url: AppResourses.appStrings.trendingPolls, data: dataParams);
    _fetchData(request, true);
  }

  void _sharePoll(PollItem pollItem) {
    AppUtility.startSharingContent(
        "Hi, Join me on SpeakUpp to vote on the poll '${pollItem.question}'. Download SpeakUpp here: https://www.speakupp.com/");
  }

  void _likeUnlikePoll(PollItem pollItem, int pos) {
    int countOfLikes = !items[pos].hasLiked!
        ? items[pos].noOfLikes! + 1
        : items[pos].noOfLikes! - 1;
    String url = !items[pos].hasLiked!
        ? AppResourses.appStrings.getLikePollUrl(pollItem.id)
        : AppResourses.appStrings.getUnLikePollUrl(pollItem.id);
    pollCall.likeUnlikePoll(ApiRequest(url: url, data: {}));

    setState(() {
      items[pos].noOfLikes =
          !items[pos].hasLiked! ? countOfLikes++ : countOfLikes--;
      items[pos].hasLiked = !items[pos].hasLiked!;
    });
  }
}
