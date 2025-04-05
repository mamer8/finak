import 'package:finak/core/exports.dart';
import 'package:finak/features/Auth/cubit/cubit.dart';
import 'package:finak/features/Auth/cubit/state.dart';

class AddPhoneScreen extends StatelessWidget {
  const AddPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKeyAddPhone = GlobalKey<FormState>();

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        var cubit = context.read<LoginCubit>();
        return GestureDetector(
          onTap: () {
            FocusScope.of(context)
                .unfocus(); // Hide keyboard when tapping outside
          },
          child: Scaffold(
            appBar: customAppBar(context, title: 'add_phone'.tr()),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKeyAddPhone,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.h.verticalSpace,
                      Text("will_send_add_phone".tr(),
                          style: getRegularStyle(
                              fontSize: 16.sp, color: AppColors.primaryGrey)),
                      100.h.verticalSpace,
                      CustomPhoneFormField(
                        controller: cubit.phoneControllerAddPhone,
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
                          if (formKeyAddPhone.currentState!.validate()) {
                            cubit.sendOTP(context, type: OTPTypes.addPhone);
                          }
                        },
                      ),
                      20.h.verticalSpace,
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
