import 'package:finak/core/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKeyProfile = GlobalKey<FormState>();

    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      var cubit = context.read<ProfileCubit>();

      return Scaffold(
        appBar: customAppBar(context, title: 'profile'.tr()),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKeyProfile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  10.h.verticalSpace,
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      cubit.profileImage == null
                          ? CustomNetworkImage(
                              image: cubit.loginModel.data?.image ?? "",
                              isUser: true,
                              width: 100.w,
                              height: 100.w,
                              borderRadius: 500.r)
                          : Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(500.r),
                                    child: Image.file(
                                      cubit.profileImage!,
                                      width: 100.w,
                                      height: 100.w,
                                      fit: BoxFit.cover,
                                    )),
                                Positioned(
                                    left: -2,
                                    top: -2,
                                    child: InkWell(
                                      onTap: () {
                                        cubit.removeImage();
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                          ),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(
                                                CupertinoIcons.xmark,
                                                color: AppColors.white,
                                                size: 20.w,
                                              ))),
                                    )),
                              ],
                            ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: InkWell(
                          onTap: () {
                            cubit.showImageSourceDialog(context);
                          },
                          child: Container(
                              // height: 30.h,
                              // width: 30.w,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    CupertinoIcons.camera,
                                    color: AppColors.white,
                                    size: 20.w,
                                  ))),
                        ),
                      ),
                    ],
                  ),
                  50.h.verticalSpace,
                  CustomTextField(
                    title: "full_name",
                    labelText: "enter_name".tr(),
                    controller: cubit.nameController,
                    onChanged: (value) {
                      cubit.changeProfile(true);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter_name".tr();
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    title: "email",
                    labelText: "enter_email".tr(),
                    isOptional: true,
                    enabled:
                        cubit.loginModel.data?.isSocial == 0 ? true : false,
                    controller: cubit.emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      cubit.changeProfile(true);
                    },
                    validator: (value) {
                      if (value!.isEmpty || !value.isEmail) {
                        return "enter_email".tr();
                      }
                      return null;
                    },
                  ),
                  cubit.loginModel.data?.phone != null
                      ? CustomPhoneFormField(
                          controller: cubit.phoneController,
                          isReadOnly: true,
                          initialCountryCode: cubit.countryCode,
                          onCountryChanged: (v) {
                            cubit.countryCode = '+${v.fullCountryCode}';
                            print("Country changed to: ${v.name}");
                          },
                          onChanged: (phone) {
                            cubit.changeProfile(true);
                            cubit.checkIsPhoneUpdate();
                            print(phone.completeNumber);
                          },
                        )
                      : const SizedBox(),

                  // 20.h.verticalSpace,
                  // Row(children: [
                  //   Expanded(
                  //     child: Text("hide_phone".tr(),
                  //         style: getBoldStyle(
                  //           fontSize: 18.sp,
                  //         )),
                  //   ),
                  //   CupertinoSwitch(
                  //       value: cubit.hidePhone,
                  //       activeColor: AppColors.primary,
                  //       onChanged: (value) {
                  //         cubit.changeHidePhone(value);
                  //       }),
                  // ]),
                  // Container(
                  //   height: 20.h,
                  //   width: double.infinity,
                  //   color:
                  //       cubit.isPhoneUpdated ? Colors.green : AppColors.black,
                  // ),
                  100.h.verticalSpace,
                  CustomButton(
                    isDisabled: !cubit.isProfileChanged,
                    title: "update",
                    onPressed: () {
                      if (formKeyProfile.currentState!.validate()) {
                        cubit.updateUserData(context);
                      }
                    },
                  ),
                  20.h.verticalSpace,
                  cubit.loginModel.data?.isSocial == 0
                      ? InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.changePasswordRoute);
                          },
                          child: Text("change_password".tr(),
                              style: getRegularStyle(
                                  fontSize: 18.sp, color: AppColors.primary)),
                        )
                      : cubit.loginModel.data?.phone == null
                          ? InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.addPhoneRoute);
                              },
                              child: Text(
                                  cubit.loginModel.data?.phone == null
                                      ? "add_phone".tr()
                                      : "update_phone".tr(),
                                  style: getRegularStyle(
                                      fontSize: 18.sp,
                                      color: AppColors.primary)),
                            )
                          : SizedBox(),
                  30.h.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
