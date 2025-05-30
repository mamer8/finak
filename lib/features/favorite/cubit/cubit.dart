import 'package:finak/features/home/cubit/cubit.dart';
import 'package:finak/features/location/cubit/location_cubit.dart';
import 'package:finak/features/my_offers/cubit/cubit.dart';
import 'package:finak/features/services/cubit/cubit.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:finak/features/services/data/models/service_types_model.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this.api) : super(FavoritesInitial());

  FavoritesRepo api;
  TextEditingController searchController = TextEditingController();
  ServiceTypeModel? selectedServiceType;
  changeSelectedServiceType(ServiceTypeModel? value) {
    selectedServiceType = value;
    emit(ChangeSelectedServiceTypeState());
    getMyFavorites();
  }

  /// Get Service Types //////
  GetServiceTypesModel serviceTypesModel = GetServiceTypesModel();
  void getServiceTypes() async {
    emit(GetServicesTypeLoadingState());
    var response = await api.getServiceTypes();
    response.fold(
      (failure) {
        emit(GetServicesTypeErrorState());
      },
      (r) {
        serviceTypesModel = r;
        emit(GetServicesSuccessState());
      },
    );
  }

  /// Get My Offers //////
  GetServicesModel myFavoritesModel = GetServicesModel();
  void getMyFavorites() async {
    emit(GetServicesLoadingState());
    var response = await api.getMyFavorites(
      serviceTypeId: selectedServiceType?.id,
      search: searchController.text,
    );
    response.fold(
      (failure) {
        emit(GetServicesErrorState());
      },
      (r) {
        myFavoritesModel = r;
        emit(GetServicesSuccessState());
      },
    );
  }

  void addOrRemoveFavorite(BuildContext context,
      {required String offerId, bool isFavoriteScreen = false}) async {
    emit(AddOrRemoveFavoriteLoadingState());
    var response = await api.addOrRemoveFavorite(offerId: offerId);
    response.fold(
      (failure) {
        emit(AddOrRemoveFavoriteErrorState());
      },
      (r) {
        if (r.status != 200 && r.status != 201) {
          emit(AddOrRemoveFavoriteErrorState());
        } else {
          emit(AddOrRemoveFavoriteSuccessState(message: r.msg ?? ""));
          updateFavouritesInModels(
            context,
            isFav: r.msg == "added Successfully" ? true : false,
            id: offerId,
          );
          if (isFavoriteScreen) {
            getMyFavorites();
          }
        }
      },
    );
  }

  updateFavouritesInModels(
    BuildContext context, {
    required bool isFav,
    required String id,
  }) async {
    context.read<ServicesCubit>().updateFav(isFav, id);
    context.read<LocationCubit>().updateFav(isFav, id);
    context.read<HomeCubit>().updateFav(isFav, id);
    context.read<MyOffersCubit>().updateFav(isFav, id);
  }
}
