import 'package:finak/core/exports.dart';

import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/cubit/state.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

import 'widgets/social_auth_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKeySignUp = GlobalKey<FormState>();

    ValueNotifier<String> textNotifier = ValueNotifier<String>('');

    ValueNotifier<String> textNotifierConfirm = ValueNotifier<String>('');
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();
        return GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .unfocus(); // Hide keyboard when tapping outside
          },
          child: Scaffold(
            appBar: customAppBar(context, title: 'register'.tr()),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKeySignUp,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.h.verticalSpace,
                      Text("welcome".tr(),
                          style: getBoldStyle(
                              fontSize: 20.sp, color: AppColors.primary)),
                      10.h.verticalSpace,
                      Text("start_journey".tr(),
                          style: getRegularStyle(
                              fontSize: 16.sp, color: AppColors.primaryGrey)),
                      50.h.verticalSpace,
                      CustomTextField(
                        title: "full_name",
                        hintText: "enter_name".tr(),
                        controller: cubit.nameControllerSignUp,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "enter_name".tr();
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        title: "email",
                        hintText: "enter_email".tr(),
                        isOptional: true,
                        controller: cubit.emailControllerSignUp,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.isEmail) {
                            return "enter_email".tr();
                          }
                          return null;
                        },
                      ),
                      CustomPhoneFormField(
                        controller: cubit.phoneControllerSignUp,
                        initialCountryCode: cubit.countryCode,
                        onCountryChanged: (v) {
                          cubit.countryCode = '+${v.fullCountryCode}';
                          print("Country changed to: ${v.name}");
                        },
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                      ),
                      ValueListenableBuilder<String>(
                          valueListenable: textNotifier,
                          builder: (context, value, child) {
                            return CustomTextField(
                              title: "password",
                              hintText: "enter_password".tr(),
                              controller: cubit.passwordControllerSignUp,
                              isPassword: true,
                              onChanged: (v) {
                                textNotifier.value = v;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "enter_password".tr();
                                } else if (value.length < 5) {
                                  return "password_length".tr();
                                } else if (textNotifier.value !=
                                    textNotifierConfirm.value) {
                                  return "password_not_match".tr();
                                }
                                return null;
                              },
                            );
                          }),
                      ValueListenableBuilder<String>(
                          valueListenable: textNotifierConfirm,
                          builder: (context, value, child) {
                            return CustomTextField(
                              title: "confirm_password",
                              hintText: "enter_password".tr(),
                              controller: cubit.confirmPasswordController,
                              isPassword: true,
                              onChanged: (v) {
                                textNotifierConfirm.value = v;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "enter_password".tr();
                                } else if (textNotifierConfirm.value !=
                                    textNotifier.value) {
                                  return "password_not_match".tr();
                                }
                                return null;
                              },
                            );
                          }),
                      20.h.verticalSpace,
                      CustomButton(
                        title: "sign_up",
                        onPressed: () {
                          if (formKeySignUp.currentState!.validate()) {
                            cubit.sendOTP(context, type: OTPTypes.register);
                          }
                        },
                      ),
                      const CustomSocialAuthWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("already_account".tr(),
                              style: getRegularStyle(
                                  fontSize: 18.sp,
                                  color: AppColors.primaryGrey)),
                          InkWell(
                            onTap: () {
                              Navigator.pop(
                                context,
                              );
                            },
                            child: Text("login".tr(),
                                style: getRegularStyle(
                                    fontSize: 18.sp, color: AppColors.primary)),
                          ),
                        ],
                      ),
                      30.h.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
