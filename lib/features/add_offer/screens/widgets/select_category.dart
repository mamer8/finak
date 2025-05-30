import 'package:finak/core/exports.dart';
import 'package:finak/features/add_offer/cubit/cubit.dart';
import 'package:finak/features/services/data/models/sub_service_types_model.dart';

import '../../cubit/state.dart';

class SelectCategoryWidget extends StatefulWidget {
  const SelectCategoryWidget({super.key});

  @override
  State<SelectCategoryWidget> createState() => _SelectCategoryWidgetState();
}

class _SelectCategoryWidgetState extends State<SelectCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddOfferCubit, AddOfferState>(
      builder: (context, state) {
        var cubit = context.read<AddOfferCubit>();
        return cubit.serviceTypesModel.data == null
            ? SizedBox(
                height: 10.h,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text("${"category".tr()} *",
                        style: getBoldStyle(fontSize: 18.sp)),
                  ),
                  if (state is GetSubServiceTypesLoadingState)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: LinearProgressIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.white,
                      ),
                    ),
                  if (cubit.subServiceTypesModel.data != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: CategoryDropDownWidget(),
                    )
                ],
              );
      },
    );
  }
}

class CategoryDropDownWidget extends StatefulWidget {
  const CategoryDropDownWidget({super.key});

  @override
  _CategoryDropDownWidgetState createState() => _CategoryDropDownWidgetState();
}

class _CategoryDropDownWidgetState extends State<CategoryDropDownWidget> {
  bool? isDropDown = true; // Control whether the dropdown appears

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddOfferCubit, AddOfferState>(builder: (context, state) {
      var cubit = context.read<AddOfferCubit>();
      return Container(
        // height: 40.h,
        // padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            // border: Border.all(color: Colors.white),
            color: AppColors.textFiledBG),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<SubServiceTypeModel>(
            value: cubit.selectedCategory,
            hint: Text(
              'choose'.tr(),
              style: getRegularStyle(color: AppColors.black, fontSize: 14.sp),
            ),
            icon: Padding(
              padding: EdgeInsetsDirectional.only(end: 8.0.w),
              child: Icon(Icons.keyboard_arrow_down, color: AppColors.black),
            ),
            isExpanded: true,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1.h),
            onChanged: (SubServiceTypeModel? newValue) {
              cubit.onTapToSelectCategory(newValue!);
            },
            items: cubit.subServiceTypesModel.data
                ?.map<DropdownMenuItem<SubServiceTypeModel>>(
                    (SubServiceTypeModel value) {
              return DropdownMenuItem<SubServiceTypeModel>(
                value: value,
                child: Text(
                  value.name ?? '',
                  // maxLines: 1,
                  // overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(),
                ),
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}
