import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/network_image.dart';
import 'package:finak/features/menu/cubit/cubit.dart';
import 'package:finak/features/menu/cubit/state.dart';
import 'package:finak/features/menu/screens/widgets/custom_menu_row.dart';

class CustomMenu extends StatelessWidget {
  const CustomMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(builder: (state, context) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            20.h.verticalSpace,
            CustomNetworkImage(
                image: "https://www.example.com/image.jpg",
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
                ),
                CustmMenuRow(
                  assetName: ImageAssets.myOffersIcon,
                  title: 'my_offers'.tr(),
                ),
                CustmMenuRow(
                  assetName: ImageAssets.profileIcon,
                  title: 'profile'.tr(),
                ),
                CustmMenuRow(
                  assetName: ImageAssets.favoriteIcon,
                  title: 'favorite'.tr(),
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
                ),
                CustmMenuRow(
                  assetName: ImageAssets.shareAppIcon,
                  title: 'share_app'.tr(),
                ),
                CustmMenuRow(
                  assetName: ImageAssets.deleteIcon,
                  title: 'delete_profile'.tr(),
                ),
                CustmMenuRow(
                  title: 'logout'.tr(),
                  assetName: ImageAssets.logoutIcon,
                  onTap: () {},
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
