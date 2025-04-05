import 'package:finak/core/exports.dart';
import 'package:finak/features/location/cubit/location_cubit.dart';
import 'package:finak/features/location/screens/position_map.dart';
import 'package:finak/features/profile/cubit/cubit.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/images_container.dart';
import 'widgets/phone_check_box.dart';
import 'widgets/select_category.dart';
import 'widgets/select_service.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({
    super.key,
  });

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  @override
  void initState() {
    if (context.read<AddOfferCubit>().serviceTypesModel.data == null) {
      context.read<AddOfferCubit>().getServiceTypes();
    }
    super.initState();
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: 'add_offer'.tr()),
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
                const ImagesWidegt(),
                10.verticalSpace,
                CustomTextField(
                  title: 'title'.tr(),
                  controller: c.titleController,
                  labelText: 'enter_title'.tr(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter_title'.tr();
                    }
                    return null;
                  },
                ),
                10.verticalSpace,
                const SelectServiceWidget(),
                10.verticalSpace,
                const SelectCategoryWidget(),
                if (c.selectedService?.needPrice == 1) ...[
                  10.verticalSpace,
                  CustomTextField(
                    title: 'price'.tr(),
                    isOptional: true,
                    controller: c.priceController,
                    labelText: 'enter_price'.tr(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  )
                ],
                10.verticalSpace,
                CustomTextField(
                  title: 'description'.tr(),
                  isMessage: true,
                  controller: c.descriptionController,
                  labelText: 'enter_description'.tr(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter_description'.tr();
                    }
                    return null;
                  },
                ),
                10.verticalSpace,
                const PositionMap(),
                10.verticalSpace,
                CustomPhoneCheckBox(),
                30.verticalSpace,
                CustomButton(
                  title: "add".tr(),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (c.uploadedImages.isEmpty) {
                        errorGetBar('add_images'.tr());
                        return;
                      } else if (c.selectedService == null) {
                        errorGetBar('select_service'.tr());
                      } else if (c.selectedCategory == null) {
                        errorGetBar('select_category'.tr());
                      } else if (context
                              .read<LocationCubit>()
                              .selectedLocation ==
                          null) {
                        errorGetBar('select_location'.tr());
                      } else {
                        c.addOffer(context,
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
