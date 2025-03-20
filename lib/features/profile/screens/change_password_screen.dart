import 'package:finak/core/exports.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen.ChangePasswordScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      var cubit = context.read<ProfileCubit>();

      return Scaffold(
        appBar: customAppBar(context, title: 'change_password'.tr()),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: cubit.formKeyChangePassword,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 10.h.verticalSpace,
                  // Text("welcome".tr(),
                  //     style: getBoldStyle(
                  //         fontSize: 20.sp, color: AppColors.primary)),
                  // 10.h.verticalSpace,
                  // Text("start_journey".tr(),
                  //     style: getRegularStyle(
                  //         fontSize: 16.sp, color: AppColors.primaryGrey)),
                  50.h.verticalSpace,
                  CustomTextField(
                    title: "current_password",
                    labelText: "enter_password".tr(),
                    controller: cubit.passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter_password".tr();
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    title: "new_password",
                    labelText: "enter_password".tr(),
                    controller: cubit.newpasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter_password".tr();
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    title: "confirm_password",
                    labelText: "enter_password".tr(),
                    controller: cubit.confirmPasswordController,
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter_password".tr();
                      }
                      return null;
                    },
                  ),
                  50.h.verticalSpace,
                  CustomButton(
                    title: "update",
                    onPressed: () {
                      if (cubit.formKeyChangePassword.currentState!
                          .validate()) {
                        // cubit.login(context);
                      }
                    },
                  ),

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
