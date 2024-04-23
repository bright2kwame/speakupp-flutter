import 'package:speakupp/api/reponse_data_parser.dart';
import 'package:speakupp/model/user/user_item.dart';

class PollCommentItem {
  String id;
  String elapseTime;
  UserItem author;
  String comment;

  PollCommentItem(
      {required this.id,
      required this.elapseTime,
      required this.author,
      required this.comment});

// factory method which helps to create instance of same class
  factory PollCommentItem.fromJson(dynamic map) => PollCommentItem(
        id: ReponseDataParser.getJsonKey(map, "id").toString(),
        author: UserItem.fromJson(map["author"]),
        elapseTime:
            ReponseDataParser.getJsonKey(map, "elapsed_time").toString(),
        comment: ReponseDataParser.getJsonKey(map, "comment").toString(),
      );
}
