import 'package:finak/features/splash/screens/splash_screen.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.api) : super(HomeInitial());

  HomeRepo api;
}
