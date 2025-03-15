import 'package:finak/core/exports.dart';

import '../data/login_repo.dart';
import 'state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.api) : super(LoginStateInitial());
  LoginRepo api;
  GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  TextEditingController phoneControllerLogin = TextEditingController();
  TextEditingController passwordControllerLogin = TextEditingController();
  GlobalKey<FormState> formKeySignUp = GlobalKey<FormState>();
  TextEditingController phoneControllerSignUp = TextEditingController();
  TextEditingController passwordControllerSignUp = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController nameControllerSignUp = TextEditingController();
  TextEditingController emailControllerSignUp = TextEditingController();

  GlobalKey<FormState> formKeyForgotPassword = GlobalKey<FormState>();
  TextEditingController phoneControllerForgotPassword = TextEditingController();
  GlobalKey<FormState> formKeyOtp = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  GlobalKey<FormState> formKeyNewPassword = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();


}
