import 'dart:io';

import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/network_image.dart';
import 'package:finak/features/menu/cubit/cubit.dart';
import 'package:finak/features/menu/cubit/state.dart';
import 'package:finak/features/menu/screens/widgets/custom_menu_row.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.h.verticalSpace,
            CustomNetworkImage(
                image: "https://www.example.com/image.jpg",
                isUser: true,
                width: 100.w,
                height: 100.w,
                borderRadius: 50.w),
            10.h.verticalSpace,
            Text(
              'John Doe',
              textAlign: TextAlign.center,
              style: getBoldStyle(fontSize: 18.sp),
            ),
            Text(
              '0123456789',
              textAlign: TextAlign.center,
              style: getRegularStyle(color: AppColors.black, fontSize: 14.sp),
            ),
            30.h.verticalSpace,
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                CustmMenuRow(
                  assetName: ImageAssets.languageIcon,
                  title: 'language'.tr(),
                ),
                CustmMenuRow(
                  assetName: ImageAssets.addOfferIcon,
                  title: 'add_offer'.tr(),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.addOfferRoute);
                  },
                ),
                CustmMenuRow(
                  assetName: ImageAssets.myOffersIcon,
                  title: 'my_offers'.tr(),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.myOffersRoute);
                  },
                ),
                CustmMenuRow(
                  assetName: ImageAssets.profileIcon,
                  title: 'profile'.tr(),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.profileRoute);
                  },
                ),
                CustmMenuRow(
                  assetName: ImageAssets.favoriteIcon,
                  title: 'favorite'.tr(),
                  onTap: () {
                    Navigator.pushNamed(context, Routes.favoritesRoute);
                  },
                ),
                CustmMenuRow(
                  assetName: ImageAssets.privacyPolicyIcon,
                  title: 'privacy_policy'.tr(),
                ),
                CustmMenuRow(
                  assetName: ImageAssets.supportIcon,
                  title: 'support'.tr(),
                ),
                CustmMenuRow(
                  assetName: ImageAssets.rateAppIcon,
                  title: 'rate_app'.tr(),
                  onTap: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();
                    String url = '';
                    String packageName = packageInfo.packageName;

                    if (Platform.isAndroid) {
                      url =
                          "https://play.google.com/store/apps/details?id=$packageName";
                    } else if (Platform.isIOS) {
                      url = 'https://apps.apple.com/us/app/$packageName';
                    }
                    if (!await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication)) {
                      throw Exception('Could not launch $url');
                    }
                    //!
                  },
                ),
                CustmMenuRow(
                  assetName: ImageAssets.shareAppIcon,
                  title: 'share_app'.tr(),
                  onTap: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();
                    String url = '';
                    String packageName = packageInfo.packageName;
                    if (Platform.isAndroid) {
                      url =
                          "https://play.google.com/store/apps/details?id=$packageName";
                    } else if (Platform.isIOS) {
                      url = 'https://apps.apple.com/us/app/$packageName';
                    }
                    await Share.share(url);
                  },
                ),
                CustmMenuRow(
                  assetName: ImageAssets.deleteIcon,
                  title: 'delete_profile'.tr(),
                ),
                CustmMenuRow(
                  title: 'logout'.tr(),
                  assetName: ImageAssets.logoutIcon,
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.loginRoute, (route) => false);
                  },
                ),
              ],
            ))),
            10.h.verticalSpace,
          ],
        ),
      );
    });
  }
}
