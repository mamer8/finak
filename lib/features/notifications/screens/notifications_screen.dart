import 'package:finak/core/exports.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/notification_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
      var cubit = context.read<NotificationsCubit>();

      return Scaffold(
        appBar: customAppBar(context, title: 'notifications'.tr()),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              return CustomNotificationCard(
                isRead: index.isEven,
              );
            },
          ),
        ),
      );
    });
  }
}
