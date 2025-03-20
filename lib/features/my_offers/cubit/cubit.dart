import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class MyOffersCubit extends Cubit<MyOffersState> {
  MyOffersCubit(this.api) : super(MyOffersInitial());

  MyOffersRepo api;

}
