import 'package:dio/dio.dart';
import 'package:speakupp/api/api_exception.dart';
import 'package:speakupp/api/polls/poll_call.dart';
import 'package:speakupp/api/reponse_data_parser.dart';
import 'package:speakupp/common/app_enums.dart';
import 'package:speakupp/common/app_utility.dart';
import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/common/detail_item.dart';
import 'package:speakupp/model/poll/poll_comment_item_result.dart';
import 'package:speakupp/model/poll/poll_company_item_result.dart';
import 'package:speakupp/model/poll/poll_item.dart';
import 'package:speakupp/model/poll/poll_item_result.dart';

class PollCallImpl extends PollCall {
  late Dio dio;

  PollCallImpl(Dio dioIn) {
    dio = dioIn;
  }

  @override
  Future<PollItem> getPoll(ApiRequest request) async {
    Response response;
    try {
      response = await dio.get(request.url, data: request.data);
      return _handlePollResult(response);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: ReponseDataParser.getJsonKey(e.response?.data, "detail"));
    }
  }

  @override
  Future<PollItemResult> allPolls(ApiRequest request) async {
    Response response;
    try {
      response = await dio.get(request.url, data: request.data);
      return _handlePollsResult(response);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: ReponseDataParser.getJsonKey(e.response?.data, "detail"));
    }
  }

  @override
  Future<PollItemResult> searchPolls(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handlePollsResult(response);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: ReponseDataParser.getJsonKey(e.response?.data, "detail"));
    }
  }

  @override
  Future<PollCompanyItemResult> allCorporates(ApiRequest request) async {
    Response response;
    try {
      response = await dio.get(request.url, data: request.data);
      return _handleCoporateResult(response);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: ReponseDataParser.getJsonKey(e.response?.data, "detail"));
    }
  }

  @override
  Future<PollCommentItemResult> pollComments(ApiRequest request) async {
    Response response;
    try {
      response = await dio.get(request.url, data: request.data);
      return _handlePollCommentResult(response);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: ReponseDataParser.getJsonKey(e.response?.data, "detail"));
    }
  }

  @override
  Future<DetailItem> pollComment(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleMessageResult(response);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: ReponseDataParser.getJsonKey(e.response?.data, "detail"));
    }
  }

  PollItem _handlePollResult(Response<dynamic> response) {
    AppUtility.printLogMessage(response.data, "RESULT");
    String code = ReponseDataParser.getJsonKey(response.data, "status");
    if (code == ApiResultStatus.success.name) {
      return PollItem.fromJson(response.data["results"]);
    } else {
      throw ApiException(
          code: int.parse(code),
          message:
              ReponseDataParser.getJsonKey(response.data, "detail").toString());
    }
  }

  PollCompanyItemResult _handleCoporateResult(Response<dynamic> response) {
    AppUtility.printLogMessage(response.data, "RESULT");
    String code = ReponseDataParser.getJsonKey(response.data, "status");
    if (code == ApiResultStatus.success.name) {
      return PollCompanyItemResult.fromJson(response.data);
    } else {
      throw ApiException(
          code: int.parse(code),
          message:
              ReponseDataParser.getJsonKey(response.data, "detail").toString());
    }
  }

  PollItemResult _handlePollsResult(Response<dynamic> response) {
    AppUtility.printLogMessage(response.data, "RESULT");
    String code = ReponseDataParser.getJsonKey(response.data, "status");
    if (code == ApiResultStatus.success.name) {
      return PollItemResult.fromJson(response.data);
    } else {
      throw ApiException(
          code: int.parse(code),
          message:
              ReponseDataParser.getJsonKey(response.data, "detail").toString());
    }
  }

  @override
  Future<DetailItem> castVote(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleMessageResult(response);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: ReponseDataParser.getJsonKey(e.response?.data, "detail"));
    }
  }

  @override
  Future<DetailItem> likeUnlikePoll(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleMessageResult(response);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: ReponseDataParser.getJsonKey(e.response?.data, "detail"));
    }
  }

  @override
  Future<DetailItem> makePayment(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handlePaymentResult(response);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: ReponseDataParser.getJsonKey(e.response?.data, "detail"));
    }
  }

  @override
  Future<DetailItem> sharePoll(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleMessageResult(response);
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: ReponseDataParser.getJsonKey(e.response?.data, "detail"));
    }
  }

  PollCommentItemResult _handlePollCommentResult(Response<dynamic> response) {
    AppUtility.printLogMessage(response.data, "RESULT");
    String code = ReponseDataParser.getJsonKey(response.data, "status");
    if (code == ApiResultStatus.success.name) {
      return PollCommentItemResult.fromJson(response.data);
    } else {
      throw ApiException(
          code: int.parse(code),
          message:
              ReponseDataParser.getJsonKey(response.data, "detail").toString());
    }
  }

  DetailItem _handlePaymentResult(Response<dynamic> response) {
    AppUtility.printLogMessage(response.data, "RESULT");
    String code = ReponseDataParser.getJsonKey(response.data, "redirect_url");
    if (code.isNotEmpty) {
      return DetailItem.fromPaymentJson(response.data);
    } else {
      throw ApiException(
          code: 300,
          message: ReponseDataParser.getJsonKey(response.data, "detail"));
    }
  }

  DetailItem _handleMessageResult(Response<dynamic> response) {
    AppUtility.printLogMessage(response.data, "RESULT");
    String status = ReponseDataParser.getJsonKey(response.data, "status");
    if (status == ApiResultStatus.success.name) {
      return DetailItem.fromMessageJson(response.data);
    } else {
      throw ApiException(
          code: 300,
          message: ReponseDataParser.getJsonKey(response.data, "detail"));
    }
  }
}
