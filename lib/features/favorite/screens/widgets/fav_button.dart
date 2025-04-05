import 'package:finak/core/exports.dart';
import 'package:finak/features/favorite/cubit/cubit.dart';
import 'package:finak/features/favorite/cubit/state.dart';

class CustomFavButton extends StatefulWidget {
  CustomFavButton(
      {super.key,
      required this.isFav,
      required this.serviceId,
      this.isDetails = false,
      this.isFavoriteScreen = false});
  bool isFav;
  final int serviceId;
  final bool isDetails;
  final bool isFavoriteScreen;

  @override
  State<CustomFavButton> createState() => _CustomFavButtonState();
}

class _CustomFavButtonState extends State<CustomFavButton> {
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<FavoritesCubit>();
    return BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
      return InkWell(
        onTap: () {
          checkLoggingStatus(
            context,
            onPressed: () {
              print("widget.isFav: ${widget.isFav}");
              setState(() {
                widget.isFav = !(widget.isFav);
              });
              print("widget.isFav after edit: ${widget.isFav}");
              cubit.addOrRemoveFavorite(context,
                  isFavoriteScreen: widget.isFavoriteScreen,
                  offerId: widget.serviceId.toString());
            },
          );
        },
        child: CircleAvatar(
          backgroundColor: AppColors.white,
          radius: widget.isDetails ? 18.r : 15.r,
          child: Icon(
            Icons.favorite_rounded,
            color: widget.isFav ? AppColors.red : AppColors.secondGrey,
            // size: 20.w,
          ),
        ),
      );
    });
  }
}
