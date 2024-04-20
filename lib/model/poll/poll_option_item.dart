import 'package:speakupp/api/reponse_data_parser.dart';

class PollOptionItem {
  String id;
  String? shortCodeText = "";
  String choiceText;
  String? description = "";
  int? numOfVotes = 0;
  String? audioUrl = "";
  String? imageUlr = "";
  double? resultPercent = 0.0;

  PollOptionItem({
    required this.id,
    required this.choiceText,
    this.shortCodeText,
    this.description,
    this.numOfVotes,
    this.audioUrl,
    this.imageUlr,
    this.resultPercent,
  });

  factory PollOptionItem.fromJson(dynamic map) => PollOptionItem(
        id: ReponseDataParser.getJsonKey(map, "id").toString(),
        choiceText: ReponseDataParser.getJsonKey(map, "choice_text").toString(),
        shortCodeText:
            ReponseDataParser.getJsonKey(map, "short_code_text").toString(),
        description:
            ReponseDataParser.getJsonKey(map, "description").toString(),
        audioUrl: ReponseDataParser.getJsonKey(map, "audio").toString(),
        imageUlr: ReponseDataParser.getJsonKey(map, "image").toString(),
        numOfVotes: ReponseDataParser.getJsonKey(map, "num_of_votes"),
        resultPercent: double.parse(
            ReponseDataParser.getJsonKey(map, "result_percent").toString()),
      );
}
