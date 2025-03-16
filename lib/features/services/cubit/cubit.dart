import 'package:finak/features/splash/screens/splash_screen.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit(this.api) : super(ServicesInitial());

  ServicesRepo api;

  /// Filter data //////

  RangeValues currentRange = const RangeValues(140000, 200000);

  void changeRange(RangeValues values) {
    currentRange = values;
    emit(ChangeRangeState());
  }

  List<String> serviceTypes = [
    'Electricity',
    'Gas',
    'Water',
    'Internet',
    'TV',
    'Cleaning',
    'Transportation',
    'Repair',
    'Decoration',
    'Gardening',
    'Home Improvement',
    'Other'
  ];

  String currentServiceType = 'Electricity';
  void changeServiceType(String value) {
    currentServiceType = value;
    emit(ChangeServiceTypeState());
  }

  List<String> categories = ['Rent', 'Sale'];

  String currentCategory = 'Rent';
  void changeCategory(String value) {
    currentCategory = value;
    emit(ChangeServiceTypeState());
  }

  List<String> distances = [
    'closest_to_farthest'.tr(),
    'farthest_to_closest'.tr()
  ];

  String currentDistance = 'closest_to_farthest'.tr();
  void changeDistance(String value) {
    currentDistance = value;
    emit(ChangeServiceTypeState());
  }

  void clearFilters() {
    currentRange = const RangeValues(140000, 200000);
    currentServiceType = 'Electricity';
    currentCategory = 'Rent';
    currentDistance = 'closest_to_farthest'.tr();
    emit(ChangeServiceTypeState());
  }
}
