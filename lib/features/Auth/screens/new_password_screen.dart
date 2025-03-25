import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/cubit/state.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  GlobalKey<FormState> formKeyNewPassword = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();
        return Scaffold(
          appBar: customAppBar(context, title: 'new_password'.tr()),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKeyNewPassword,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.h.verticalSpace,
                    Text("you_enter".tr(),
                        style: getRegularStyle(
                            fontSize: 16.sp, color: AppColors.primaryGrey)),
                    50.h.verticalSpace,
                    CustomTextField(
                      title: "new_password",
                      labelText: "enter_password".tr(),
                      isPassword: true,
                      controller: cubit.newPasswordController,
                      onChanged: (v) {
                        cubit.newPasswordController.text = v;
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter_password".tr();
                        } else if (value.length < 5) {
                          return "password_length".tr();
                        } else if (cubit.newPasswordController.text !=
                            cubit.confirmNewPasswordController.text) {
                          return "password_not_match".tr();
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      title: "confirm_password",
                      labelText: "enter_password".tr(),
                      controller: cubit.confirmNewPasswordController,
                      isPassword: true,
                      onChanged: (v) {
                        cubit.confirmNewPasswordController.text = v;
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter_password".tr();
                        } else if (value.length < 5) {
                          return "password_length".tr();
                        } else if (cubit.newPasswordController.text !=
                            cubit.confirmNewPasswordController.text) {
                          return "password_not_match".tr();
                        }
                        return null;
                      },
                    ),
                    50.h.verticalSpace,
                    CustomButton(
                      title: "confirm",
                      onPressed: () {
                        if (formKeyNewPassword.currentState!.validate()) {
                          cubit.resetPassword(context);
                        }
                      },
                    ),
                    20.h.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.white,
        );
      },
    );
  }
}
