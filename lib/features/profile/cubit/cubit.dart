import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this.api) : super(ProfileInitial());

  ProfileRepo api;
  GlobalKey<FormState> formKeyProfile = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyChangePassword = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
}
