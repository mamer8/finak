import 'package:easy_localization/easy_localization.dart';
import 'package:finak/core/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? initialValue;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? borderRadius;
  final bool? enabled;
  final bool isMessage;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? title;
  final List<TextInputFormatter>? inputFormatters;
  //FocusNode myFocusNode = FocusNode();
  const CustomTextField({
    super.key,
    this.labelText,
    this.prefixIcon,
    this.validator,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.isMessage = false,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onTap,
    this.isPassword = false,
    this.onSubmitted,
    this.borderRadius,
    this.enabled = true,
    this.title,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  FocusNode myFocusNode = FocusNode();
  bool showPassword = false;
  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      setState(() {
        // color = Colors.black;
      });
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child:
                Text(widget.title!.tr(), style: getBoldStyle(fontSize: 18.sp)),
          ),
        SizedBox(
          height: widget.isMessage ? 150.h : null,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
                enabled: widget.enabled,
                controller: widget.controller,
                expands: false,
                onTap: widget.onTap,
                inputFormatters: widget.inputFormatters,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              
                focusNode: myFocusNode,
                style: getBoldStyle(),
                onChanged: widget.onChanged,
                validator: widget.validator,
                keyboardType: widget.keyboardType,
                maxLines: widget.isMessage ? 5 : 1,
                minLines: widget.isMessage ? 5 : 1,
                onFieldSubmitted: widget.onSubmitted,
                initialValue: widget.initialValue,
                obscureText: widget.isPassword ? !showPassword : false,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: widget.enabled!
                        ? AppColors.textFiledBG
                        : AppColors.gray.withOpacity(0.5),
                    hintText: widget.labelText,
                    hintStyle: getRegularStyle(
                        color: AppColors.black, fontSize: 14.sp),

                    // labelText: widget.labelText,
                    // labelStyle: getRegularStyle(
                    //     fontHeight: 1.5,
                    //     color: myFocusNode.hasFocus
                    //         ? AppColors.primary
                    //         : AppColors.gray),
                    prefixIcon: widget.prefixIcon,
                    prefixIconColor: myFocusNode.hasFocus
                        ? AppColors.primary
                        : AppColors.gray,
                    suffixIconColor: myFocusNode.hasFocus
                        ? AppColors.primary
                        : AppColors.gray,
                    suffixIcon: widget.isPassword
                        ? IconButton(
                            icon: Icon(
                              showPassword
                                  ? CupertinoIcons.eye
                                  : CupertinoIcons.eye_slash,
                              color: showPassword
                                  ? AppColors.primary
                                  : AppColors.grey2,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          )
                        : widget.suffixIcon,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 12.h),
                    // hintStyle:
                    //     getRegularStyle(color: AppColors.gray, fontSize: 14),
                    errorStyle: getRegularStyle(color: AppColors.red),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.textFiledBG, width: 1.5),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 10.r))),
                    disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.gray, width: 1.5),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 10.r))),
                    // focused border style
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 1.5),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 10.r))),

                    // error border style
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.red, width: 1.5),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 10.r))),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.red, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 10.r))))),
          ),
        ),
      ],
    );
  }
}
