import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:speakupp/api/polls/poll_call.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/poll/poll_comment_item.dart';
import 'package:speakupp/model/user/user_item.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/ui/common/app_input_decorator.dart';
import 'package:speakupp/ui/common/app_progress_indicator.dart';
import 'package:speakupp/ui/common/custom_app_bar.dart';

class PollCommentPage extends StatefulWidget {
  final String id;
  const PollCommentPage({super.key, required this.id});

  @override
  State<PollCommentPage> createState() => _PollCommentPageState();
}

class _PollCommentPageState extends State<PollCommentPage> {
  bool _loading = false;
  final PollCall pollCall = GetIt.instance.get<PollCall>();
  List<PollCommentItem> items = [];
  String nextUrl = "";
  final TextEditingController _commentController = TextEditingController();
  final UserItemProvider userItemProvider =
      GetIt.instance.get<UserItemProvider>();
  late UserItem? userItem;

  @override
  void initState() {
    super.initState();
    userItem = null;
    userItemProvider.list().then((value) {
      setState(() {
        userItem = value[0];
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _uiReady(context));
  }

  void _uiReady(BuildContext buildContext) {
    Map<String, dynamic> dataParams = {};
    var request = ApiRequest(
        url: AppResourses.appStrings.getPollsCommentUrl(widget.id),
        data: dataParams);
    _fetchData(request, true);
  }

  void _makeComment() {
    String comment = _commentController.text.trim();
    if (comment.isEmpty) {
      return;
    }
    Map<String, dynamic> dataParams = {"user_comment": comment};
    _commentController.text = "";
    var request = ApiRequest(
        url: AppResourses.appStrings.getPollCommentUrl(widget.id),
        data: dataParams);
    items.add(PollCommentItem(
        id: "id", elapseTime: "Now", author: userItem!, comment: comment));
    _sendCommentData(request);
  }

  void _sendCommentData(ApiRequest request) {
    setState(() {
      _loading = true;
    });
    pollCall
        .pollComment(request)
        .whenComplete(() {
          setState(() {
            _loading = false;
          });
        })
        .then((value) {})
        .onError((error, stackTrace) {});
  }

  void _fetchData(ApiRequest request, bool clear) {
    setState(() {
      _loading = true;
    });
    pollCall.pollComments(request).whenComplete(() {
      setState(() {
        _loading = false;
      });
    }).then((value) {
      if (clear) {
        items.clear();
      }
      setState(() {
        items.addAll(value.items.reversed);
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
          title: "Poll Comments",
          textColor: Colors.white,
          backgroundColor: AppResourses.appColors.primaryColor),
      backgroundColor: AppResourses.appColors.background,
    );
  }

  Widget _mainView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppProgressIndicator().inderminateProgress(_loading,
            color: AppResourses.appColors.primaryColor),
        Expanded(child: _pollsCommentView()),
        _commentViewSection()
      ],
    );
  }

  Widget _commentViewSection() {
    return SafeArea(
        child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextFormField(
        autocorrect: true,
        controller: _commentController,
        keyboardType: TextInputType.text,
        style:
            AppResourses.appTextStyles.textStyle(16, fontColor: Colors.black),
        decoration:
            AppInputDecorator.commentInputDecoration("Say Something ...", () {
          _makeComment();
        }),
      ),
    ));
  }

  Widget _pollsCommentView() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        primary: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int position) {
          PollCommentItem commentItem = items[position];
          return _commentItemView(commentItem);
        },
        separatorBuilder: (BuildContext context, int position) {
          return const SizedBox(
            height: 8,
          );
        },
        itemCount: items.length);
  }

  Widget _commentItemView(PollCommentItem item) {
    return BubbleSpecialThree(
      text: item.comment,
      color: AppResourses.appColors.primaryButtonColor,
      tail: true,
      isSender: item.author.id == (userItem != null ? userItem!.id : ""),
      textStyle:
          AppResourses.appTextStyles.textStyle(16, fontColor: Colors.white),
    );
  }
}
