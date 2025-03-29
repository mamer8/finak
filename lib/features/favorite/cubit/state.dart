abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class GetServicesLoadingState extends FavoritesState {}
class LoadingReservationFavourite extends FavoritesState {}
class GetServicesErrorState extends FavoritesState {}
class GetServicesTypeErrorState extends FavoritesState {}
class GetServicesSuccessState extends FavoritesState {}
class ChangeSelectedServiceTypeState extends FavoritesState {}
class GetServicesTypeLoadingState extends FavoritesState {}
class AddOrRemoveFavoriteLoadingState extends FavoritesState {}
class AddOrRemoveFavoriteErrorState extends FavoritesState {}
class AddOrRemoveFavoriteSuccessState extends FavoritesState {
final String message ;
AddOrRemoveFavoriteSuccessState({required this.message});
}
