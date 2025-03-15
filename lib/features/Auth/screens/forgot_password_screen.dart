import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/cubit/state.dart';

import 'widgets/social_auth_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();
        return Scaffold(
          appBar: customAppBar(context, title: 'forgot_password_title'.tr()),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Form(
                key: cubit.formKeyForgotPassword,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.h.verticalSpace,
                    Text("will_send".tr(),
                        style: getRegularStyle(
                            fontSize: 16.sp, color: AppColors.primaryGrey)),
                    50.h.verticalSpace,
                    CustomTextField(
                      title: "phone",
                      labelText: "enter_phone".tr(),
                      controller: cubit.phoneControllerForgotPassword,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter_phone".tr();
                        }
                        return null;
                      },
                    ),
                    50.h.verticalSpace,
                    CustomButton(
                      title: "send",
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.otpRoute);
                        if (cubit.formKeyForgotPassword.currentState!
                            .validate()) {
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
        );
      },
    );
  }
}
