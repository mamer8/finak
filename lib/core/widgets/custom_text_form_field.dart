import 'dart:developer';

import 'package:country_pickers/utils/utils.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/location/cubit/location_cubit.dart';
import 'package:finak/features/profile/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
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
  final bool isOptional;
  //FocusNode myFocusNode = FocusNode();
  const CustomTextField({
    super.key,
    this.hintText,
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
    this.isOptional = false,
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
            child: Text(
                widget.isOptional
                    ? widget.title!.tr()
                    : '${widget.title!.tr()} *',
                style: getBoldStyle(fontSize: 18.sp)),
          ),
        SizedBox(
          height: widget.isMessage ? 150.h : null,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
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
                validator: widget.isOptional ? null : widget.validator,
                keyboardType: widget.isMessage
                    ? TextInputType.multiline
                    : widget.keyboardType,
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
                    hintText: widget.hintText,
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
                        borderSide: BorderSide(color: AppColors.red, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 10.r))))),
          ),
        ),
      ],
    );
  }
}

// class CustomPhoneFormField extends StatefulWidget {
//   const CustomPhoneFormField({
//     super.key,
//     this.onCountryChanged,
//     this.onChanged,
//     this.controller,
//     this.isReadOnly = false,
//     this.initialCountryCode,
//     this.color,
//     this.helperStyle,
//   });

//   final void Function(Country)? onCountryChanged;
//   final void Function(PhoneNumber)? onChanged;
//   final TextEditingController? controller;
//   final String? initialCountryCode;
//   final bool isReadOnly;
//   final Color? color;
//   final TextStyle? helperStyle;

//   @override
//   State<CustomPhoneFormField> createState() => _CustomPhoneFormFieldState();
// }

// class _CustomPhoneFormFieldState extends State<CustomPhoneFormField> {
//   late FocusNode myFocusNode;

//   @override
//   void initState() {
//     super.initState();
//     myFocusNode = FocusNode();
//     myFocusNode.addListener(() {
//       setState(() {
//         // color = Colors.black;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     myFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(vertical: 8.h),
//           child:
//               Text('${"phone".tr()} *', style: getBoldStyle(fontSize: 18.sp)),
//         ),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 6.w),
//           child: GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onTap: () {
//               // Do nothing when tapping on the field itself
//             },
//             child: Directionality(
//               textDirection: TextDirection.ltr,
//               child: IntlPhoneField(
//                 controller: widget.controller,
//                 showCountryFlag: true,
//                 validator: (value) {
//                   if (value == null || value.toString().length < 11) {
//                     return 'enter your phone';
//                   }
//                   return null;
//                 },
//                 keyboardType: TextInputType.number,
//                 disableLengthCheck: false,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 showDropdownIcon: false,
//                 enabled: !widget.isReadOnly,
//                 focusNode: myFocusNode,
//                 decoration: InputDecoration(
//                     hintText: "enter_phone".tr(),
//                     hintStyle: getRegularStyle(
//                         color: AppColors.black, fontSize: 14.sp),
//                     fillColor: widget.isReadOnly
//                         ? AppColors.gray.withOpacity(0.5)
//                         : AppColors.textFiledBG,
//                     filled: true,
//                     helperStyle: widget.helperStyle,
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: AppColors.textFiledBG),
//                       borderRadius: const BorderRadius.all(
//                         Radius.circular(10.0),
//                       ),
//                     ),
//                     contentPadding:
//                         EdgeInsets.symmetric(horizontal: 2, vertical: 12.h),

//                     errorStyle: getRegularStyle(color: AppColors.red),
//                     enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                             color: AppColors.textFiledBG, width: 1.5),
//                         borderRadius: BorderRadius.all(Radius.circular(10.r))),
//                     disabledBorder: OutlineInputBorder(
//                         borderSide:
//                             BorderSide(color: AppColors.gray, width: 1.5),
//                         borderRadius: BorderRadius.all(Radius.circular(10.r))),
//                     // focused border style
//                     focusedBorder: OutlineInputBorder(
//                         borderSide:
//                             BorderSide(color: AppColors.primary, width: 1.5),
//                         borderRadius: BorderRadius.all(Radius.circular(10.r))),

