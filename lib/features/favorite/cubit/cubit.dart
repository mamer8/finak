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
}
