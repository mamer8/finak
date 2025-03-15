import 'package:finak/core/exports.dart';
import 'package:flutter/cupertino.dart';

class CustomSearchTextField extends StatefulWidget {
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController? controller;
  const CustomSearchTextField({
    super.key, this.onTap, this.onChanged, this.onSubmitted, this.controller,
    
    
  });

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              // height: 100.h,
              child: TextFormField(
                
                  controller: widget.controller,
                  expands: false,
                  onTap: widget.onTap,
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  focusNode: myFocusNode,
                  style: getBoldStyle(),
                  onChanged: widget.onChanged,
                  // validator: widget.validator,
                  onFieldSubmitted: widget.onSubmitted,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      labelText: "search".tr(),
                      labelStyle: getRegularStyle(
                          fontHeight: 1.5,
                          color: myFocusNode.hasFocus
                              ? AppColors.primary
                              : AppColors.gray),
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        color: myFocusNode.hasFocus
                            ? AppColors.primary
                            : AppColors.gray,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 12.h),
                      // hintStyle:
                      //     getRegularStyle(color: AppColors.gray, fontSize: 14),
                      errorStyle: getRegularStyle(color: AppColors.red),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.gray, width: 1.5),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.r))),
                      disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.gray, width: 1.5),
                          borderRadius: BorderRadius.all(
                              Radius.circular( 10.r))),
                      // focused border style
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 1.5),
                          borderRadius: BorderRadius.all(
                              Radius.circular( 10.r))),

                      // error border style
                      errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.red, width: 1.5),
                          borderRadius: BorderRadius.all(
                              Radius.circular( 10.r))),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.red, width: 1.5),
                          borderRadius: BorderRadius.all(Radius.circular( 10.r))))),
            ),
          ),
          10.w.horizontalSpace,
          Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  ImageAssets.filterIcon,
                ),
              ))
        ],
      ),
    );
  }
}