//                     // error border style
//                     errorBorder: OutlineInputBorder(
//                         borderSide:
//                             BorderSide(color: AppColors.red, width: 1.5),
//                         borderRadius: BorderRadius.all(Radius.circular(10.r))),
//                     focusedErrorBorder: OutlineInputBorder(
//                         borderSide:
//                             BorderSide(color: AppColors.red, width: 1.5),
//                         borderRadius: BorderRadius.all(Radius.circular(10.r)))),
//                 onCountryChanged: widget.onCountryChanged,
//                 style: getBoldStyle(),
//                 initialValue: widget.initialCountryCode ?? '+20',
//                 flagsButtonPadding: const EdgeInsetsDirectional.only(start: 18),
//                 onChanged: widget.onChanged,
//                 dropdownTextStyle: getRegularStyle(
//                   fontSize: 16.sp,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class CustomPhoneFormField extends StatefulWidget {
  const CustomPhoneFormField({
    super.key,
    this.onCountryChanged,
    this.onChanged,
    this.controller,
    this.isReadOnly = false,
    this.initialCountryCode,
    this.color,
    this.helperStyle,
  });

  final void Function(Country)? onCountryChanged;
  final void Function(PhoneNumber)? onChanged;
  final TextEditingController? controller;
  final String? initialCountryCode;
  final bool isReadOnly;
  final Color? color;
  final TextStyle? helperStyle;

  @override
  State<CustomPhoneFormField> createState() => _CustomPhoneFormFieldState();
}

class _CustomPhoneFormFieldState extends State<CustomPhoneFormField> {
  late FocusNode myFocusNode;
  String initialCountryCodee = '+20'; // Default to Egypt
  Key fieldKey = UniqueKey(); // Add a key to force rebuilding

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    getCountryCodeFromName(); // Fetch country code dynamically

    myFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  /// Fetch country code from geolocation
  Future<void> getCountryCodeFromName() async {
    final countryName = await _getAddressFromLatLng();
    log("countryName: $countryName");

    try {
      final country = CountryPickerUtils.getCountryByName(countryName);
      if (mounted) {
        log("country: +${country.phoneCode}");
        setState(() {
          initialCountryCodee = '+${country.phoneCode}';
          context.read<LoginCubit>().countryCode = initialCountryCodee;
          context.read<ProfileCubit>().countryCode = initialCountryCodee;
          fieldKey = UniqueKey(); // Change key to force rebuild
        });
      }
    } catch (e) {
      debugPrint("Error fetching country code: ${e.toString()}");
    }
  }

  /// Get country name from current geolocation
  Future<String> _getAddressFromLatLng() async {
    try {
      final locationCubit = context.read<LocationCubit>();

      if (locationCubit.currentLocation == null) {
        await locationCubit.checkAndRequestLocationPermission(context);
      }

      final location = locationCubit.currentLocation;
      if (location != null) {
        final placemarks = await placemarkFromCoordinates(
          location.latitude!,
          location.longitude!,
        );

        if (placemarks.isNotEmpty) {
          return placemarks.first.country ?? "Egypt";
        }
      }
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      // return "England";
    }
    return "Egypt"; // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('${"phone".tr()} *', style: getBoldStyle(fontSize: 18)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: KeyedSubtree(
              key: fieldKey,
              child: IntlPhoneField(
                controller: widget.controller,
                showCountryFlag: true,
                validator: (value) {
                  if (value == null || value.completeNumber.length < 11) {
                    return 'enter your phone';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                disableLengthCheck: false,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                showDropdownIcon: false,
                enabled: !widget.isReadOnly,
                focusNode: myFocusNode,
                decoration: InputDecoration(
                  hintText: "enter_phone".tr(),
                  hintStyle:
                      getRegularStyle(color: AppColors.black, fontSize: 14),
                  fillColor: widget.isReadOnly
                      ? AppColors.gray.withOpacity(0.5)
                      : AppColors.textFiledBG,
                  filled: true,
                  helperStyle: widget.helperStyle,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.textFiledBG),
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 2, vertical: 12),
                  errorStyle: getRegularStyle(color: AppColors.red),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.textFiledBG, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.gray, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColors.primary, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.red, width: 1.5),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                onCountryChanged: widget.onCountryChanged,
                style: getBoldStyle(),
                initialValue: initialCountryCodee,
                flagsButtonPadding: const EdgeInsetsDirectional.only(start: 18),
                onChanged: widget.onChanged,
                dropdownTextStyle: getRegularStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
