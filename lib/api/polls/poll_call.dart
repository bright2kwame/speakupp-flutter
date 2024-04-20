import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/poll/poll_company_item_result.dart';
import 'package:speakupp/model/poll/poll_item.dart';
import 'package:speakupp/model/poll/poll_item_result.dart';

abstract class PollCall {
  Future<PollItemResult> allPolls(ApiRequest request);
  Future<PollItem> getPoll(ApiRequest request);
  Future<PollCompanyItemResult> allCorporates(ApiRequest request);
}
