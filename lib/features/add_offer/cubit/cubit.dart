import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class AddOfferCubit extends Cubit<AddOfferState> {
  AddOfferCubit(this.api) : super(AddOfferInitial());

  AddOfferRepo api;

  /// pick image from gallery or camera

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
                pickImages(context, true);
              },
              child: Text(
                'gallery'.tr(),
                style:
                    getRegularStyle(fontSize: 12.sp, color: AppColors.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                pickImages(context, false);
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

  // removeImage(File file) {
  //   uploadedImage.remove(file);

  //   emit(FileRemovedSuccessfully());
  // }

  // List<File> uploadedImage = [];

  // Future pickImage(BuildContext context, bool isGallery) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(
  //       source: isGallery ? ImageSource.gallery : ImageSource.camera);

  //   if (pickedFile != null) {
  //     uploadedImage.add(File(pickedFile.path));

  //     emit(FilePickedSuccessfully());
  //   } else {
  //     emit(FileNotPicked());
  //   }
  //   Navigator.pop(context);
  // }

  List<File> uploadedImages = [];

  Future<void> pickImages(BuildContext context, bool isGallery) async {
    final picker = ImagePicker();

    if (isGallery) {
      final List<XFile>? pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        uploadedImages.addAll(pickedFiles.map((file) => File(file.path)));
        emit(FilePickedSuccessfully());
      } else {
        emit(FileNotPicked());
      }
    } else {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        uploadedImages.add(File(pickedFile.path));
        emit(FilePickedSuccessfully());
      } else {
        emit(FileNotPicked());
      }
    }

    Navigator.pop(context);
  }

  removeImage(File file) {
    uploadedImages.remove(file);

    emit(FileRemovedSuccessfully());
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ServicesModel? selectedService;
  void onTapToSelectService(ServicesModel ser) {
    selectedService = ser;
    emit(SelectServiceState());
  }

  CategoryModel? selectedCategory;
  void onTapToSelectCategory(CategoryModel cat) {
    selectedCategory = cat;
    emit(SelectServiceState());
  }

  List<ServicesModel> services = [
    ServicesModel(id: '1', name: 'Electricity'),
    ServicesModel(id: '2', name: 'Gas'),
    ServicesModel(id: '3', name: 'Water'),
  ];

  List<CategoryModel> categories = [
    CategoryModel(id: '1', name: 'Rent'),
    CategoryModel(id: '2', name: 'Buy'),
  ];
}

class ServicesModel {
  String id;
  String name;
  ServicesModel({required this.id, required this.name});
}

class CategoryModel {
  String id;
  String name;
  CategoryModel({required this.id, required this.name});
}
