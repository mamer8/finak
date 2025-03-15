// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:almamlaka/core/exports.dart';

// class CustomLoadingIndicator extends StatelessWidget {
//   const CustomLoadingIndicator({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Platform.isIOS
//         ? const CupertinoActivityIndicator(animating: true, radius: 15)
//         : CircularProgressIndicator(color: AppColors.primary);
//   }
// }
import 'dart:io';
import 'package:finak/core/exports.dart';

class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({super.key, this.withLogo = true});
  final bool withLogo;

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.withLogo
        ? Stack(
            alignment: Alignment.center,
            children: [
              // Platform specific loading indicator in the background
              Platform.isIOS
                  ?
              // const CupertinoActivityIndicator(
              //         animating: true,
              //         radius: 30,
              //       )
              SizedBox(
                height: 55.h, // Increased size
                width: 55.h, // Increased size
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3, // Slightly increased thickness
                ),
              )
                  : SizedBox(
                      height: 55.h, // Increased size
                      width: 55.h, // Increased size
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 3, // Slightly increased thickness
                      ),
                    ),
              // Rotating logo in the center
              RotationTransition(
                turns: _controller,
                child: Image.asset(
                  ImageAssets.logoImage,
                  height: 50.h,
                  width: 50.h,
                ),
              ),
            ],
          )
        : Platform.isIOS
            ?
    // const CupertinoActivityIndicator(
    //             animating: true,
    //             radius: 30,
    //           )
    CircularProgressIndicator(
      color: AppColors.primary,
      strokeWidth: 3, // Slightly increased thickness
    )
            : CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3, // Slightly increased thickness
              );
  }
}
