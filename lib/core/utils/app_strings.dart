
import 'package:finak/core/preferences/preferences.dart';

class AppStrings {
  static const String appName = 'Finak';

  static const String fontFamily = 'Jost';
  static const String noRouteFound = 'No Route Found';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String englishCode = 'en';
  static const String arabicCode = 'ar';
  static const String locale = 'locale';
}
class AppConst {
    static bool get isLogged  =>  prefs.getBool("ISLOGGED") ?? false;
    static set isLogged(bool value) {
    isLogged = value;
  }
}
