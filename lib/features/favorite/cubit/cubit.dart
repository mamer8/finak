import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this.api) : super(FavoritesInitial());

  FavoritesRepo api;
}
