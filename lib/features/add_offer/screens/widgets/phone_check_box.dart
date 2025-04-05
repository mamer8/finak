import 'package:finak/core/exports.dart';
import 'package:finak/features/profile/cubit/cubit.dart';
import 'package:finak/features/profile/cubit/state.dart';

class CustomPhoneCheckBox extends StatefulWidget {
  const CustomPhoneCheckBox({
    super.key,
  });

  @override
  State<CustomPhoneCheckBox> createState() => _CustomPhoneCheckBoxState();
}

class _CustomPhoneCheckBoxState extends State<CustomPhoneCheckBox> {
  @override
  void initState() {
    if (context.read<ProfileCubit>().loginModel.data == null) {
      context.read<ProfileCubit>().getProfile();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      var prifileCubit = context.read<ProfileCubit>();
      return GestureDetector(
        onTap: () {
          prifileCubit.changePhoneHide(context, !prifileCubit.isPhoneHide);
        },
        child: Row(
          children: [
            Checkbox(
                activeColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
                value: prifileCubit.isPhoneHide,
                onChanged: (v) {
                  prifileCubit.changePhoneHide(context, v);
                }),
            Flexible(
              child: Text(
                'hide_phone'.tr(),
                style: getBoldStyle(fontSize: 18.sp),
              ),
            ),
          ],
        ),
      );
    });
  }
}
