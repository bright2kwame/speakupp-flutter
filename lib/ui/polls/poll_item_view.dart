import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:simple_toast_message/simple_toast.dart';
import 'package:speakupp/common/app_enums.dart';
import 'package:speakupp/common/app_navigate.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/common/poll_action_type.dart';
import 'package:speakupp/model/poll/poll_company_item.dart';
import 'package:speakupp/model/poll/poll_item.dart';
import 'package:speakupp/model/poll/poll_option_item.dart';
import 'package:speakupp/ui/polls/buy_vote_page.dart';
import 'package:speakupp/ui/util/image_preview_page.dart';

class PollItemView {
  BuildContext buildContext;
  PollItemView({required this.buildContext});

  //MARK: display each poll item
  Widget single(PollItem item, Function(PollActionType) actionTaken) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: ListTile(
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                color: Colors.red,
                child: Text(
                  item.pollType.toUpperCase().replaceAll("_", " "),
                  style: AppResourses.appTextStyles
                      .textStyle(10, fontColor: Colors.white),
                ),
              ),
              subtitle: Text.rich(
                textAlign: TextAlign.start,
                TextSpan(
                  text: item.sharedDate,
                  style: AppResourses.appTextStyles.textStyle(
                    16,
                    fontColor: AppResourses.appColors.grayColor,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '\n${item.expiryDate}',
                        style: AppResourses.appTextStyles.textStyle(
                          16,
                          fontColor: AppResourses.appColors.grayColor,
                        )),
                  ],
                ),
              ),
              title: Text(
                "@${item.author.username}",
                style: AppResourses.appTextStyles.textStyle(16),
              ),
              leading: SizedBox(
                height: 60,
                width: 60,
                child: ClipOval(
                  child: item.author.avatar!.isNotEmpty
                      ? Image.network(
                          item.author.avatar!,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          AppResourses.appImages.userAvatar,
                          height: 60,
                          width: 60,
                        ),
                ),
              ),
            ),
          ),
          item.image.isEmpty
              ? _questionWithNoImage(item)
              : _questionWithImage(item),
          item.hasVoted!
              ? _votedPollOption(item)
              : _unVotedPollOption(item, actionTaken),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              item.totalVotes! == 1
                  ? "${item.totalVotes} vote cast."
                  : "${item.totalVotes} votes cast.",
              style: AppResourses.appTextStyles.textStyle(16),
            ),
          ),
          const Divider(
            height: 2,
            color: Colors.grey,
          ),
          _actionAreaView(item, actionTaken)
        ],
      ),
    );
  }

  Widget _unVotedPollOption(
      PollItem item, Function(PollActionType) actionTaken) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: item.pollOptions.isEmpty
          ? Container()
          : item.pollOptions.first.imageUlr!.isEmpty
              ? _unVotedPollTextOption(item, actionTaken)
              : _unVotedPollImageOption(item, actionTaken),
    );
  }

