import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:speakupp/common/app_enums.dart';
import 'package:speakupp/common/app_resourses.dart';
import 'package:speakupp/model/poll/poll_company_item.dart';
import 'package:speakupp/model/poll/poll_item.dart';
import 'package:speakupp/model/poll/poll_option_item.dart';

class PollItemView {
  //MARK: display each poll item
  Widget single(PollItem item, Function(PollAction) actionTaken) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.red,
                child: Text(
                  item.pollType.toUpperCase(),
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
          item.hasVoted! ? _votedPollOption(item) : _unVotedPollOption(item),
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

  Widget _unVotedPollOption(PollItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: item.pollOptions.isEmpty
          ? Container()
          : item.pollOptions.first.imageUlr!.isEmpty
              ? _unVotedPollTextOption(item)
              : _unVotedPollImageOption(item),
    );
  }

//MARK: option to select to vote for poll with no image
  Widget _unVotedPollTextOption(PollItem item) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int position) {
          PollOptionItem optionItem = item.pollOptions[position];
          return Text(optionItem.choiceText);
        },
        separatorBuilder: (BuildContext context, int position) {
          return const SizedBox(
            height: 2,
          );
        },
        itemCount: item.pollOptions.length);
  }

//MARK: vote for poll with image
  Widget _unVotedPollImageOption(PollItem item) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        primary: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int position) {
          PollOptionItem _ = item.pollOptions[position];
          return Container(
            height: 200,
            width: 200,
            color: Colors.green,
          );
        },
        separatorBuilder: (BuildContext context, int position) {
          return const SizedBox(
            height: 2,
          );
        },
        itemCount: item.pollOptions.length);
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
              height: 2,
            );
          },
          itemCount: item.pollOptions.length),
    );
  }

  Widget _singleVotedPollOption(String selectedChoice, PollOptionItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
          color: item.id == selectedChoice
              ? AppResourses.appColors.primaryColor
              : Colors.transparent,
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
            child: Text("${item.resultPercent.toString()}%"),
          )
        ],
      ),
    );
  }

  Widget _questionWithImage(PollItem item) {
    return Container(
      height: 308,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                      .textStyle(24, fontColor: Colors.white),
                ),
              ))
        ],
      ),
    );
  }

  Widget _questionWithNoImage(PollItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.question,
            style: AppResourses.appTextStyles.textStyle(24),
          )
        ],
      ),
    );
  }

  Widget _actionAreaView(PollItem item, Function(PollAction) actionTaken) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton.icon(
            onPressed: () {
              actionTaken(PollAction.like);
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
              actionTaken(PollAction.comment);
            },
            icon: Icon(
              LineIcons.comment,
              color: AppResourses.appColors.grayColor,
            ),
            label: Text(
              "${item.noOfComments}",
              style: AppResourses.appTextStyles.textStyle(12),
            )),
        TextButton.icon(
            onPressed: () {
              actionTaken(PollAction.share);
            },
            icon: Icon(
              LineIcons.shareSquareAlt,
              color: item.isShared!
                  ? AppResourses.appColors.primaryButtonColor
                  : AppResourses.appColors.grayColor,
            ),
            label: Text(
              "${item.noOfShares}",
              style: AppResourses.appTextStyles.textStyle(12),
            )),
      ],
    );
  }

  Widget coporate(PollCompanyItem item, Function(PollAction) actionTaken) {
    return ListTile(
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
