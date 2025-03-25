class EndPoints {
  static const String baseUrl =
      'https://finak.topbusiness.ebharbook.com/api/v1/';

  /// User
  static const String loginUrl = '${baseUrl}user/login';
  static const String registerUrl = '${baseUrl}user/register';
  static const String profileUrl = '${baseUrl}user/profile';
  static const String resetPasswordUrl = '${baseUrl}user/reset-password';
  static const String logoutUrl = '${baseUrl}user/logout';
  static const String fcmUrl = '${baseUrl}user/store-fcm';
  static const String deleteAccountUrl = '${baseUrl}user/delete-account';
  static const String updateProfileUrl = '${baseUrl}user/update-profile';
  static const String changePasswordUrl = '${baseUrl}user/change-password';
  static const String homeUrl = '${baseUrl}home';
}