//MARK: option to select to vote for poll with no image
  Widget _unVotedPollTextOption(
      PollItem item, Function(PollActionType) actionTaken) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int position) {
          PollOptionItem optionItem = item.pollOptions[position];
          return _singleUnVotedPollOption(item, optionItem, actionTaken);
        },
        separatorBuilder: (BuildContext context, int position) {
          return const SizedBox(
            height: 2,
          );
        },
        itemCount: item.pollOptions.length);
  }

  Widget _singleUnVotedPollOption(PollItem pollItem, PollOptionItem item,
      Function(PollActionType) actionTaken) {
    return GestureDetector(
      onTap: () {
        _startVotingProcess(pollItem, item, actionTaken);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
            color: Colors.transparent, border: Border.all(color: Colors.grey)),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Radio(
                  value: "value",
                  groupValue: "groupValue",
                  onChanged: (String? check) {
                    _startVotingProcess(pollItem, item, actionTaken);
                  }),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(item.choiceText),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _startVotingProcess(PollItem item, PollOptionItem option,
      Function(PollActionType) action) async {
    if (item.hasExpired!) {
      SimpleToast.showErrorToast(
          buildContext, "SpeakUpp", "The poll has expired");
      return;
    }
    if (item.pollType == PollType.PAID_POLL.name) {
      AppNavigate(buildContext).navigateWithPush(
          BuyVotePage(
            pollItem: item,
            pollOptionItem: option,
          ), callback: (done) {
        if (done) {
          action(PollActionType(action: PollAction.vote));
        }
      });
    } else {
      action(PollActionType(action: PollAction.vote, optionItem: option));
    }
  }

  //MARK: vote for poll with image
  Widget _unVotedPollImageOption(
      PollItem item, Function(PollActionType) actionTaken) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          primary: false,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int position) {
            PollOptionItem option = item.pollOptions[position];
            return GestureDetector(
              onTap: () {
                _startVotingProcess(item, option, actionTaken);
              },
              child: Container(
                height: 200,
                width: 200,
                margin: const EdgeInsets.only(right: 4),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: Image.network(
                        option.imageUlr!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              LineIcons.users,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "${option.numOfVotes}",
                                style: AppResourses.appTextStyles
                                    .textStyle(12, fontColor: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  option.choiceText,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppResourses.appTextStyles
                                      .textStyle(12, fontColor: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          color: Colors.black,
                          child: GestureDetector(
                              onTap: () {
                                _startImagePreview(option.imageUlr ?? "");
                              },
                              child: const Icon(
                                LineIcons.expand,
                                size: 32,
                                color: Colors.white,
                              )),
                        ))
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int position) {
            return const SizedBox(
              height: 2,
            );
          },
          itemCount: item.pollOptions.length),
    );
  }

  void _startImagePreview(String url) {
    AppNavigate(buildContext).navigateWithPush(ImagePreviewPage(
      url: url,
    ));
  }

  Widget _votedPollOption(PollItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          primary: false,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int position) {
            PollOptionItem optionItem = item.pollOptions[position];
            return _singleVotedPollOption(item.votedOption ?? "", optionItem);
          },
          separatorBuilder: (BuildContext context, int position) {
            return const SizedBox(
              height: 4,
            );
          },
          itemCount: item.pollOptions.length),
    );
  }

  Widget _singleVotedPollOption(String selectedChoice, PollOptionItem item) {
    return SizedBox(
      height: 44,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: LinearProgressIndicator(
                value: item.resultPercent! / 100,
                backgroundColor: Colors.white,
                color: AppResourses.appColors.primaryColor),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: Container(
              height: 44,
              margin: const EdgeInsets.symmetric(vertical: 0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: item.id == selectedChoice
                          ? AppResourses.appColors.primaryColor
                          : Colors.grey)),
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(item.choiceText),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("${item.resultPercent!.toStringAsFixed(2)}%"),
                  ),
                  item.id == selectedChoice
                      ? Padding(
                          padding: const EdgeInsets.all(4.0),
                          child:
                              Image.asset(AppResourses.appImages.correctSign),
                        )
                      : Container()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _questionWithImage(PollItem item) {
    return Container(
      height: 308,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 300,
              child: Image.network(
                item.image,
                height: 300,
                fit: BoxFit.cover,
              )),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black.withAlpha(100),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item.question,
                  style: AppResourses.appTextStyles
                      .textStyle(18, fontColor: Colors.white),
                ),
              ))
        ],
      ),
    );
  }

  Widget _questionWithNoImage(PollItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.question,
            style: AppResourses.appTextStyles.textStyle(18),
          )
        ],
      ),
    );
  }

  Widget _actionAreaView(PollItem item, Function(PollActionType) actionTaken) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton.icon(
            onPressed: () {
              actionTaken(PollActionType(action: PollAction.like));
            },
            icon: Icon(
              LineIcons.heart,
              color: item.hasLiked!
                  ? AppResourses.appColors.primaryButtonColor
                  : AppResourses.appColors.grayColor,
            ),
            label: Text(
              "${item.noOfLikes}",
              style: AppResourses.appTextStyles.textStyle(12),
            )),
        TextButton.icon(
            onPressed: () {
              actionTaken(PollActionType(action: PollAction.comment));
            },
            icon: Icon(
              LineIcons.comment,
              color: AppResourses.appColors.grayColor,
            ),
            label: Text(
              "${item.noOfComments}",
              style: AppResourses.appTextStyles.textStyle(12),
            )),
        IconButton(
          onPressed: () {
            actionTaken(PollActionType(action: PollAction.share));
          },
          icon: Icon(
            LineIcons.shareSquareAlt,
            color: item.isShared!
                ? AppResourses.appColors.primaryButtonColor
                : AppResourses.appColors.grayColor,
          ),
        ),
      ],
    );
  }

  Widget coporate(PollCompanyItem item, Function(PollAction) actionTaken) {
    return ListTile(
      onTap: () {
        actionTaken(PollAction.detail);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      title: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          item.name,
          style: AppResourses.appTextStyles.textStyle(16),
        ),
      ),
      leading: SizedBox(
        height: 60,
        width: 60,
        child: ClipOval(
          child: Image.network(
            item.image,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
