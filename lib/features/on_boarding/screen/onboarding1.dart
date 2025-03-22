import 'package:finak/core/exports.dart';

import '../cubit/onboarding_cubit.dart';

class OnBoarding1 extends StatelessWidget {
  const OnBoarding1({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {},
      builder: (context, state) {
        OnboardingCubit cubit = context.read<OnboardingCubit>();
        return Scaffold(
          body: Column(
            children: [
          
              Flexible(
                fit: FlexFit.tight,
                child: ClipPath(
                  clipper: CustomShape(),
                  child: Container(
                    height: getHeightSize(context) * 0.5,
                    width: getWidthSize(context),
                    color: AppColors.grey5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: -getHeightSize(context) * 0.2,
                          child: Image.asset(
                            ImageAssets.introBackgroundImage,
                            width: getWidthSize(context) * 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: getWidthSize(context) / 12),

              // SizedBox(height: getSize(context) / 12),
              Container(
                padding: EdgeInsets.all(getWidthSize(context) / 44),
                child: Text(
                  "on_boarding1".tr(),
                  textAlign: TextAlign.center,
                  style: getMediumStyle(color: AppColors.grey4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
