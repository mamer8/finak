import 'package:easy_localization/easy_localization.dart';
import 'package:finak/core/exports.dart';

class CustomDocumentWidget extends StatelessWidget {
  const CustomDocumentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ImageAssets.uploadIcon,
          width: 35,
          height: 35,
        ),
        Text("uploadImages".tr(), style: getMediumStyle(fontSize: 14.sp))
      ],
    );
  }
}
