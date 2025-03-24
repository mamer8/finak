import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:finak/features/menu/screens/menu_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'package:finak/core/exports.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<MainCubit>();
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        var cubit = context.read<MainCubit>();
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.white,
            key: _scaffoldKey,
            resizeToAvoidBottomInset: true,
            extendBody: true,
            // drawer: Drawer(
            //   child: CustomMenu(),
            //   backgroundColor: AppColors.white,
            // ),
            body: WillPopScope(
              onWillPop: () async {
                // if (cubit.currentIndex != 0) {
                //   setState(() {
                //     cubit.currentIndex = 0;
                //     cubit.getHomePage();
                //   });
                //   return false; // عدم الخروج من التطبيق، فقط الرجوع إلى الصفحة الرئيسية.
                // } else {
                bool shouldExit = await _showExitDialog(context);
                if (shouldExit) {
                  SystemNavigator.pop(); // الخروج من التطبيق بعد التأكيد.
                }
                return shouldExit;
                // }
              },
              child: cubit.navigationBarViews[cubit.currentIndex],
            ),
            bottomNavigationBar: CurvedNavigationBar(
              index: 0,
              items: [
                CurvedNavigationBarItem(
                    child: Icon(
                      CupertinoIcons.home,
                      size: 20.h,
                      color: AppColors.white,
                    ),
                    label: 'home'.tr(),
                    labelStyle:
                        getBoldStyle(color: AppColors.white, fontSize: 12.sp)),
                CurvedNavigationBarItem(
                    child: Icon(
                      CupertinoIcons.search,
                      size: 20.h,
                      color: AppColors.white,
                    ),
                    label: 'search'.tr(),
                    labelStyle:
                        getBoldStyle(color: AppColors.white, fontSize: 12.sp)),
                CurvedNavigationBarItem(
                    child: Icon(
                      CupertinoIcons.line_horizontal_3,
                      size: 20.h,
                      color: AppColors.white,
                    ),
                    label: 'menu'.tr(),
                    labelStyle:
                        getBoldStyle(color: AppColors.white, fontSize: 12.sp)),
              ],
              color: AppColors.primary,
              buttonBackgroundColor: AppColors.primary,
              backgroundColor: Colors.transparent,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 600),
              onTap: (index) {
                // if (index == 2) {
                //   _scaffoldKey.currentState?.openDrawer();
                // } else {
                cubit.changeNavigationBar(index);
                // }
              },
              letIndexChange: (index) => true,
            ),
          ),
        );
      },
    );
  }
}

Future<bool> _showExitDialog(BuildContext context) async {
  bool exitConfirmed = false;
  await AwesomeDialog(
    context: context,
    animType: AnimType.bottomSlide,
    customHeader: Padding(
      padding: const EdgeInsets.all(20),
      child: Image.asset(
        ImageAssets.logoImage,
        width: 80,
        height: 80,
      ),
    ),
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "exit_app".tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "exit_app_desc".tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    exitConfirmed = true; // تأكيد تسجيل الخروج
                    Navigator.of(context).pop(); // إغلاق الـ Dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("out".tr(),
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    exitConfirmed = false; // المستخدم لا يريد الخروج
                    Navigator.of(context).pop(); // إغلاق الـ Dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("cancel".tr(),
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ).show();

  return exitConfirmed;
}

//! bottom nav 
