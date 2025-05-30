import 'package:finak/core/exports.dart';
import 'package:finak/features/location/cubit/location_cubit.dart';
import 'package:finak/features/location/screens/position_map.dart';
import 'package:finak/features/profile/cubit/cubit.dart';
import 'package:finak/features/services/data/models/get_service_details_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/edit_upload_image_widget copy.dart';
import 'widgets/phone_check_box.dart';

class UpdateOfferScreen extends StatefulWidget {
  const UpdateOfferScreen({
    super.key,
    this.serviceDataModel,
  });
  final ServiceDataModel? serviceDataModel;
  @override
  State<UpdateOfferScreen> createState() => _UpdateOfferScreenState();
}

class _UpdateOfferScreenState extends State<UpdateOfferScreen> {
  @override
  void initState() {
    super.initState();

    final model = widget.serviceDataModel;

    if (model != null) {
      final latitude = double.tryParse(model.lat ?? '') ?? 0.0;
      final longitude = double.tryParse(model.long ?? '') ?? 0.0;

      context.read<LocationCubit>().setSelectedPositionedLocation(
            LatLng(latitude, longitude),
            context,
          );

      context.read<AddOfferCubit>().addUpdateController(
            model.title ?? '',
            model.price != null ? model.price.toString() : '',
            model.body ?? '',
            model.serviceType ?? '',
            model.subServiceType ?? '',
          );

      context.read<ProfileCubit>().isPhoneHide = model.isPhoneHide == 1;
    }
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: 'update_offer'.tr()),
      body:
          BlocBuilder<AddOfferCubit, AddOfferState>(builder: (context, state) {
        var c = context.read<AddOfferCubit>();
        return Padding(
          padding: EdgeInsets.all(12.w),
          child: SingleChildScrollView(
              child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomEditUploadImageWidget(),
                10.verticalSpace,
                CustomTextField(
                  title: 'title'.tr(),
                  controller: c.updatedtitleController,
                  hintText: 'enter_title'.tr(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter_title'.tr();
                    }
                    return null;
                  },
                ),
                10.verticalSpace,
                CustomTextField(
                  title: 'service_type'.tr(),
                  enabled: false,
                  controller: c.updatedserviceTypeController,
                  // hintText: ''.tr(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter_title'.tr();
                    }
                    return null;
                  },
                ),
                10.verticalSpace,
                CustomTextField(
                  title: 'service_type'.tr(),
                  enabled: false,
                  controller: c.updatedcategoryController,
                  // hintText: ''.tr(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter_title'.tr();
                    }
                    return null;
                  },
                ),
                if (widget.serviceDataModel?.price != null) ...[
                  10.verticalSpace,
                  CustomTextField(
                    title: 'price'.tr(),
                    isOptional: true,
                    controller: c.updatedpriceController,
                    hintText: 'enter_price'.tr(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  )
                ],
                10.verticalSpace,
                CustomTextField(
                  title: 'description'.tr(),
                  isMessage: true,
                  controller: c.updateddescriptionController,
                  hintText: 'enter_description'.tr(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter_description'.tr();
                    }
                    return null;
                  },
                ),
                10.verticalSpace,
                const PositionMap(
                  isUpdate: true,
                ),
                10.verticalSpace,
                CustomPhoneCheckBox(),
                30.verticalSpace,
                CustomButton(
                  title: "add".tr(),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // if (c.uploadedImages.isEmpty) {
                      //   errorGetBar('add_images'.tr());
                      //   return;
                      // } else
                      if (context.read<LocationCubit>().selectedLocation ==
                          null) {
                        errorGetBar('select_location'.tr());
                      } else {
                        c.updateOffer(context,
                            offerId:
                                widget.serviceDataModel?.id.toString() ?? '',
                            isPhoneHide:
                                context.read<ProfileCubit>().isPhoneHide);
                      }
                    }
                  },
                ),
                10.verticalSpace,
              ],
            ),
          )),
        );
      }),
    );
  }
}
