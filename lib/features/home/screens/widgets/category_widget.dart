import 'package:finak/core/exports.dart';

class CustomCategoryContainer extends StatelessWidget {
  const CustomCategoryContainer({
    this.isSelected = false,
    super.key,
  });
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: isSelected ? AppColors.primary : AppColors.secondGrey,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          Icon(
            Icons.card_travel_sharp,
            color: AppColors.white,
            size: 20.w,
          ),
          5.w.horizontalSpace,
          Text(
            "Category ",
            style: getMediumStyle(color: AppColors.white, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
