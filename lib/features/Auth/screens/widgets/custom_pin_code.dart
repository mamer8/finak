import 'package:finak/core/exports.dart';
import 'package:pinput/pinput.dart'; // Import the pinput package

class CustomPinCodeWidget extends StatefulWidget {
  final TextEditingController pinController;
  final Function(String) onCompleted;
  final Function(String)? onChanged; // Optional onChanged callback
  final bool hasError; // To show error border

  const CustomPinCodeWidget({
    Key? key,
    required this.pinController,
    required this.onCompleted,
    this.onChanged,
    this.hasError = false, // Default to no error
  }) : super(key: key);

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
      textStyle:  getBoldStyle(),
      decoration: BoxDecoration(
        color: AppColors.white, // Background color
        borderRadius: BorderRadius.circular(5.r), // Rounded corners
        border: Border.all(
          color: widget.hasError
              ? AppColors.red
              : AppColors.white, // Border color
          width: widget.hasError ? 1 : 0, // Border width
        ),
      ),
    );

    // Define the focused pin theme
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: widget.hasError
            ? AppColors.red
            : AppColors.white, // Active border color
        width: 1,
      ),
    );

    // Define the submitted pin theme
    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: widget.hasError
            ? AppColors.red
            : AppColors.white, // Selected border color
        width: 1,
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: Pinput(
          length: 4, // Length of the PIN
          preFilledWidget: Text(
            '0',
            style: TextStyle(
              color: AppColors.gray,
              fontSize: 18.sp,
            ),
          ),
          controller: widget.pinController,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          showCursor: true, // Show cursor
          cursor: Container(
            margin: const EdgeInsets.only(bottom: 8),
            width: 2,
            height: 20,
            color: AppColors.black, // Cursor color
          ),

          onChanged: widget.onChanged, // Optional onChanged callback
          onCompleted: widget.onCompleted, // Callback when PIN is completed
          validator: (value) {
            if (widget.hasError) {
              return 'Invalid PIN'; // Error message
            }
            return null;
          },

          errorText: 'Invalid PIN', // Error text
          errorTextStyle: TextStyle(
            color: AppColors.red, // Error text color
            fontSize: 14.sp,
          ),
          errorPinTheme: defaultPinTheme.copyDecorationWith(
            border: Border.all(
              color: AppColors.red, // Red border on error
              width: 1,
            ),
          ),
          // hint: '0000', // Hint text
          // hintStyle: TextStyle(
          //   fontSize: 18.sp,
          //   fontWeight: FontWeight.w400,
          //   color: AppColors.hintGreyColor, // Grey hint text
          // ),
        ),
      ),
    );
  }
}
