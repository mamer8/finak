import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:finak/core/exports.dart';

import '../cubit/upload_image_cubit.dart';
import '../cubit/upload_image_state.dart';

class ImageCustom extends StatefulWidget {
  const ImageCustom({super.key, this.color, this.title});
  final String? title;
  final Color? color;
  @override
  State<ImageCustom> createState() => _ImageCustomState();
}

class _ImageCustomState extends State<ImageCustom> {
  @override
  void initState() {
    context.read<UploadImageCubit>().removeImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<UploadImageCubit>();

    return BlocBuilder<UploadImageCubit, UploadImageState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          child: GestureDetector(
            onTap: () {
              cubit.showImageSourceDialog(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.sp),
                        topRight: Radius.circular(8.sp),
                      ),
                      color: widget.color ?? AppColors.primary.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                          widget.title ??
                              "pictures_related_to_the_requested_service".tr(),
                          style: getRegularStyle()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0.sp),
                    child: DottedBorder(
                      color: Colors.black.withOpacity(0.2),
                      strokeWidth: 1,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(8),
                      dashPattern: [12, 3],
                      child: Container(
                        height: 150.h,
                        child: Stack(
                          children: [
                            // Display either the placeholder or the uploaded image
                            cubit.profileImage == null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.cloud_upload_outlined,
                                            size: 40.sp,
                                            color: AppColors.primary),
                                        SizedBox(height: 10.h),
                                        Text(
                                          'ارفع الصورة أو الملف'.tr(),
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.file(
                                      File(cubit.profileImage!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 150.h,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(20.sp),
                                          child: Image.asset(
                                            ImageAssets.logoImage,
                                            color: AppColors.primary,
                                            width: 40.w,
                                            height: 40.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            // Show remove button only if an image is uploaded
                            if (cubit.profileImage != null)
                              Positioned(
                                top: 10.h,
                                right: 10.w,
                                child: GestureDetector(
                                  onTap: cubit.removeImage,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 15.r,
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
