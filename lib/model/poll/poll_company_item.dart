import 'package:speakupp/api/reponse_data_parser.dart';

class PollCompanyItem {
  String id;
  String name;
  String image;

  PollCompanyItem({required this.id, required this.name, required this.image});

  // factory method which helps to create instance of same class
  factory PollCompanyItem.fromJson(dynamic map) => PollCompanyItem(
        id: ReponseDataParser.getJsonKey(map, "id").toString(),
        name: ReponseDataParser.getJsonKey(map, "name").toString(),
        image: ReponseDataParser.getJsonKey(map, "image").toString(),
      );
}
