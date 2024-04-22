import 'package:speakupp/model/common/api_request.dart';
import 'package:speakupp/model/common/detail_item.dart';
import 'package:speakupp/model/user/user_item.dart';

abstract class AuthCall {
  Future<UserItem> signUp(ApiRequest request);
  Future<UserItem> signIn(ApiRequest request);
  Future<UserItem> verifyAccount(ApiRequest request);
  Future<DetailItem> resendCode(ApiRequest request);
  Future<DetailItem> initResetPassword(ApiRequest request);
  Future<DetailItem> resetPassword(ApiRequest request);
  Future<UserItem> updateUser(ApiRequest request);
  Future<DetailItem> uploadFile(ApiRequest request);
  Future<DetailItem> uploadAvatar(ApiRequest request);
  Future<DetailItem> changePassword(ApiRequest request);
  Future<DetailItem> startPhoneVerification(ApiRequest request);
}
