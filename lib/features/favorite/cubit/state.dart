abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class GetServicesLoadingState extends FavoritesState {}
class GetServicesErrorState extends FavoritesState {}
class GetServicesTypeErrorState extends FavoritesState {}
class GetServicesSuccessState extends FavoritesState {}
class ChangeSelectedServiceTypeState extends FavoritesState {}
class GetServicesTypeLoadingState extends FavoritesState {}
