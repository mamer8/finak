import 'package:finak/core/exports.dart';

class AppWidget {
  static createProgressDialog(BuildContext context, {String? msg}) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.4),
        context: context,
        builder: (context) {
          return CustomLoadingIndicator(
            color: AppColors.white,
          );
        });
  }
}
// class AppWidget {
//   static createProgressDialog(BuildContext context, {String? msg}) {
//     showDialog(
//         barrierDismissible: false,
//         barrierColor: Colors.black.withOpacity(0.4),
//         context: context,
//         builder: (context) {
//           return WillPopScope(
//               onWillPop: () async => false,
//               child: CustomLoadingIndicator(
//                 color: AppColors.white,
//               ));
//         });
//   }
// }
