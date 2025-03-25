import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/cubit/state.dart';

import 'widgets/social_auth_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
      GlobalKey<FormState> formKeyForgotPassword = GlobalKey<FormState>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();
        return Scaffold(
          appBar: customAppBar(context, title: 'forgot_password_title'.tr()),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKeyForgotPassword,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.h.verticalSpace,
                    Text("will_send".tr(),
                        style: getRegularStyle(
                            fontSize: 16.sp, color: AppColors.primaryGrey)),
                    100.h.verticalSpace,
                 
                      CustomPhoneFormField(
                      controller: cubit.phoneControllerForgotPassword,
                      initialCountryCode: cubit.countryCode,
                      onCountryChanged: (v) {
                        cubit.countryCode = '+${v.fullCountryCode}';
                        print("Country changed to: ${v.name}");
                      },
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                    50.h.verticalSpace,
                    CustomButton(
                      title: "send",
                      onPressed: () {
                        if (formKeyForgotPassword.currentState!
                            .validate()) {
                          cubit.sendOTP(context, isRegister: false);
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
