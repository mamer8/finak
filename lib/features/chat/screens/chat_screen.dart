import 'dart:developer';

import 'package:finak/core/exports.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/custom_chat_widget.dart';
import 'widgets/custom_textfield.dart';

class ChatScreenArguments {
  final int roomId;
  final String? recieverName;
  ChatScreenArguments(this.roomId, this.recieverName);
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.args,
  });
  final ChatScreenArguments args;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    context
        .read<ChatCubit>()
        .getMessages(roomId: widget.args.roomId.toString(), isFirst: true);

    FirebaseMessaging.onMessage.listen((message) {
      log("onMessage: ${message.data.toString()}");
      if (message.data['reference_table'] == "rooms") {
        context.read<ChatCubit>().getMessages(
              roomId: widget.args.roomId.toString(),
              isNotification: true,
            );
      }
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<ChatCubit>().scrollToLastMessage();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      var cubit = context.read<ChatCubit>();

      return Scaffold(
        appBar: customAppBar(context, title: widget.args.recieverName ?? ""),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: cubit.getMessagesModel?.data == null
                        ? const Center(child: CustomLoadingIndicator())
                        : cubit.getMessagesModel?.data?.length == 0
                            ? Center(
                                child: Text(
                                  "no_messages".tr(),
                                  style: getRegularStyle(
                                    color: AppColors.grey2,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                controller: cubit.scrollController,
                                shrinkWrap: true,
                                itemCount:
                                    cubit.getMessagesModel?.data?.length ?? 0,
                                itemBuilder: (context, index) =>
                                    CustomMessageContainer(
                                  messageModel:
                                      cubit.getMessagesModel!.data![index],
                                ),
                              )),
              ),
              CustomMessageTextField(roomId: widget.args.roomId.toString()),
            ],
          ),
        ),
      );
    });
  }
}
