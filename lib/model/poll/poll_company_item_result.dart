import 'package:speakupp/api/reponse_data_parser.dart';
import 'package:speakupp/model/poll/poll_company_item.dart';

class PollCompanyItemResult {
  int count;
  String? nextUrl;
  String? previousUrl;
  List<PollCompanyItem> items;

  PollCompanyItemResult({
    required this.count,
    required this.nextUrl,
    required this.previousUrl,
    required this.items,
  });

  // factory method which helps to create instance of same class
  factory PollCompanyItemResult.fromJson(dynamic map) => PollCompanyItemResult(
      count: ReponseDataParser.getJsonKey(map, "count"),
      nextUrl: ReponseDataParser.getJsonKey(map, "next").toString(),
      previousUrl: ReponseDataParser.getJsonKey(map, "previous").toString(),
      items: (map["results"] as List)
          .map((item) => PollCompanyItem.fromJson(item))
          .toList());
}
