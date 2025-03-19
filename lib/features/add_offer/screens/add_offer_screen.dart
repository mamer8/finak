import 'package:finak/core/exports.dart';
import 'package:finak/features/location/screens/position_map.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/images_container.dart';
import 'widgets/select_category.dart';
import 'widgets/select_service.dart';

class AddOfferScreen extends StatelessWidget {
  const AddOfferScreen({
    super.key,
  });

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
              child: Column(
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
              30.verticalSpace,
              CustomButton(title: "add".tr()),
              10.verticalSpace,
            ],
          )),
        );
      }),
    );
  }
}
