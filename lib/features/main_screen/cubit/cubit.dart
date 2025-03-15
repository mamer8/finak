import 'package:finak/features/splash/screens/splash_screen.dart';

import '../../../core/exports.dart';
import '../data/main_repo.dart';
import 'state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit(this.api) : super(MainInitial());

  MainRepo api;
  int currentIndex = 0;
  List<Widget> navigationBarViews = [
    Center(
      child: Text('Home'),
    ),
    Center(
      child: Text('Profile'),
    ),
    Center(),
  ];
  void getHomePage() {
    currentIndex = 0;
  }

  void changeNavigationBar(int index) {
    currentIndex = index;
    emit(AppNavBarChangeState());
  }
}
