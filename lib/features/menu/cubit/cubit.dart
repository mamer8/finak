import 'package:finak/core/preferences/preferences.dart';
import 'package:finak/core/utils/appwidget.dart';
import 'package:finak/features/main_screen/cubit/cubit.dart';

import '../../../core/exports.dart';
import '../data/menu_repo.dart';
import 'state.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit(this.api) : super(MenuInitial());

  MenuRepo api;

  logout(BuildContext context) async {
    emit(LoadingLogoutState());
    AppWidget.createProgressDialog(
      context,
    );
    final response = await api.logout();
    response.fold((l) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(FailureLogoutState());
    }, (r) {
      print("code: ${r.status.toString()}");
      if (r.status != 200 && r.status != 201) {
        Navigator.pop(context);
        prefs.setBool("ISLOGGED", false);

        Preferences.instance.clearUser();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.loginRoute, (route) => false);
      } else {
        Navigator.pop(context);
        successGetBar(r.msg);
        prefs.setBool("ISLOGGED", false);

        Preferences.instance.clearUser();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.loginRoute, (route) => false);
      }
      context.read<MainCubit>().getHomePage();
      emit(SuccessLogoutState());
    });
  }

  deleteAccount(BuildContext context) async {
    emit(LoadingLogoutState());
    AppWidget.createProgressDialog(
      context,
    );
    final response = await api.deleteAccount();
    response.fold((l) {
      Navigator.pop(context);
      errorGetBar("error".tr());
      emit(FailureLogoutState());
    }, (r) {
      print("code: ${r.status.toString()}");
      if (r.status != 200 && r.status != 201) {
        Navigator.pop(context);
        emit(FailureLogoutState());
        errorGetBar(r.msg ?? "error".tr());
      } else {
        Navigator.pop(context);
        successGetBar(r.msg);
        prefs.setBool("ISLOGGED", false);

        Preferences.instance.clearUser();
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.loginRoute, (route) => false);
        context.read<MainCubit>().getHomePage();
      }

      emit(SuccessLogoutState());
    });
  }
}
