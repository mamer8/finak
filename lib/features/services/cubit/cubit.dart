import 'package:finak/features/splash/screens/splash_screen.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  ServicesCubit(this.api) : super(ServicesInitial());

  ServicesRepo api;
}
