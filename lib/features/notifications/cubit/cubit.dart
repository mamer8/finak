import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.api) : super(NotificationsInitial());

  NotificationsRepo api;
}
