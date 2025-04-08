import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/no_data_widget.dart';
import 'package:finak/features/profile/cubit/cubit.dart';
import 'package:finak/features/profile/cubit/state.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/notification_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({
    super.key,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    context.read<NotificationsCubit>().getNotifications();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
      var cubit = context.read<NotificationsCubit>();

      return Scaffold(
        appBar: customAppBar(context, title: 'notifications'.tr()),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: Center(
            child: state is FailureGetNotificationsState
                ? CustomNoDataWidget(
                    message: 'error_happened'.tr(),
                    onTap: () {
                      cubit.getNotifications();
                    },
                  )
                : state is LoadingGetNotificationsState ||
                        cubit.notificationsModel?.data == null
                    ? const Center(child: CustomLoadingIndicator())
                    : cubit.notificationsModel!.data!.isEmpty
                        ? CustomNoDataWidget(
                            message: 'no_notifications'.tr(),
                            onTap: () {
                              cubit.getNotifications();
                            },
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              await cubit.getNotifications();
                            },
                        
                          child: ListView.builder(
                              itemCount: cubit.notificationsModel!.data!.length,
                              itemBuilder: (context, index) {
                                return CustomNotificationCard(
                                  notificationModel:
                                      cubit.notificationsModel!.data![index],
                                );
                              },
                            ),
                        ),
          ),
        ),
      );
    });
  }
}
