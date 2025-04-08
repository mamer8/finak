import 'dart:async';
import 'dart:developer';

import 'package:finak/core/exports.dart';
import 'package:finak/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/custom_chat_widget.dart';
import 'widgets/custom_textfield.dart';

class ChatScreenArguments {
  final int roomId;
  final String? recieverName;
  final bool isFromNotifation;
  ChatScreenArguments(this.roomId, this.recieverName,
      {this.isFromNotifation = false});
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
  late StreamSubscription<RemoteMessage> _messageSubscription;

  @override
  void initState() {
    super.initState();

    MessageStateManager().enterChatRoom("0");
    // MessageStateManager().enterChatRoom(widget.args.roomId.toString());
  
    context.read<ChatCubit>().getMessages(
          roomId: widget.args.roomId.toString(),
          isFirst: true,
        );

    _messageSubscription = FirebaseMessaging.onMessage.listen((message) {
      log("onMessage in chat: ${message.data.toString()}");
      if (!mounted) return;
      if (message.data['reference_table'] == "rooms" &&
          message.data['reference_id'] == widget.args.roomId.toString()) {
        context.read<ChatCubit>().getMessages(
              roomId: widget.args.roomId.toString(),
              isNotification: true,
            );
      }
    });
  }

  @override
  void dispose() {
    MessageStateManager().leaveChatRoom("0");
    // MessageStateManager().leaveChatRoom(widget.args.roomId.toString());
    _messageSubscription.cancel();
    log("Chat screen disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      var cubit = context.read<ChatCubit>();

      return WillPopScope(
        onWillPop: () async {
          if (widget.args.isFromNotifation) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.mainRoute, (route) => false);
          } else {
            Navigator.pop(context);
          }

          return false;
        },
        child: Scaffold(
          appBar: customAppBar(
            context,
            title: widget.args.recieverName ?? "",
            onBack: () {
              if (widget.args.isFromNotifation) {
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.mainRoute, (route) => false);
              } else {
                Navigator.pop(context);
              }
            },
          ),
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
        ),
      );
    });
  }
}
