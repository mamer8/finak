
import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/cubit/state.dart';

import 'widgets/custom_pin_code.dart';
import 'widgets/social_auth_widget.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();
        return Scaffold(
          appBar: customAppBar(context, title: 'verification_code'.tr()),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Form(
                key: cubit.formKeyOtp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.h.verticalSpace,
                    Text("you_enter".tr(),
                        style: getRegularStyle(
                            fontSize: 16.sp, color: AppColors.primaryGrey)),
                    50.h.verticalSpace,
                    CustomPinCodeWidget(
                      pinController: cubit.otpController,
                      onChanged: (pin) {
                        // log('current PIN: $pin');

                        // setState(() {});
                      },
                      onCompleted: (pin) {
                        // log('Completed PIN: $pin');
                      },
                    ),
                    10.h.verticalSpace,
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: InkWell(
                        onTap: () {
                          // Navigator.pushNamed(context, AppRoutes.forgotPassword);
                        },
                        child: Text(
                          "forgot_password".tr(),
                          style: getRegularStyle(
                              fontSize: 16.sp, color: AppColors.primary),
                        ),
                      ),
                    ),
                    20.h.verticalSpace,
                    CustomButton(
                      title: "login",
                      onPressed: () {
                        if (cubit.formKeyOtp.currentState!.validate()) {
                          // cubit.login(context);
                        }
                      },
                    ),
                    const CustomSocialAuthWidget(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("dont_have_account".tr(),
                            style: getRegularStyle(
                                fontSize: 18.sp, color: AppColors.primaryGrey)),
                        InkWell(
                          onTap: () {
                            // Navigator.pushNamed(context, AppRoutes.register);
                          },
                          child: Text("sign_up".tr(),
                              style: getRegularStyle(
                                  fontSize: 18.sp, color: AppColors.primary)),
                        ),
                      ],
                    ),
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
