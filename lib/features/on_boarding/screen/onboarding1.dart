import 'package:finak/core/exports.dart';

import '../cubit/onboarding_cubit.dart';

class OnBoardingWidget extends StatelessWidget {
  const OnBoardingWidget({super.key, required this.title});
  final String title;

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
                    height: getHeightSize(context) * 0.65,
                    width: getWidthSize(context),
                    color: AppColors.grey5,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          bottom: -getHeightSize(context) * 0.18,
                          child: Image.asset(
                            ImageAssets.introBackgroundImage,
                            // width: getWidthSize(context) * 0.8,
                            height: getHeightSize(context) * 0.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: getHeightSize(context) * 0.1,
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                ),
                child: AutoSizeText(
                  title.tr(),
                  maxLines: 5,
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
