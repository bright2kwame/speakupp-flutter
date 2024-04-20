import 'package:speakupp/api/reponse_data_parser.dart';
import 'package:speakupp/model/poll/poll_item.dart';

class PollItemResult {
  int count;
  String? nextUrl;
  String? previousUrl;
  List<PollItem> items;

  PollItemResult({
    required this.count,
    required this.nextUrl,
    required this.previousUrl,
    required this.items,
  });

  // factory method which helps to create instance of same class
  factory PollItemResult.fromJson(dynamic map) => PollItemResult(
      count: ReponseDataParser.getJsonKey(map, "count"),
      nextUrl: ReponseDataParser.getJsonKey(map, "next").toString(),
      previousUrl: ReponseDataParser.getJsonKey(map, "previous").toString(),
      items: (map["results"] as List)
          .map((item) => PollItem.fromJson(item))
          .toList());
}
