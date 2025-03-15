import 'package:finak/features/splash/screens/splash_screen.dart';

import '../../../core/exports.dart';
import '../data/menu_repo.dart';
import 'state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit(this.api) : super(MenuInitial());

  MenuRepo api;

}
