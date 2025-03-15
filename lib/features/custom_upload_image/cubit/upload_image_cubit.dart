import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finak/core/exports.dart';
import 'package:permission_handler/permission_handler.dart';

import 'upload_image_state.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageInitial());

  File? profileImage;
  String selectedBase64String = "";

  /// هنستدعي دي في كل صفحة بستديعها
  /// Remove the selected image or file
  void removeImage() {
    profileImage = null;
    selectedBase64String = "";
    emit(FileRemovedSuccessfully());
  }

  /// Show a dialog to choose between file, gallery, or camera
  void showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'choose'.tr(),
            style: getMediumStyle(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => pickFile(context),
              child: Text(
                'file'.tr(),
                style: getRegularStyle(),
              ),
            ),
            TextButton(
              onPressed: () async => pickImageWithPermission(context),
              child: Text(
                "camera".tr(),
                style: getRegularStyle(),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Handle permissions and pick image from the camera
  Future<void> pickImageWithPermission(BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      pickImage(context, isGallery: false);
    } else {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        pickImage(context, isGallery: false);
      } else {
        emit(UpdateProfileError());
        Navigator.pop(context);
      }
    }
  }

  /// Pick image from gallery or camera
  Future<void> pickImage(BuildContext context,
      {required bool isGallery}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: isGallery ? ImageSource.gallery : ImageSource.camera,
      );
      if (pickedFile != null) {
        await _handlePickedFile(pickedFile);
      } else {
        emit(FilePickCancelled());
      }
    } catch (e) {
      emit(UpdateProfileError());
    } finally {
      Navigator.pop(context);
    }
  }

  /// Pick any file
  Future<void> pickFile(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickMedia();
      if (pickedFile != null) {
        await _handlePickedFile(pickedFile);
      } else {
        emit(FilePickCancelled());
      }
    } catch (e) {
      emit(UpdateProfileError());
    } finally {
      Navigator.pop(context);
    }
  }

  /// Handle selected file and convert it to Base64
  Future<void> _handlePickedFile(XFile pickedFile) async {
    profileImage = File(pickedFile.path);
    selectedBase64String = await fileToBase64String(pickedFile.path);
    emit(UpdateProfileImagePicked());
  }

  /// Convert file to Base64 string
  Future<String> fileToBase64String(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      emit(UpdateProfileError());
      return "";
    }
  }
}
