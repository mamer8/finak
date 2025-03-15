import 'package:finak/core/exports.dart';
import 'package:pinput/pinput.dart'; // Import the pinput package

class CustomPinCodeWidget extends StatefulWidget {
  final TextEditingController pinController;
  final Function(String) onCompleted;
  final Function(String)? onChanged; // Optional onChanged callback
  final bool hasError; // To show error border

  const CustomPinCodeWidget({
    super.key,
    required this.pinController,
    required this.onCompleted,
    this.onChanged,
    this.hasError = false, // Default to no error
  });

  @override
  State<CustomPinCodeWidget> createState() => _CustomPinCodeWidgetState();
}

class _CustomPinCodeWidgetState extends State<CustomPinCodeWidget> {
  @override
  Widget build(BuildContext context) {
    // Define the default pin theme
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 60.w,
      textStyle: getBoldStyle(),
      decoration: BoxDecoration(
        color: AppColors.textFiledBG,
        shape: BoxShape.circle,
        border: Border.all(
          color: widget.hasError ? AppColors.red : AppColors.textFiledBG,
          width: widget.hasError ? 1 : 0,
        ),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: Pinput(
          length: 4,
          controller: widget.pinController,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          // focusNode: myFocusNode,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyDecorationWith(
            border: Border.all(
              color: widget.hasError ? AppColors.red : AppColors.primary,
              width: 1.5,
            ),
          ),
          submittedPinTheme: defaultPinTheme.copyDecorationWith(
            border: Border.all(
              color: widget.hasError ? AppColors.red : AppColors.primary,
              width: 1.5,
            ),
          ),
          showCursor: true,
          cursor: Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: 2,
            height: 20,
            color: AppColors.black,
          ),
          onChanged: widget.onChanged,
          onCompleted: widget.onCompleted,
          validator: (value) => widget.hasError ? 'Invalid PIN'.tr() : null,
          errorText: 'Invalid PIN'.tr(),
          errorTextStyle: TextStyle(
            color: AppColors.red,
            fontSize: 14.sp,
          ),
          errorPinTheme: defaultPinTheme.copyDecorationWith(
            border: Border.all(
              color: AppColors.red,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
