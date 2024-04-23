import 'package:speakupp/api/reponse_data_parser.dart';
import 'package:speakupp/common/app_utility.dart';
import 'package:speakupp/model/poll/poll_option_item.dart';
import 'package:speakupp/model/user/user_item.dart';

class PollItem {
  String id;
  UserItem author;
  String pollType;
  bool isAudio;
  String pricePerSMS;
  String image;
  String question;
  String? hexCode;
  String? shortCode;
  bool? hasExpired = false;
  bool? isShared = false;
  bool? isSponsored = false;
  String? audioUrl;
  String? eventLocation;
  String? resultVisibility;
  String? sharedComment;
  int? noOfShares = 0;
  int? noOfLikes = 0;
  int? noOfComments = 0;
  int? totalVotes = 0;
  int? totalRatings = 0;
  int? totalAverageRatings = 0;
  bool? hasVoted = false;
  bool? hasImages = false;
  bool? hasLiked = false;
  bool? hasLink = false;
  String? elapsedTime;
  String? sharedDate;
  String? expiryDate;
  String? link;
  String? votedOption;
  String? ratingOption;
  List<PollOptionItem> pollOptions;

  PollItem(
      {required this.id,
      required this.author,
      required this.pollType,
      required this.isAudio,
      required this.pricePerSMS,
      required this.image,
      required this.question,
      required this.pollOptions,
      this.hexCode,
      this.shortCode,
      this.hasExpired,
      this.isShared,
      this.isSponsored,
      this.audioUrl,
      this.eventLocation,
      this.resultVisibility,
      this.noOfShares,
      this.sharedComment,
      this.totalVotes,
      this.hasVoted,
      this.hasImages,
      this.hasLiked,
      this.elapsedTime,
      this.noOfLikes,
      this.noOfComments,
      this.sharedDate,
      this.expiryDate,
      this.hasLink,
      this.link,
      this.totalAverageRatings,
      this.totalRatings,
      this.votedOption,
      this.ratingOption});

  // factory method which helps to create instance of same class
  static PollItem fromJson(dynamic map) {
    for (var item in (map as Map<String, dynamic>).entries) {
      AppUtility.printLogMessage(item, "EACH");
    }

    return PollItem(
      id: ReponseDataParser.getJsonKey(map, "id").toString(),
      pollType: ReponseDataParser.getJsonKey(map, "poll_type").toString(),
      isAudio: ReponseDataParser.getJsonKey(map, "is_audio"),
      hasExpired: ReponseDataParser.getJsonKey(map, "has_expired"),
      isShared: ReponseDataParser.getJsonKey(map, "is_shared"),
      isSponsored: ReponseDataParser.getJsonKey(map, "is_sponsored"),
      pricePerSMS:
          ReponseDataParser.getJsonKey(map, "price_per_sms").toString(),
      image: ReponseDataParser.getJsonKey(map, "image").toString(),
      hexCode: ReponseDataParser.getJsonKey(map, "hex_code").toString(),
      shortCode: ReponseDataParser.getJsonKey(map, "short_code").toString(),
      question: ReponseDataParser.getJsonKey(map, "question").toString(),
      pollOptions: (map["poll_choices"] as List)
          .map((item) => PollOptionItem.fromJson(item))
          .toList(),
      audioUrl: ReponseDataParser.getJsonKey(map, "audio").toString(),
      resultVisibility:
          ReponseDataParser.getJsonKey(map, "results_visibility").toString(),
      sharedComment:
          ReponseDataParser.getJsonKey(map, "shared_comment").toString(),
      noOfShares: ReponseDataParser.getJsonKey(map, "num_of_shares"),
      totalVotes: ReponseDataParser.getJsonKey(map, "total_votes"),
      hasVoted: ReponseDataParser.getJsonKey(map, "has_voted"),
      hasImages: ReponseDataParser.getJsonKey(map, "has_images"),
      hasLiked: ReponseDataParser.getJsonKey(map, "has_liked"),
      elapsedTime: ReponseDataParser.getJsonKey(map, "elapsed_time").toString(),
      noOfLikes: ReponseDataParser.getJsonKey(map, "num_of_likes"),
      noOfComments: ReponseDataParser.getJsonKey(map, "num_of_comments"),
      sharedDate: ReponseDataParser.getJsonKey(map, "shared_date").toString(),
      expiryDate: ReponseDataParser.getJsonKey(map, "expiry_date").toString(),
      hasLink: ReponseDataParser.getJsonKey(map, "has_link"),
      link: ReponseDataParser.getJsonKey(map, "link").toString(),
      votedOption: ReponseDataParser.getJsonKey(map, "voted_option").toString(),
      ratingOption:
          ReponseDataParser.getJsonKey(map, "rating_option").toString(),
      totalAverageRatings:
          ReponseDataParser.getJsonKey(map, "total_average_rating"),
      totalRatings: ReponseDataParser.getJsonKey(map, "total_rating_votes"),
      author: UserItem.fromJson(map["author"]),
    );
  }
}
