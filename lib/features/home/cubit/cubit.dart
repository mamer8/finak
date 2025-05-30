import 'package:finak/features/home/data/model/home_model.dart';
import 'package:finak/features/location/cubit/location_cubit.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.api) : super(HomeInitial());

  HomeRepo api;
  GetHomeModel homeModel = GetHomeModel();

  void getHome(BuildContext context) async {
    emit(GetHomeLoadingState());

    // Wait until country is set (but avoid infinite loop)
    while (context.read<LocationCubit>().country == null) {
      await Future.delayed(const Duration(seconds: 1));
    }

    final country = context.read<LocationCubit>().country;

    // if (country == 'Unknown') {
    //   emit(GetHomeErrorState());
    //   return;
    // }

    var response = await api.getHomeData(country: country);
    response.fold(
      (failure) {
        emit(GetHomeErrorState());
      },
      (r) {
        homeModel = r;
        emit(GetHomeSuccessState());
      },
    );
  }

  updateFav(bool isFav, String id) {
    if (homeModel.data != null && homeModel.data!.recommended != null) {
      for (int i = 0; i < homeModel.data!.recommended!.length; i++) {
        if (homeModel.data!.recommended![i].id.toString() == id) {
          homeModel.data!.recommended![i].isFav = isFav;
        }
      }
    }
    emit(GetHomeSuccessState());
  }
}
