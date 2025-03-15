import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finak/core/utils/assets_manager.dart';
import 'package:get/get.dart';
import 'package:finak/core/utils/app_colors.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

/*----------------------------------------------------------------------------*/
/*------------------------------  Error Get Bar  -----------------------------*/
/*----------------------------------------------------------------------------*/
errorGetBar(String message) {
  Get.showSnackbar(
    GetSnackBar(
      messageText: Text(
        message!,
        style: Get.textTheme.titleSmall!.copyWith(
          color: Colors.white,
          height: 1.3,
        ),
      ),
      icon: const Icon(Icons.error_outline_outlined, color: Colors.white),
      backgroundColor: AppColors.error,
      barBlur: 5.0,
      borderRadius: 12.0,
      duration: const Duration(seconds: 2),
      isDismissible: true,
      margin: const EdgeInsets.all(12.0),
      snackPosition: SnackPosition.BOTTOM,
    ),
  );
}

/*----------------------------------------------------------------------------*/
/*------------------------------  Success Get Bar  ---------------------------*/
/*----------------------------------------------------------------------------*/

successGetBar(String? message) {
  Get.showSnackbar(GetSnackBar(
    messageText: Text(
      message ?? 'success'.tr,
      style: Get.textTheme.bodyMedium!.copyWith(
        color: Colors.white,
        height: 1.5,
      ),
    ),
    icon: const Icon(CupertinoIcons.checkmark_seal, color: Colors.white),
    backgroundColor: AppColors.success,
    barBlur: 5.0,
    borderRadius: 12.0,
    duration: const Duration(milliseconds: 2500),
    isDismissible: true,
    margin: const EdgeInsets.all(8.0),
    snackPosition: SnackPosition.TOP,
  ));
}

/*----------------------------------------------------------------------------*/
/*------------------------------  Message Get Bar  ---------------------------*/
/*----------------------------------------------------------------------------*/
messageGetBar(String message) {
  Get.showSnackbar(GetSnackBar(
    messageText: Text(
      message,
      style: Get.textTheme.labelMedium!.copyWith(
        color: Colors.white,
        height: 1.5,
      ),
    ),
    icon: const Icon(CupertinoIcons.arrow_left_circle, color: Colors.white),
    backgroundColor: Get.theme.primaryColor,
    barBlur: 5.0,
    borderRadius: 12.0,
    duration: const Duration(seconds: 3),
    isDismissible: true,
    margin: const EdgeInsets.all(8.0),
    snackPosition: SnackPosition.TOP,
  ));
}

/*----------------------------------------------------------------------------*/
/*------------------------------  Loading Dialog  ----------------------------*/
/*----------------------------------------------------------------------------*/
// loadingDialog() {
//   Get.dialog(
//     Dialog(
//       backgroundColor: Colors.white,
//       insetAnimationCurve: Curves.bounceInOut,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 25),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'جارى التحميل'.tr,
//               style: Get.textTheme.labelMedium!.copyWith(
//                 color: Get.theme.primaryColor,
//               ),
//             ),
//             const SizedBox(width: 5),
//             // SpinKitCircle(),vx
//             CircularProgressIndicator(color: Get.theme.colorScheme.secondary),
//           ],
//         ),
//       ),
//     ),
//     barrierDismissible: false,
//     transitionCurve: Curves.easeInOutBack,
//   );
// }

//!----------------------------------------------------------------------------/
//!------------------------------  Loading Dialog we will use it  -------------/
//!----------------------------------------------------------------------------/


void startOverlay(BuildContext context) {
    OverlayLoadingProgress.start(
          context,
          widget: Container(
            width: MediaQuery.of(context).size.width / 4,
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 13),
            child: const AspectRatio(
              aspectRatio: 1,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        );
}

void stopOverlay() {
  OverlayLoadingProgress.stop();
}
/*----------------------------------------------------------------------------*/
/*------------------------------  Bottom Sheet  ----------------------------*/
/*----------------------------------------------------------------------------*/

