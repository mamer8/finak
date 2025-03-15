import 'package:finak/core/exports.dart';

PreferredSizeWidget customAppBar(BuildContext context,
    {String title = '', VoidCallback? onBack}) {
  return AppBar(
    backgroundColor: AppColors.white,
    elevation: 0,

    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)), // Rounded bottom corners
    // ),
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios_sharp,
        color: AppColors.black,
      ),
      padding: EdgeInsets.zero,
      onPressed: onBack ?? () => Navigator.pop(context),
    ),
    title: Text(
      title,
      style: getBoldStyle(
        fontSize: 20.sp,
      ),
    ),
  );
}
