import 'package:dio/dio.dart';
import 'package:speakupp/api/api_exception.dart';
import 'package:speakupp/api/auth/auth_call.dart';
import 'package:speakupp/api/reponse_data_parser.dart';
import 'package:speakupp/common/app_enums.dart';
import 'package:speakupp/common/app_utility.dart';
import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/common/detail_item.dart';
import 'package:speakupp/model/user/user_item.dart';

class AuthCallImpl extends AuthCall {
  late Dio dio;

  AuthCallImpl(Dio dioIn) {
    dio = dioIn;
  }

  @override
  Future<UserItem> signIn(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleUserResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<UserItem> signUp(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleUserResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<UserItem> verifyAccount(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleUserResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<UserItem> updateUser(ApiRequest request) async {
    Response response;
    try {
      response = await dio.put(request.url, data: request.data);
      return _handleUserResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DetailItem> resendCode(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleDetailResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DetailItem> startPhoneVerification(ApiRequest request) async {
    final response = await dio.post(request.url, data: request.data);
    return _handleMessageResult(response);
  }

  @override
  Future<DetailItem> verifyPhone(ApiRequest request) async {
    final response = await dio.post(request.url, data: request.data);
    return _handleMessageResult(response);
  }

  @override
  Future<DetailItem> uploadFile(ApiRequest request) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(request.data["file"]),
    });
    final response = await dio.post(request.url, data: formData);
    return _handleFileResult(response);
  }

  @override
  Future<DetailItem> uploadAvatar(ApiRequest request) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(request.data["file"]),
    });
    final response = await dio.post(request.url, data: formData);
    return _handleFileResult(response);
  }

  @override
  Future<DetailItem> resetPassword(ApiRequest request) async {
    final response = await dio.post(request.url, data: request.data);
    return _handleDetailResult(response);
  }

  @override
  Future<DetailItem> initResetPassword(ApiRequest request) async {
    final response = await dio.post(request.url, data: request.data);
    return _handleDetailResult(response);
  }

  DetailItem _handleMessageResult(Response<dynamic> response) {
    try {
      String code =
          ReponseDataParser.getJsonKey(response.data, "response_code");
      if (code == "100") {
        return DetailItem.fromJson(response.data);
      } else {
        throw ApiException(
            code: int.parse(code),
            message: ReponseDataParser.getJsonKey(response.data, "detail"));
      }
    } on DioException catch (e) {
      throw ApiException(
          code: e.response?.statusCode ?? 0,
          message: e.response?.statusMessage ?? "");
    }
  }

  DetailItem _handleDetailResult(Response<dynamic> response) {
    String code = ReponseDataParser.getJsonKey(response.data, "response_code");
    if (code == "100") {
      return DetailItem.fromJson(response.data);
    } else {
      throw ApiException(
          code: int.parse(code),
          message: ReponseDataParser.getJsonKey(response.data, "detail"));
    }
  }

  DetailItem _handleFileResult(Response<dynamic> response) {
    String code = ReponseDataParser.getJsonKey(response.data, "response_code");
    if (code == "100") {
      return DetailItem.fromFileJson(response.data);
    } else {
      throw ApiException(
          code: int.parse(code),
          message: ReponseDataParser.getJsonKey(response.data, "detail"));
    }
  }

  UserItem _handleUserResult(Response<dynamic> response) {
    AppUtility.printLogMessage(response.data, "RESULT");
    String code = ReponseDataParser.getJsonKey(response.data, "status");
    if (code == ApiResultStatus.success.name) {
      return UserItem.fromJson(response.data["results"]);
    } else {
      throw ApiException(
          code: int.parse(code),
          message:
              ReponseDataParser.getJsonKey(response.data, "detail").toString());
    }
  }

  ApiException _handleException(DioException e) {
    String detail = ReponseDataParser.getJsonKey(e.response?.data, "detail")
        .toString()
        .trim();
    if (detail.isEmpty) {
      detail = ReponseDataParser.getJsonKey(e.response?.data, "message");
    }
    if (detail.isEmpty) {
      detail = ReponseDataParser.getJsonKey(e.response?.data, "results");
    }
    return ApiException(code: e.response?.statusCode ?? 0, message: detail);
  }
}
