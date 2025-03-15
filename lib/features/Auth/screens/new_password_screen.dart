import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/cubit/state.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
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
                key: cubit.formKeyNewPassword,
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
                        } else if (cubit.newPasswordController.text !=
                            cubit.confirmPasswordController.text) {
                          return "password_not_match".tr();
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      title: "confirm_password",
                      labelText: "enter_password".tr(),
                      controller: cubit.confirmPasswordController,
                      isPassword: true,
                      onChanged: (v) {
                        cubit.confirmPasswordController.text = v;
                        setState(() {});
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter_password".tr();
                        } else if (cubit.newPasswordController.text !=
                            cubit.confirmPasswordController.text) {
                          return "password_not_match".tr();
                        }
                        return null;
                      },
                    ),
                    50.h.verticalSpace,
                    CustomButton(
                      title: "confirm",
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.mainRoute, (route) => false);
                        if (cubit.formKeyNewPassword.currentState!.validate()) {
                          // cubit.login(context);
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
