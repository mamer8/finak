import 'package:dotted_border/dotted_border.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/features/add_offer/cubit/cubit.dart';
import 'package:finak/features/add_offer/cubit/state.dart';

import 'custom_upload_decument.dart';
import 'custom_uploaded_image.dart';

class ImagesWidegt extends StatelessWidget {
  const ImagesWidegt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AddOfferCubit cubit = context.read<AddOfferCubit>();

    return BlocBuilder<AddOfferCubit, AddOfferState>(builder: (context, state) {
      return Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey2)),
        child: Column(children: [
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              color: AppColors.primary.withOpacity(0.2),
            ),
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "serviceImages".tr(),
                    style: getBoldStyle(fontSize: 18.sp),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 50),
            child: Wrap(
              direction: Axis.horizontal,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                  child: GestureDetector(
                    onTap: () {
                      if (cubit.uploadedImages.length < 7) {
                        cubit.showImageSourceDialog(
                          context,
                        );
                      } else {
                        errorGetBar("لقد تعديت الحد الاقصى");
                      }
                    },
                    child: CustomDocumentWidget(),
                  ),
                ),
                ...cubit.uploadedImages.map(
                  (e) => Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          // alignment: Alignment.topLeft,
                          children: [
                            SizedBox(
                              width: 70.w,
                              height: 70.w,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  border: Border.all(color: AppColors.black),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                // padding: const EdgeInsets.all(6),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: CustomUploadedImageWidget(img: e),
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              top: -8,
                              end: -8,
                              child: GestureDetector(
                                onTap: () {
                                  cubit.removeImage(e);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.grey3,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.red,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     //  cubit.removeImage(e);
                            //   },
                            //   icon:
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ]),
      );
    });
  }
}
