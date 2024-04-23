import 'package:speakupp/common/app_enums.dart';
import 'package:speakupp/model/poll/poll_option_item.dart';

class PollActionType {
  PollAction action;
  PollOptionItem? optionItem;

  PollActionType({
    required this.action,
    this.optionItem,
  });
}
