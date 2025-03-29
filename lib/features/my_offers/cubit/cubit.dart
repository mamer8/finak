import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:finak/features/services/data/models/service_types_model.dart';
import 'package:flutter/material.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class MyOffersCubit extends Cubit<MyOffersState> {
  MyOffersCubit(this.api) : super(MyOffersInitial());

  MyOffersRepo api;

  TextEditingController searchController = TextEditingController();
  ServiceTypeModel? selectedServiceType;
  changeSelectedServiceType(ServiceTypeModel? value) {
    selectedServiceType = value;
    emit(ChangeSelectedServiceTypeState());
    getMyOffers();
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
  GetServicesModel myOffersModel = GetServicesModel();
  void getMyOffers() async {
    emit(GetServicesLoadingState());
    var response = await api.getMyOffers(
      serviceTypeId: selectedServiceType?.id,
      search: searchController.text,
    );
    response.fold(
      (failure) {
        emit(GetServicesErrorState());
      },
      (r) {
        myOffersModel = r;
        emit(GetServicesSuccessState());
      },
    );
  }
 updateFav (bool isFav, String id) {
    if (myOffersModel.data != null) {
      for (int i = 0;
          i < myOffersModel.data!.length;
          i++) {
        if (                myOffersModel
                .data![i]
                .id
                .toString() ==
            id) {
          myOffersModel.data![i].isFav = isFav;
        }
      }
    }
    emit(GetServicesSuccessState());
 }
  /// Get Offer Details //////
}
