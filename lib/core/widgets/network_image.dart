import 'package:cached_network_image/cached_network_image.dart';
import 'package:finak/core/exports.dart';


// Amer
class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.image,
    this.isUser = false,
    this.isDetails = false,
    this.height,
    this.width,
    this.fit,
    this.withLogo = false,
    this.borderRadius,
    this.isPersonalInfo=false
  });
  final String image;
  final bool isUser;
  final bool isDetails;
  final bool isPersonalInfo;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool withLogo;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: CachedNetworkImage(
          imageUrl: image,
          fit: fit ?? BoxFit.cover,
          height: height,
          width: width,
          placeholder: (context, url) => isDetails
              ? Padding(
                  padding: EdgeInsets.only(top: getHeightSize(context) * 0.1),
                  child: CustomLoadingIndicator(
                    withLogo: withLogo,
                  ),
                )
              : Center(
                  child: CustomLoadingIndicator(
                    withLogo: withLogo,
                  ),
                ),
          errorWidget: (context, url, error) => Padding(
                padding: const EdgeInsets.all(8.0),
                child:isPersonalInfo?Icon(
                  Icons.person,color: AppColors.primary,size: 40.h,): Image.asset(
                  isUser ? ImageAssets.profileDefault : ImageAssets.logoImage,
                  height: height,
                  width: width,
                  fit: BoxFit.cover,
                ),
              )),
    );
  }
}
