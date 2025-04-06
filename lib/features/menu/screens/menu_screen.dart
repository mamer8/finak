import 'dart:io';

import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/network_image.dart';
import 'package:finak/features/menu/cubit/cubit.dart';
import 'package:finak/features/menu/cubit/state.dart';
import 'package:finak/features/menu/screens/widgets/custom_menu_row.dart';
import 'package:finak/features/profile/cubit/cubit.dart';
import 'package:finak/features/profile/cubit/state.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<MenuCubit>();
    return Scaffold(
      body: BlocBuilder<MenuCubit, MenuState>(builder: (context, state) {
        return BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
          var profileCubit = context.read<ProfileCubit>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              30.h.verticalSpace,
              InkWell(
                onTap: () => profileCubit.getProfile(),
                child: CustomNetworkImage(
                    image: profileCubit.loginModel.data?.image ?? '',
                    isUser: true,
                    width: 100.w,
                    height: 100.w,
                    borderRadius: 50.w),
              ),
              10.h.verticalSpace,
              Text(
                AppConst.isLogged
                    ? profileCubit.loginModel.data?.name ?? ''
                    : 'guest'.tr(),
                textAlign: TextAlign.center,
                style: getBoldStyle(fontSize: 18.sp),
              ),
              if (AppConst.isLogged)
                Text(
                  profileCubit.loginModel.data?.isSocial == 1
                      ? profileCubit.loginModel.data?.email ??
                          profileCubit.loginModel.data?.phone ??
                          ''
                      : profileCubit.loginModel.data?.phone ?? '',
                  textAlign: TextAlign.center,
                  style:
                      getRegularStyle(color: AppColors.black, fontSize: 14.sp),
                ),
              30.h.verticalSpace,
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                children: [
                  CustmMenuRow(
                    assetName: ImageAssets.languageIcon,
                    title: 'language'.tr(),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.languagesRoute);
                    },
                  ),
                  if (AppConst.isLogged)
                    CustmMenuRow(
                      assetName: ImageAssets.addOfferIcon,
                      title: 'add_offer'.tr(),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.addOfferRoute);
                      },
                    ),
                  if (AppConst.isLogged)
                    CustmMenuRow(
                      assetName: ImageAssets.myOffersIcon,
                      title: 'my_offers'.tr(),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.myOffersRoute);
                      },
                    ),
                  if (AppConst.isLogged)
                    CustmMenuRow(
                      assetName: ImageAssets.profileIcon,
                      title: 'profile'.tr(),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.profileRoute);
                      },
                    ),
                  if (AppConst.isLogged)
                    CustmMenuRow(
                      assetName: ImageAssets.messagesIcon,
                      title: 'messages'.tr(),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.messagesRoute);
                      },
                    ),
                  if (AppConst.isLogged)
                    CustmMenuRow(
                      assetName: ImageAssets.favoriteIcon,
                      title: 'favorite'.tr(),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.favoritesRoute);
                      },
                    ),
                  if (cubit.settingsModel.data?.privacy != null)
                    CustmMenuRow(
                      assetName: ImageAssets.privacyPolicyIcon,
                      title: 'privacy_policy'.tr(),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.privacyPolicyRoute);
                      },
                    ),
                  if (cubit.settingsModel.data?.phone != null)
                    CustmMenuRow(
                      assetName: ImageAssets.supportIcon,
                      title: 'support'.tr(),
                      onTap: () async {
                        String whatsappNumber =
                            cubit.settingsModel.data?.phone ?? '';
                        String url = 'https://wa.me/$whatsappNumber';
                        if (!await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      withRow: false,
                    ),
                  CustmMenuRow(
                    assetName: ImageAssets.rateAppIcon,
                    title: 'rate_app'.tr(),
                    onTap: () async {
                      PackageInfo packageInfo =
                          await PackageInfo.fromPlatform();
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
                    withRow: false,
                  ),
                  CustmMenuRow(
                    assetName: ImageAssets.shareAppIcon,
                    title: 'share_app'.tr(),
                    onTap: () async {
                      PackageInfo packageInfo =
                          await PackageInfo.fromPlatform();
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
                    withRow: false,
                  ),
                  if (AppConst.isLogged)
                    CustmMenuRow(
                      assetName: ImageAssets.deleteIcon,
                      title: 'delete_profile'.tr(),
                      onTap: () {
                        deleteAccountDialog(context, onPressed: () {
                          context.read<MenuCubit>().deleteAccount(context);
                        });
                      },
                      withRow: false,
                    ),
                  CustmMenuRow(
                    title: !AppConst.isLogged ? 'login'.tr() : 'logout'.tr(),
                    assetName: ImageAssets.logoutIcon,
                    onTap: () {
                      AppConst.isLogged
                          ? context.read<MenuCubit>().logout(context)
                          : Navigator.pushNamed(context, Routes.loginRoute);
                    },
                    isLast: true,
                    withRow: false,
                  ),
                ],
              ))),
              30.h.verticalSpace,
              kToolbarHeight.verticalSpace,
            ],
          );
        });
      }),
    );
  }
}
