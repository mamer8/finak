import 'dart:developer';

import 'package:finak/core/exports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
}
