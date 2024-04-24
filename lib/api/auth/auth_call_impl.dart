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
      //dio.options.headers = {"":""};
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
      return _handleMessageResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DetailItem> startPhoneVerification(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleMessageResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DetailItem> changePassword(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleMessageResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DetailItem> uploadFile(ApiRequest request) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(request.data["file"]),
    });
    Response response;
    try {
      response = await dio.post(request.url, data: formData);
      return _handleFileResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DetailItem> uploadAvatar(ApiRequest request) async {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(request.data["file"]),
    });
    Response response;
    try {
      response = await dio.post(request.url, data: formData);
      return _handleFileResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DetailItem> resetPassword(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleMessageResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DetailItem> initResetPassword(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleMessageResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<DetailItem> deleteAccount(ApiRequest request) async {
    Response response;
    try {
      response = await dio.post(request.url, data: request.data);
      return _handleMessageResult(response);
    } on DioException catch (e) {
      throw _handleException(e);
    }
  }

  DetailItem _handleMessageResult(Response<dynamic> response) {
    AppUtility.printLogMessage(response.data, "RESULT");
    String code = ReponseDataParser.getJsonKey(response.data, "status");
    if (code == ApiResultStatus.success.name) {
      return DetailItem.fromMessageJson(response.data);
    } else {
      throw ApiException(
          code: 300,
          message: ReponseDataParser.getJsonKey(response.data, "detail"));
    }
  }

  DetailItem _handleFileResult(Response<dynamic> response) {
    String code = ReponseDataParser.getJsonKey(response.data, "response_code");
    if (code == ApiResultStatus.success.name) {
      return DetailItem.fromFileJson(response.data);
    } else {
      throw ApiException(
          code: 300,
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
    AppUtility.printLogMessage(e.response?.statusCode ?? 0, "FAILED_CODE");
    String detail = ReponseDataParser.getJsonKey(e.response?.data, "detail")
        .toString()
        .trim();
    if (detail.isEmpty) {
      detail = ReponseDataParser.getJsonKey(e.response?.data, "message");
    }
    if (detail.isEmpty) {
      detail = ReponseDataParser.getJsonKey(e.response?.data, "results");
    }
    if (detail.isEmpty) {
      detail =
          "Sorry, Unable to establish connection with the server. Try again later";
    }
    return ApiException(code: e.response?.statusCode ?? 0, message: detail);
  }
}
