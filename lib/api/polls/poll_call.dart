import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/common/detail_item.dart';
import 'package:speakupp/model/poll/poll_comment_item_result.dart';
import 'package:speakupp/model/poll/poll_company_item_result.dart';
import 'package:speakupp/model/poll/poll_item.dart';
import 'package:speakupp/model/poll/poll_item_result.dart';

abstract class PollCall {
  Future<PollItemResult> allPolls(ApiRequest request);
  Future<PollItemResult> searchPolls(ApiRequest request);
  Future<PollItem> getPoll(ApiRequest request);
  Future<DetailItem> castVote(ApiRequest request);
  Future<DetailItem> likeUnlikePoll(ApiRequest request);
  Future<DetailItem> sharePoll(ApiRequest request);
  Future<DetailItem> makePayment(ApiRequest request);
  Future<PollCompanyItemResult> allCorporates(ApiRequest request);
  Future<PollCommentItemResult> pollComments(ApiRequest request);
  Future<DetailItem> pollComment(ApiRequest request);
}
