import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/no_data_widget.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/messages_widget.dart';

class MyMessagesScreen extends StatefulWidget {
  const MyMessagesScreen({
    super.key,
  });

  @override
  State<MyMessagesScreen> createState() => _MyMessagesScreenState();
}

class _MyMessagesScreenState extends State<MyMessagesScreen> {
  @override
  void initState() {
    context.read<ChatCubit>().getMyChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      var cubit = context.read<ChatCubit>();

      return Scaffold(
        appBar: customAppBar(context, title: 'messages'.tr()),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: Center(
            child: state is FailureGetMyChatsState
                ? CustomNoDataWidget(
                    message: 'error_happened'.tr(),
                    onTap: () {
                      cubit.getMyChats();
                    },
                  )
                : state is LoadingGetMyChatsState ||
                        cubit.getRoomsModel?.data == null
                    ? const Center(child: CustomLoadingIndicator())
                    : cubit.getRoomsModel!.data!.isEmpty
                        ? CustomNoDataWidget(
                            message: 'no_messages'.tr(),
                            onTap: () {
                              cubit.getMyChats();
                            },
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              await cubit.getMyChats();
                            },
                            child: ListView.separated(
                              itemCount: cubit.getRoomsModel!.data!.length,
                              separatorBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Divider(
                                  color: AppColors.primaryGrey,
                                  thickness: 1,
                                ),
                              ),
                              itemBuilder: (context, index) {
                                return CustomMessagesCard(
                                  roomModel: cubit.getRoomsModel!.data![index],
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
