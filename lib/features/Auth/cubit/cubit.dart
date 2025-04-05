import 'dart:developer';

import 'package:finak/core/exports.dart';
import 'package:finak/core/preferences/preferences.dart';
import 'package:finak/core/utils/appwidget.dart';
import 'package:finak/core/utils/dialogs.dart';
import 'package:finak/features/Auth/data/models/login_model.dart';
import 'package:finak/features/profile/cubit/cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../data/login_repo.dart';
import 'state.dart';

enum OTPTypes { forgotPassword, register, addPhone }

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.api) : super(LoginStateInitial());
  LoginRepo api;
  // GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  TextEditingController phoneControllerLogin = TextEditingController();
  TextEditingController passwordControllerLogin = TextEditingController();
  // GlobalKey<FormState> formKeySignUp = GlobalKey<FormState>();
  TextEditingController phoneControllerSignUp = TextEditingController();
  TextEditingController passwordControllerSignUp = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController nameControllerSignUp = TextEditingController();
  TextEditingController emailControllerSignUp = TextEditingController();

  // GlobalKey<FormState> formKeyForgotPassword = GlobalKey<FormState>();
  TextEditingController phoneControllerForgotPassword = TextEditingController();

  TextEditingController otpController = TextEditingController();

  // GlobalKey<FormState> formKeyNewPassword = GlobalKey<FormState>();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  TextEditingController phoneControllerAddPhone = TextEditingController();

  final FirebaseAuth _mAuth = FirebaseAuth.instance;
  String? verificationId;
  String? smsCode;
  int? resendToken;

  String countryCode = '+20';
  String phone = "+201027639683";
  Future<void> sendOTP(BuildContext context,
      {OTPTypes type = OTPTypes.forgotPassword}) async {
    AppWidget.createProgressDialog(context);
    emit(SendCodeLoading());

    try {
      await _mAuth.verifyPhoneNumber(
        phoneNumber: type == OTPTypes.register
            ? "$countryCode${phoneControllerSignUp.text}"
            : type == OTPTypes.forgotPassword
                ? "$countryCode${phoneControllerForgotPassword.text}"
                : "$countryCode${phoneControllerAddPhone.text}",
        verificationCompleted: (PhoneAuthCredential credential) {
          smsCode = credential.smsCode;
          if (smsCode != null) {
            emit(OnSmsCodeSent(smsCode!));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          Navigator.pop(context);

          emit(CheckCodeInvalidCode());
          errorGetBar("Error: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          this.resendToken = resendToken;
          emit(OnSmsCodeSent(''));
          log("Verification ID: $verificationId");

          Navigator.pop(context);
          Navigator.pushNamed(context, Routes.otpRoute, arguments: type);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
          log("Auto-retrieval timeout. Verification ID: $verificationId");
        },
      );
    } catch (error) {
      Navigator.pop(context);
      errorGetBar(error.toString());
      emit(CheckCodeInvalidCode());
    }
  }

  Future<void> verifyOtp(BuildContext context,
      {OTPTypes type = OTPTypes.forgotPassword}) async {
    AppWidget.createProgressDialog(context); // Show loading

    try {
      // Create credentials
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text,
      );

      // Sign in with credentials
      UserCredential userCredential =
          await _mAuth.signInWithCredential(credential);

      debugPrint("UserCredential: ${userCredential.toString()}");

      // Ensure user exists
      if (userCredential.user == null) {
        throw Exception("User credential is null");
      }

      Navigator.pop(context);
      emit(CheckCodeSuccessfully());
      debugPrint("OTP verification successful");

      if (type == OTPTypes.register) {
        register(context);
      } else if (type == OTPTypes.forgotPassword) {
        Navigator.pushReplacementNamed(context, Routes.newPasswordRoute);
      } else if (type == OTPTypes.addPhone) {
       addPhone(context);
      }
    } catch (error) {
      // Dismiss progress dialog
      Navigator.pop(context);

      log("Error: $error");
      errorGetBar(error.toString());

      emit(CheckCodeErrorfully());
    }
  }

// Sign in with google
  String userGmail = '';
  String userPhoto = '';
  String userName = '';
  String? accessToken = '';

  /// Social Login

  Future<void> signInWithGoogle(BuildContext context) async {
    // Future<UserCredential?> signInWithGoogle() async {
    try {
      log("Starting Google Sign-In process");

      // Sign out first to ensure a fresh authentication
      await GoogleSignIn().signOut();

      // Trigger the authentication flow
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'openid',
        ],
      );

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        log("Google Sign-In canceled by user");
        return null;
      }
      userGmail = googleUser.email;
      userName = googleUser.displayName ?? '';
      userPhoto = googleUser.photoUrl ?? '';
      log("Google user signed in: ${googleUser.email}");
      loginWithSocial(context, type: 'google');
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // log("Google auth tokens obtained: accessToken=${googleAuth.accessToken != null}, idToken=${googleAuth.idToken != null}");
      log("Google auth tokens: accessToken=${googleAuth.accessToken}, idToken=${googleAuth.idToken}");

      // // Create a new credential
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      // log("Google credential created, attempting Firebase sign-in");
      // accessToken = googleAuth.accessToken;
      // userGmail = googleUser.email;
      // userName = googleUser.displayName!;
      // userPhoto = googleUser.photoUrl!;
      // log("User Gmail: $userGmail");
      // log("User Name: $userName");
      // log("User Photo: $userPhoto");
      // // *** Alternative approach to handle the credential conversion issue ***
      // try {
      //   // Create a custom token to use for authentication
      //   final authResult =
      //       await FirebaseAuth.instance.signInWithCredential(credential);
      //   log("Firebase sign-in successful: ${authResult.user?.uid}");
      //   return authResult;
      // } catch (firebaseError) {
      //   log("Firebase authentication error: $firebaseError");

      //   // If the direct method fails, try alternative sign-in
      //   // You might need to implement a custom backend solution
      //   // that exchanges Google tokens for Firebase tokens
      //   throw firebaseError;
      // }
    } catch (e, stackTrace) {
      log("Google sign-in error: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    // Future<UserCredential> signInWithFacebook() async {
    try {
      // Clear any previous login state
      await FacebookAuth.instance.logOut();

      // Trigger fresh login flow with explicit permissions
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (loginResult.status == LoginStatus.success) {
        // Get Facebook user data first
        final userData = await FacebookAuth.instance.getUserData();
        log("Facebook user data: $userData");
        userGmail = userData['email'];
        userName = userData['name'];
        userPhoto = userData['picture']['data']['url'];
        loginWithSocial(context, type: 'facebook');
        // // Create credential with token
        // final credential = FacebookAuthProvider.credential(
        //     loginResult.accessToken!.tokenString);

        // // Sign in to Firebase with explicit error handling
        // try {
        //   final userCredential =
        //       await FirebaseAuth.instance.signInWithCredential(credential);
        //   return userCredential;
        // } catch (firebaseError) {
        //   log("Firebase authentication error: $firebaseError");
        //   throw firebaseError;
        // }
      } else {
        throw Exception("Facebook login failed: ${loginResult.message}");
      }
    } catch (e) {
      log("Facebook sign-in error: $e");
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    try {
      log("Starting Apple Sign-In...");
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: "com.topbusiness.finakapp", // Apple Service ID
          redirectUri: Uri.parse(
            "https://finak-8a4c9.firebaseapp.com/__/auth/handler",
          ),
        ),
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      log("Apple Sign-In successful!");
    } catch (e) {
      print("Apple Sign-In Error: $e");
      if (e is PlatformException) {
        log("Error code: ${e.code}");
        log("Error message: ${e.message}");
        log("Error details: ${e.details}");
      }
    }
  }
  // Future<void> signInWithApple() async {
  //   try {
  //     log("Starting Apple Sign-In process");

  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       webAuthenticationOptions: WebAuthenticationOptions(
  //         clientId:
  //             "com.topbusiness.finakapp", // Replace with your Apple Service ID
  //         redirectUri: Uri.parse(
  //           "https://finak-8a4c9.firebaseapp.com/__/auth/handler",
  //         ),
  //       ),
  //     );

  //     log("Apple user signed in: ${credential.email ?? 'No email provided'}");

  //   } catch (e, stackTrace) {
  //     log("Apple sign-in error: $e");
  //     log("Stack trace: $stackTrace");

  //   }
  // }
  // Future<UserCredential?> signInWithApple() async {
  //   try {
  //     log("Starting Apple Sign-In process");

  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       webAuthenticationOptions: WebAuthenticationOptions(
  //         clientId:
  //             "com.topbusiness.finakapp", // Replace with your Apple Service ID
  //         redirectUri: Uri.parse(
  //           "https://finak-8a4c9.firebaseapp.com/__/auth/handler",
  //         ),
  //       ),
  //     );

  //     log("Apple user signed in: ${credential.email ?? 'No email provided'}");

  //     final oauthCredential = OAuthProvider("apple.com").credential(
  //       idToken: credential.identityToken,
  //       accessToken: credential.authorizationCode,
  //     );

  //     log("Attempting Firebase authentication");

  //     final authResult =
  //         await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  //     log("Firebase sign-in successful: ${authResult.user?.uid}");
  //     return authResult;
  //   } catch (e, stackTrace) {
  //     log("Apple sign-in error: $e");
  //     log("Stack trace: $stackTrace");
  //     return null;
  //   }
  // }

  /////// API CALLS //////
  LoginModel loginModel = LoginModel();
  login(BuildContext context) async {
    emit(LoadingLoginState());
    AppWidget.createProgressDialog(context);
    final response = await api.login(
      phone: "$countryCode${phoneControllerLogin.text}",
      password: passwordControllerLogin.text,
    );
    response.fold((l) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(FailureLoginState());
    }, (r) async {
      debugPrint("code: ${r.status.toString()}");
      // successGetBar(r.data?.jwtToken);
      if (r.status != 200 && r.status != 201) {
        Navigator.pop(context);
        errorGetBar(r.msg ?? "error".tr());
      } else {
        loginModel = r;

        emit(SuccessLoginState());
        Navigator.pop(context);
        successGetBar(r.msg);
        phoneControllerLogin.clear();
        passwordControllerLogin.clear();

        await Preferences.instance.setUser(r);
        prefs.setBool("ISLOGGED", true);

        if (loginModel.data?.userType == 0) {
          // 0 for user
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.mainRoute, (route) => false);
        } else {
          errorGetBar("you_not_user".tr());
          // Navigator.pushNamedAndRemoveUntil(
          //     context, Routes.mainRoute, (route) => false);
        }
      }
    });
  }

  loginWithSocial(BuildContext context, {required String type}) async {
    emit(LoadingLoginState());
    AppWidget.createProgressDialog(context);
    final response = await api.loginWithSocial(
        type: type, name: userName, email: userGmail, imageURL: userPhoto);
    response.fold((l) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(FailureLoginState());
    }, (r) async {
      if (r.status != 200 && r.status != 201) {
        Navigator.pop(context);
        errorGetBar(r.msg ?? "error".tr());
      } else {
        loginModel = r;

        emit(SuccessLoginState());
        Navigator.pop(context);
        successGetBar(r.msg);

        await Preferences.instance.setUser(r);
        prefs.setBool("ISLOGGED", true);
        if (loginModel.data?.userType == 0) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.mainRoute, (route) => false);
        } else {
          errorGetBar("you_not_user".tr());
          // Navigator.pushNamedAndRemoveUntil(
          //     context, Routes.mainRoute, (route) => false);
        }
      }
    });
  }

  register(BuildContext context) async {
    emit(LoadingLoginState());
    AppWidget.createProgressDialog(context);
    final response = await api.register(
      phone: "$countryCode${phoneControllerSignUp.text}",
      password: passwordControllerSignUp.text,
      name: nameControllerSignUp.text,
      email: emailControllerSignUp.text,
      passwordConfirmation: confirmPasswordController.text,
    );
    response.fold((l) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(FailureLoginState());
    }, (r) async {
      debugPrint("code: ${r.status.toString()}");
      // successGetBar(r.data?.jwtToken);
      if (r.status != 200 && r.status != 201) {
        Navigator.pop(context);
        errorGetBar(r.msg ?? "error".tr());
      } else {
        loginModel = r;

        emit(SuccessLoginState());
        Navigator.pop(context);
        successGetBar(r.msg);
        phoneControllerSignUp.clear();
        passwordControllerSignUp.clear();
        confirmPasswordController.clear();
        nameControllerSignUp.clear();
        emailControllerSignUp.clear();

        await Preferences.instance.setUser(r);
        prefs.setBool("ISLOGGED", true);
        if (loginModel.data?.userType == 0) {
          // 0 for user
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.mainRoute, (route) => false);
        } else {
          errorGetBar("you_not_user".tr());
          // Navigator.pushNamedAndRemoveUntil(
          //     context, Routes.mainRoute, (route) => false);
        }
      }
    });
  }

  resetPassword(BuildContext context) async {
    emit(LoadingLoginState());
    AppWidget.createProgressDialog(context);
    final response = await api.resetPassword(
      phone: "$countryCode${phoneControllerForgotPassword.text}",
      password: newPasswordController.text,
      passwordConfirmation: confirmNewPasswordController.text,
    );
    response.fold((l) {
      Navigator.pop(context);
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(FailureLoginState());
    }, (r) async {
      debugPrint("code: ${r.status.toString()}");
      Navigator.pop(context);
      if (r.status != 200 && r.status != 201) {
        Navigator.pop(context);
        errorGetBar(r.msg ?? "error".tr());
      } else {
        loginModel = r;
        emit(SuccessLoginState());
        successGetBar(r.msg);
        phoneControllerForgotPassword.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.loginRoute, (route) => false);
      }
    });
  }

  addPhone(BuildContext context) async {
    emit(LoadingLoginState());
    AppWidget.createProgressDialog(context);
    final response = await api.addPhone(
      phone: "$countryCode${phoneControllerAddPhone.text}",
    );
    response.fold((l) {
      Navigator.pop(context);
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(FailureLoginState());
    }, (r) async {
      debugPrint("code: ${r.status.toString()}");
      Navigator.pop(context);
      if (r.status != 200 && r.status != 201) {
        Navigator.pop(context);
        errorGetBar(r.msg ?? "error".tr());
      } else {
        emit(SuccessLoginState());
        successGetBar(r.msg);
        phoneControllerAddPhone.clear();
        context.read<ProfileCubit>().getProfile();

        Navigator.pop(context);
        Navigator.pop(context);
      }
    });
  }
}
