import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/cubit/state.dart';

import 'widgets/custom_pin_code.dart';
import 'widgets/social_auth_widget.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.isRegister});
  final bool isRegister;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  void initState() {
    context.read<LoginCubit>().otpController.text = '';
    super.initState();
  }
  GlobalKey<FormState> formKeyOtp = GlobalKey<FormState>();
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
                key: formKeyOtp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.h.verticalSpace,
                    Text("you_enter".tr(),
                        style: getRegularStyle(
                            fontSize: 16.sp, color: AppColors.primaryGrey)),
                    100.h.verticalSpace,
                    Center(
                      child: CustomPinCodeWidget(
                        pinController: cubit.otpController,
                        onChanged: (pin) {
                          // log('current PIN: $pin');
                          cubit.otpController.text = pin;

                          setState(() {});
                        },
                        onCompleted: (pin) {
                          // log('Completed PIN: $pin');
                        },
                      ),
                    ),
                    100.h.verticalSpace,
                    CustomButton(
                      title: "next",
                      isDisabled: cubit.otpController.text.length < 6,
                      onPressed: () {
                        // Navigator.pushNamed(context, Routes.newPasswordRoute);
                        if (formKeyOtp.currentState!.validate()) {
                          cubit.verifyOtp(context,
                              isRegister: widget.isRegister);
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
