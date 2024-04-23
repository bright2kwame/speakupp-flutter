import 'package:speakupp/api/reponse_data_parser.dart';
import 'package:speakupp/model/poll/poll_comment_item.dart';

class PollCommentItemResult {
  int count;
  String? nextUrl;
  String? previousUrl;
  List<PollCommentItem> items;

  PollCommentItemResult({
    required this.count,
    required this.nextUrl,
    required this.previousUrl,
    required this.items,
  });

  // factory method which helps to create instance of same class
  factory PollCommentItemResult.fromJson(dynamic map) => PollCommentItemResult(
      count: ReponseDataParser.getJsonKey(map, "count"),
      nextUrl: ReponseDataParser.getJsonKey(map, "next").toString(),
      previousUrl: ReponseDataParser.getJsonKey(map, "previous").toString(),
      items: (map["results"] as List)
          .map((item) => PollCommentItem.fromJson(item))
          .toList());
}
