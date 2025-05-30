import 'package:finak/core/exports.dart';
import 'package:finak/features/services/data/models/service_types_model.dart';

class CustomCategoryContainer extends StatelessWidget {
  const CustomCategoryContainer({
    this.isSelected = false,
    super.key,
    required this.model,
    this.onTap,
  });
  final bool isSelected;
  final ServiceTypeModel model;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            color: isSelected ? AppColors.primary : AppColors.secondGrey,
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Row(
            children: [
              CustomNetworkImage(
                image: model.image ?? "",
                width: 40.w,
                height: 40.w,
              ),
              5.w.horizontalSpace,
              Text(
                model.name ?? "",
                style: getMediumStyle(color: AppColors.white, fontSize: 18.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
