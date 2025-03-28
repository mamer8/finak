class EndPoints {
  static const String baseUrl =
      'https://finak.topbusiness.ebharbook.com/api/v1/';

  /// Auth
  static const String loginUrl = '${baseUrl}user/login';
  static const String registerUrl = '${baseUrl}user/register';
  static const String profileUrl = '${baseUrl}user/profile';
  static const String resetPasswordUrl = '${baseUrl}user/reset-password';
  static const String logoutUrl = '${baseUrl}user/logout';
  static const String fcmUrl = '${baseUrl}user/store-fcm';
  static const String deleteAccountUrl = '${baseUrl}user/delete-account';
  static const String updateProfileUrl = '${baseUrl}user/update-profile';
  static const String changePasswordUrl = '${baseUrl}user/change-password';
  /// Home
  static const String homeUrl = '${baseUrl}user/get-home';
  static const String getServiceTypesUrl = '${baseUrl}user/get-service_types';
  static const String getSubServiceTypesUrl = '${baseUrl}user/get-sub-service_types';
  static const String getMyOffersUrl = '${baseUrl}user/get-my-offers';
  static const String getOfferDetailsUrl = '${baseUrl}user/get-offer-details';
  static const String addOfferUrl = '${baseUrl}user/add-offer';
  static const String closeOfferUrl = '${baseUrl}user/close-offer';
  static const String getMyFavUrl = '${baseUrl}user/get-my-fav';
  static const String addOrDeleteFavUrl = '${baseUrl}user/add-or-delete-fav';
}
