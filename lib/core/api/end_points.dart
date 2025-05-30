class EndPoints {
  static const String baseUrl =
      'https://finak.topbusiness.ebharbook.com/api/v1/';

  /// Auth
  static const String loginUrl = '${baseUrl}user/login';
  static const String loginWithSocialUrl = '${baseUrl}user/login-with-social';
  static const String registerUrl = '${baseUrl}user/register';
  static const String profileUrl = '${baseUrl}user/profile';
  static const String resetPasswordUrl = '${baseUrl}user/reset-password';
  static const String addPhoneUrl = '${baseUrl}user/update-phone';
  static const String logoutUrl = '${baseUrl}user/logout';
  static const String fcmUrl = '${baseUrl}user/store-fcm';
  static const String deleteAccountUrl = '${baseUrl}user/delete-account';
  static const String updateProfileUrl = '${baseUrl}user/update-profile';
  static const String changePasswordUrl = '${baseUrl}user/change-password';
  /// Home
  static const String homeUrl = '${baseUrl}user/get-home';
  static const String getServiceTypesUrl = '${baseUrl}user/get-service_types';
  static const String getSubServiceTypesUrl = '${baseUrl}user/get-sub-service_types';
  static const String getOffersUrl = '${baseUrl}user/get-offers';
  static const String getOffersOnMapUrl = '${baseUrl}user/get-offers-on-map';
  static const String getMyOffersUrl = '${baseUrl}user/get-my-offers';
  static const String getOfferDetailsUrl = '${baseUrl}user/get-offer-details';
  static const String addOfferUrl = '${baseUrl}user/add-offer';
  static const String updateOfferUrl = '${baseUrl}user/update-offer/';
  static const String closeOfferUrl = '${baseUrl}user/close-offer';
  static const String openOfferUrl = '${baseUrl}user/open-offer';
  static const String getMyFavUrl = '${baseUrl}user/get-my-fav';
  static const String addOrDeleteFavUrl = '${baseUrl}user/add-or-delete-fav';
  static const String getSettingsUrl = '${baseUrl}user/get-settings';
  ///// Chat
  static const String createRoomUrl = '${baseUrl}user/create-room';
  static const String getRoomMessagesUrl = '${baseUrl}user/get-room-messages';
  static const String getMyChatsUrl = '${baseUrl}user/get-my-chats';
  static const String sendMessageUrl = '${baseUrl}user/send-message';
  ///////// Notifications
  static const String getNotificationsUrl = '${baseUrl}user/get-notifications';
  static const String markAsSeenUrl = '${baseUrl}user/see-notification';
}
