class AppStrings {
  String appName = "SpeakUpp";

  String getBaseUrl() {
    return "https://www.speakupp.com/api/v1.0/";
  }

  String getCoporatePollsUrl(String id) {
    return "$corporatesUrl$id/get_polls/";
  }

  String getPollsCommentUrl(String id) {
    return "polls/$id/comments/";
  }

  String getPollCommentUrl(String id) {
    return "polls/$id/comment/";
  }

  String getParameterPaidPollUrl(String id) {
    return "polls/$id/parameter_voting/";
  }

  String getLikePollUrl(String id) {
    return "polls/$id/like/";
  }

  String getVotePollUrl(String id) {
    return "polls/$id/vote/";
  }

  String getUnLikePollUrl(String id) {
    return "polls/$id/unlike/";
  }

  String getDeleteUserUrl(String id) {
    return "users/$id/delete_account/";
  }

  String get initResetUrl => "users/reset_password/";
  String get confirmResetUrl => "users/reset_password_confirm/";
  String get completeResetUrl => "users/change_password/";
  String get signUpUrl => "users/signup/";
  String get confirmUrl => "users/signup_confirm/";
  String get profileUrl => "users/me/";
  String get inviteUserUrl => "single_send_sms/";
  String get uploadProfileUrl => "users/upload_avatar_url/";
  String get uploadProfileBgUrl => "users/update_background_image/";
  String get loginUrl => "users/mobile_login/";
  String get resendCodeUrl => "resend_verification_code/";
  String get interestUrl => "fetch_interest/";
  String get updateInterestUrl => "update_user_interest/";
  String get brandsUrl => "get_brands/";
  String get pollsUrl => "polls/";
  String get trendingPolls => "timeline/";
  String get paymentCallback => "https://www.speakupp.com/processing_payment/";
  String get partnersUrl => "partners/";
  String get paidPollUrl => "get_paidpoll_url/";
  String get timelineUrl => "timeline/";
  String get corporatesUrl => "all_new_polls/";
  String get privacyUrl => "https://www.speakupp.com/";
  String get pollSearchUrl => "new_search_poll/";
}
