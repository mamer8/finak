import 'dart:io';

import 'package:finak/core/utils/appwidget.dart';
import 'package:finak/features/location/cubit/location_cubit.dart';
import 'package:finak/features/services/cubit/cubit.dart';
import 'package:finak/features/services/data/models/service_types_model.dart';
import 'package:finak/features/services/data/models/sub_service_types_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController updatedtitleController = TextEditingController();
  TextEditingController updatedpriceController = TextEditingController();
  TextEditingController updateddescriptionController = TextEditingController();
  TextEditingController updatedserviceTypeController = TextEditingController();
  TextEditingController updatedcategoryController = TextEditingController();
  void addUpdateController(
    String title,
    String price,
    String description,
    String serviceType,
    String category,
  ) {
    updatedtitleController.text = title;
    updatedpriceController.text = price;
    updateddescriptionController.text = description;
    updatedserviceTypeController.text = serviceType;
    updatedcategoryController.text = category;
    emit(UpdateControllerState());
  }

  /// Clear Update Controllers
  void clearUpdatedControllers() {
    updatedtitleController.clear();
    updatedpriceController.clear();
    updateddescriptionController.clear();
    updatedserviceTypeController.clear();
    updatedcategoryController.clear();
  }

  ServiceTypeModel? selectedService;
  void onTapToSelectService(ServiceTypeModel ser) {
    selectedService = ser;
    emit(SelectServiceState());
    getSubServiceTypes(ser.id.toString());
  }

  SubServiceTypeModel? selectedCategory;
  void onTapToSelectCategory(SubServiceTypeModel cat) {
    selectedCategory = cat;
    emit(SelectServiceState());
  }

  /// Get Service Types //////
  GetServiceTypesModel serviceTypesModel = GetServiceTypesModel();
  void getServiceTypes() async {
    serviceTypesModel = GetServiceTypesModel();
    subServiceTypesModel = GetSubServiceTypesModel();
    selectedCategory = null;
    selectedService = null;
    emit(GetServiceTypesLoadingState());
    var response = await api.getServiceTypes();
    response.fold(
      (failure) {
        emit(GetServiceTypesErrorState());
      },
      (r) {
        serviceTypesModel = r;
        emit(GetServiceTypesSuccessState());
      },
    );
  }

  /// Get Sub Service Types //////
  GetSubServiceTypesModel subServiceTypesModel = GetSubServiceTypesModel();
  void getSubServiceTypes(String serviceTypeId) async {
    selectedCategory = null;
    subServiceTypesModel = GetSubServiceTypesModel();
    emit(GetSubServiceTypesLoadingState());
    var response = await api.getSubServiceTypes(serviceTypeId);
    response.fold(
      (failure) {
        emit(GetSubServiceTypesErrorState());
      },
      (r) {
        subServiceTypesModel = r;
        emit(GetSubServiceTypesSuccessState());
      },
    );
  }

  addOffer(BuildContext context, {required bool isPhoneHide}) async {
    emit(LoadingAddOfferState());
    AppWidget.createProgressDialog(context);
    final response = await api.addOffer(
      serviceTypeId: selectedService?.id.toString() ?? "",
      subServiceTypeId: selectedCategory?.id.toString() ?? "",
      country: context.read<LocationCubit>().country,
      lat:
          context.read<LocationCubit>().selectedLocation?.latitude.toString() ??
              "0",
      long: context
              .read<LocationCubit>()
              .selectedLocation
              ?.longitude
              .toString() ??
          "0",
      locationName: context.read<LocationCubit>().address,
      media: uploadedImages.map((e) => e.path).toList(),
      price: selectedService?.needPrice == 1 ? priceController.text : "",
      description: descriptionController.text,
      title: titleController.text,
      isPhoneHide: isPhoneHide ? "1" : "0",
    );
    response.fold((l) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(FailureAddOfferState());
    }, (r) async {
      debugPrint("code: ${r.status.toString()}");
      // successGetBar(r.data?.jwtToken);
      if (r.status != 200 && r.status != 201) {
        Navigator.pop(context);
        errorGetBar(r.msg ?? "error".tr());
      } else {
        emit(SuccessAddOfferState());
        Navigator.pop(context);
        successGetBar(r.msg);
        clearDate();
        Navigator.pushReplacementNamed(context, Routes.myOffersRoute);
        context.read<LocationCubit>().setSelectedPositionedLocationToDefault();
      }
    });
  }

  updateOffer(BuildContext context,
      {required bool isPhoneHide, required String offerId}) async {
    emit(LoadingAddOfferState());
    AppWidget.createProgressDialog(context);
    final response = await api.updateOffer(
      offerId: offerId,
      country: context.read<LocationCubit>().country,
      lat:
          context.read<LocationCubit>().selectedLocation?.latitude.toString() ??
              "0",
      long: context
              .read<LocationCubit>()
              .selectedLocation
              ?.longitude
              .toString() ??
          "0",
      locationName: context.read<LocationCubit>().address,
      media: uploadedImages.map((e) => e.path).toList(),
      price: updatedpriceController.text,
      description: updateddescriptionController.text,
      title: updatedtitleController.text,
      isPhoneHide: isPhoneHide ? "1" : "0",
    );
    response.fold((l) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(FailureAddOfferState());
    }, (r) async {
      debugPrint("code: ${r.status.toString()}");

      if (r.status != 200 && r.status != 201) {
        Navigator.pop(context);
        errorGetBar(r.msg ?? "error".tr());
      } else {
        context.read<ServicesCubit>().getServiceDetails(
              offerId: offerId,
            );
        emit(SuccessAddOfferState());
        Navigator.pop(context);
        Navigator.pop(context);
        successGetBar(r.msg);
        clearUpdatedControllers();
        context.read<LocationCubit>().setSelectedPositionedLocationToDefault();
      }
    });
  }

  clearDate() {
    titleController.clear();
    priceController.clear();
    descriptionController.clear();
    uploadedImages.clear();
    selectedService = null;
    selectedCategory = null;
  }
}
