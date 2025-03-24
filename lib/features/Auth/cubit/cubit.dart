import 'dart:developer';

import 'package:finak/core/exports.dart';
import 'package:finak/core/utils/appwidget.dart';
import 'package:finak/core/utils/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  final FirebaseAuth _mAuth = FirebaseAuth.instance;
  String? verificationId;
  String? smsCode;
  int? resendToken;

  String countryCode = '+20';
  String phone = "+201027639683";
  Future<void> sendOTP(BuildContext context, {bool isRegister = true}) async {
    AppWidget.createProgressDialog(context);
    emit(SendCodeLoading());

    try {
      await _mAuth.verifyPhoneNumber(
        phoneNumber: isRegister
            ? "$countryCode${phoneControllerSignUp.text}"
            : "$countryCode${phoneControllerForgotPassword.text}",
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

          // Navigate **only if OTP is successfully sent**
          Navigator.pop(context);
          Navigator.pushNamed(context, Routes.otpRoute, arguments: isRegister);
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

  Future<void> verifyOtp(BuildContext context, {bool isRegister = true}) async {
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

      // Dismiss progress dialog
      Navigator.pop(context);
      emit(CheckCodeSuccessfully());
      debugPrint("OTP verification successful");

      // Navigate to respective screen
      if (isRegister) {
        Navigator.pushNamed(context, Routes.mainRoute);
      } else {
        Navigator.pushNamed(context, Routes.newPasswordRoute);
      }
    } catch (error) {
      // Dismiss progress dialog
      Navigator.pop(context);

      // Log error and show UI message
      log("Error: $error");
      errorGetBar(error.toString());

      // Emit failure state
      emit(CheckCodeErrorfully());
    }
  }

  /// Social Login

  Future<UserCredential?> signInWithGoogle() async {
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

      log("Google user signed in: ${googleUser.email}");

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // log("Google auth tokens obtained: accessToken=${googleAuth.accessToken != null}, idToken=${googleAuth.idToken != null}");
      log("Google auth tokens: accessToken=${googleAuth.accessToken}, idToken=${googleAuth.idToken}");

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      log("Google credential created, attempting Firebase sign-in");
      accessToken = googleAuth.accessToken;
      userGmail = googleUser.email;
      userName = googleUser.displayName!;
      userPhoto = googleUser.photoUrl!;
      log("User Gmail: $userGmail");
      log("User Name: $userName");
      log("User Photo: $userPhoto");
      // *** Alternative approach to handle the credential conversion issue ***
      try {
        // Create a custom token to use for authentication
        final authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        log("Firebase sign-in successful: ${authResult.user?.uid}");
        return authResult;
      } catch (firebaseError) {
        log("Firebase authentication error: $firebaseError");

        // If the direct method fails, try alternative sign-in
        // You might need to implement a custom backend solution
        // that exchanges Google tokens for Firebase tokens
        throw firebaseError;
      }
    } catch (e, stackTrace) {
      log("Google sign-in error: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }

  // Sign in with google
  String userGmail = '';
  String userPhoto = '';
  String userName = '';
  String? accessToken = '';

  Future<UserCredential> signInWithFacebook() async {
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

        // Create credential with token
        final credential = FacebookAuthProvider.credential(
            loginResult.accessToken!.tokenString);

        // Sign in to Firebase with explicit error handling
        try {
          final userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          return userCredential;
        } catch (firebaseError) {
          log("Firebase authentication error: $firebaseError");
          throw firebaseError;
        }
      } else {
        throw Exception("Facebook login failed: ${loginResult.message}");
      }
    } catch (e) {
      log("Facebook sign-in error: $e");
      rethrow;
    }
  }

//  Future<UserCredential> signInWithApple() async {
//   final appleProvider = AppleAuthProvider();
//   // if (kIsWeb) {
//     // await FirebaseAuth.instance.signInWithPopup(appleProvider);
//   // } else {
//     await FirebaseAuth.instance.signInWithProvider(appleProvider);
//   // }
//   return await FirebaseAuth.instance.signInWithProvider(appleProvider);
// }

  Future<UserCredential?> signInWithApple() async {
    try {
      log("Starting Apple Sign-In process");

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId:
              "com.topbusiness.finak", // Replace with your Apple Service ID
          redirectUri: Uri.parse(
            "https://finak-8a4c9.firebaseapp.com/__/auth/handler",
          ),
        ),
      );

      log("Apple user signed in: ${credential.email ?? 'No email provided'}");

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      log("Attempting Firebase authentication");

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      log("Firebase sign-in successful: ${authResult.user?.uid}");
      return authResult;
    } catch (e, stackTrace) {
      log("Apple sign-in error: $e");
      log("Stack trace: $stackTrace");
      return null;
    }
  }
}
