import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/cubit/state.dart';

import 'widgets/social_auth_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();
        return GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .unfocus(); // Hide keyboard when tapping outside
          },
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKeyLogin,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      50.h.verticalSpace,
                      Text("login".tr(),
                          style: getBoldStyle(
                              fontSize: 20.sp, color: AppColors.primary)),
                      10.h.verticalSpace,
                      Text("welcome_back".tr(),
                          style: getRegularStyle(
                              fontSize: 16.sp, color: AppColors.primaryGrey)),
                      50.h.verticalSpace,
                      CustomPhoneFormField(
                        controller: cubit.phoneControllerLogin,
                        initialCountryCode: cubit.countryCode,
                        onCountryChanged: (v) {
                          cubit.countryCode = '+${v.fullCountryCode}';
                          print("Country changed to: ${v.name}");
                        },
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                      ),
                      CustomTextField(
                        title: "password",
                        labelText: "enter_password".tr(),
                        controller: cubit.passwordControllerLogin,
                        isPassword: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "enter_password".tr();
                          } else if (value.length < 5) {
                            return "password_length".tr();
                          }
                          return null;
                        },
                      ),
                      10.h.verticalSpace,
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.forgotPasswordRoute);
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
                          if (formKeyLogin.currentState!.validate()) {
                            cubit.login(context);
                          }
                        },
                      ),
                      const CustomSocialAuthWidget(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("dont_have_account".tr(),
                              style: getRegularStyle(
                                  fontSize: 18.sp,
                                  color: AppColors.primaryGrey)),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.signUpRoute);
                            },
                            child: Text("sign_up".tr(),
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
