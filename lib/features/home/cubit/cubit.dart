import 'package:finak/features/home/data/model/home_model.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.api) : super(HomeInitial());

  HomeRepo api;
  GetHomeModel homeModel = GetHomeModel();

  void getHome() async {
    emit(GetHomeLoadingState());
    var response = await api.getHomeData();
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
   updateFav (bool isFav, String id) {
if (homeModel.data != null &&
       homeModel.data!.recommended != null) {
      for (int i = 0;
          i < homeModel.data!.recommended!.length;
          i++) {
        if (
                homeModel
                .data!
                .recommended![i]
                .id
                .toString() ==
            id) {
          homeModel.data!.recommended![i].isFav =
              isFav;
        }
      }
    }
    emit(GetHomeSuccessState());
 }
}
