import 'package:finak/core/utils/appwidget.dart';
import 'package:finak/features/location/cubit/location_cubit.dart';
import 'package:finak/features/services/data/models/get_service_details_model.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:finak/features/services/data/models/service_types_model.dart';
import 'package:finak/features/services/data/models/sub_service_types_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit(this.api) : super(ServicesInitial());

  ServicesRepo api;

  /// Filter data //////
  bool isPriceRangeEnabled = false;
  RangeValues currentRange = const RangeValues(0, 500);

  void changeRange(RangeValues values) {
    currentRange = values;
    isPriceRangeEnabled = true;
    emit(ChangeRangeState());
  }

  List<String> distances = [
    'closest_to_farthest'.tr(),
    'farthest_to_closest'.tr()
  ];

  String? currentDistance;
  void changeDistance(String value) {
    if (value == currentDistance)
      currentDistance = null;
    else
      currentDistance = value;
    emit(ChangeServiceTypeState());
  }

  void clearFilters() {
    isPriceRangeEnabled = false;
    selectedServiceType = null;
    selectedSubServiceType = null;
    subServiceTypesModel = GetSubServiceTypesModel();
    currentDistance = null;
    emit(ChangeServiceTypeState());
  }

  GetServiceDetailsModel getServiceDetailsModel = GetServiceDetailsModel();
  void getServiceDetails({required String offerId}) async {
    emit(GetServiceDetailsLoadingState());
    var response = await api.getServiceDetails(
      offerId: offerId,
    );
    response.fold(
      (failure) {
        emit(GetServiceDetailsErrorState());
      },
      (r) {
        getServiceDetailsModel = r;
        emit(GetServiceDetailsSuccessState());
      },
    );
  }

  callPhone(String phone) async {
    await launchUrl(Uri.parse('tel:$phone'));
  }

  void closeOffer(BuildContext context, {required String offerId}) async {
    AppWidget.createProgressDialog(context);
    emit(CloseOfferLoadingState());
    var response = await api.closeOffer(
      offerId: offerId,
    );
    response.fold((failure) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(CloseOfferErrorState());
    }, (r) {
      Navigator.pop(context);
      if (r.status != 200 && r.status != 201) {
        errorGetBar(r.msg ?? "error".tr());
      } else {
        successGetBar(r.msg);
        // getServiceDetailsModel.status = 0;

        emit(CloseOfferSuccessState());
        getServiceDetails(offerId: offerId);
      }
    });
  }

  TextEditingController searchController = TextEditingController();
  ServiceTypeModel? selectedServiceType;
  changeSelectedServiceType(ServiceTypeModel? value,
      {bool isFilter = false, required BuildContext context}) {
    if (value == selectedServiceType) {
      selectedServiceType = null;
      subServiceTypesModel = GetSubServiceTypesModel();
      selectedSubServiceType = null;
    } else {
      selectedServiceType = value;
    }

    emit(ChangeSelectedServiceTypeState());
    if (!isFilter) {
      getServices(context);
    } else {
      if (selectedServiceType != null) getSubServiceTypes(value!.id.toString());
    }
  }

  SubServiceTypeModel? selectedSubServiceType;
  void onTapToSelectSubServiceType(SubServiceTypeModel cat) {
    if (selectedSubServiceType == cat) selectedSubServiceType = null;
    else
    selectedSubServiceType = cat;
    emit(ChangeSelectedServiceTypeState());
  }

  /// Get Sub Service Types //////
  GetSubServiceTypesModel subServiceTypesModel = GetSubServiceTypesModel();
  void getSubServiceTypes(String serviceTypeId) async {
    selectedSubServiceType = null;
    subServiceTypesModel = GetSubServiceTypesModel();
    emit(GetSubServiceTypesLoadingState());
    var response = await api.getSubServiceTypes(serviceTypeId);
    response.fold(
      (failure) {
        emit(GetSubServiceTypesErrorState());
      },
      (r) {
        subServiceTypesModel = r;
        emit(GetSubServiceTypesSuccessState());
      },
    );
  }

  /// Get Service Types //////
  GetServiceTypesModel serviceTypesModel = GetServiceTypesModel();
  void getServiceTypes() async {
    serviceTypesModel = GetServiceTypesModel();
    subServiceTypesModel = GetSubServiceTypesModel();
    selectedSubServiceType = null;
    selectedServiceType = null;
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
  void getServices(BuildContext context) async {
    emit(GetServicesLoadingState());
    var response = await api.getServices(
      serviceTypeId: selectedServiceType?.id,
      search: searchController.text,
      minPrice:
          isPriceRangeEnabled ? currentRange.start.round().toString() : null,
      maxPrice:
          isPriceRangeEnabled ? currentRange.end.round().toString() : null,
      lat: context.read<LocationCubit>().currentLocation?.latitude.toString() ??
          '0.0',
      long:
          context.read<LocationCubit>().currentLocation?.longitude.toString() ??
              '0.0',
      type: currentDistance == null
          ? null
          : currentDistance == 'closest_to_farthest'.tr()
              ? 'asc'
              : 'desc', ////asc,desc
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
}
