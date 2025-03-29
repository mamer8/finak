import 'dart:io';

import 'package:finak/core/preferences/preferences.dart';
import 'package:finak/core/utils/appwidget.dart';
import 'package:finak/features/Auth/data/models/login_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.api) : super(ProfileInitial());

  ProfileRepo api;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String countryCode = '+20';

  /// picker

  File? profileImage;
  removeImage() {
    profileImage = null;

    emit(FileRemovedSuccessfully());
  }

  Future pickImage(BuildContext context, bool isGallery) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);

      changeProfile(true);
      emit(FilePickedSuccessfully());
    } else {
      emit(FileNotPicked());
    }
    Navigator.pop(context);
  }

  void showImageSourceDialog(
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'select_image'.tr(),
            style: getMediumStyle(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                pickImage(context, true);
              },
              child: Text(
                'gallery'.tr(),
                style:
                    getRegularStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                pickImage(context, false);
              },
              child: Text(
                "camera".tr(),
                style:
                    getRegularStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  bool hidePhone = false;
  void changeHidePhone(bool value) {
    hidePhone = value;
    emit(HidePhoneChangedSuccessfully());
  }

  LoginModel loginModel = LoginModel();
  getProfile() async {
    if (AppConst.isLogged) {
      emit(GetAccountLoading());
      final res = await api.getProfile();
      res.fold((l) {
        emit(GetAccountError());
      }, (r) {
        if (r.status == 200 || r.status == 201) {
          loginModel = r;
          storeFCM();
          if (r.data != null) {
            nameController.text = r.data!.name ?? '';
            emailController.text = r.data!.email ?? '';
            phoneController.text = r.data!.phone ?? '';
            // hidePhone = r.data!.hidePhone ?? false;
            changeProfile(false);
          }
        } else if (r.status == 401 || r.status == 407 || r.status == 403) {
          prefs.setBool("ISLOGGED", false);
          // AppConst.isLogged = false;
          Preferences.instance.clearUser();
        }
        emit(GetAccountSuccess());
      });
    }
  }

  storeFCM() async {
    emit(GetAccountLoading());
    final response = await api.storeFcm();
    response.fold((l) {
      emit(GetAccountError());
    }, (r) {
      emit(GetAccountSuccess());
    });
  }

  bool isProfileChanged = false;
  void changeProfile(bool value) {
    isProfileChanged = value;
    emit(ProfileChangedSuccessfully());
  }

  updateUserData(
    BuildContext context,
  ) async {
    AppWidget.createProgressDialog(
      context,
    );
    emit(GetAccountLoading());
    final res = await api.updateUserData(
        name: nameController.text,
        email: emailController.text,
        imagePath: profileImage?.path);
    res.fold((l) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(GetAccountError());
    }, (r) {
      Navigator.pop(context);
      if (r.status == 200 || r.status == 201) {
        loginModel = r;
        profileImage = null;
        changeProfile(false);
        if (r.data != null) {
          // nameController.text = r.data!.name!;
        }
        Navigator.pop(context);
        successGetBar(r.msg);
      } else if (r.status == 401 || r.status == 407 || r.status == 403) {
        errorGetBar(r.msg ?? "error".tr());
      }

      emit(GetAccountSuccess());
    });
  }

  updatePassword(BuildContext context) async {
    AppWidget.createProgressDialog(
      context,
    );
    emit(GetAccountLoading());
    final res = await api.updatepassword(
        currentPassword: passwordController.text,
        newPassword: newpasswordController.text,
        confirmPassword: confirmPasswordController.text);
    res.fold((l) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(GetAccountError());
    }, (r) {
      Navigator.pop(context);
      if (r.status == 200 || r.status == 201) {
        passwordController.clear();
        newpasswordController.clear();
        confirmPasswordController.clear();

        Navigator.pop(context);
        Navigator.pop(context);
        successGetBar(r.msg);
      } else if (r.status == 401 ||
          r.status == 407 ||
          r.status == 403 ||
          r.status == 400 ||
          r.status == 422) {
        errorGetBar(r.msg ?? "error".tr());
      }
      emit(GetAccountSuccess());
    });
  }
}
