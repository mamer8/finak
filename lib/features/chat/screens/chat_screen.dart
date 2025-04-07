import 'package:finak/core/exports.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/custom_chat_widget.dart';
import 'widgets/custom_textfield.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // context.read<ChatCubit>().getChat(roomId: '1', isFirst: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatCubit>().scrollToLastMessage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      var cubit = context.read<ChatCubit>();

      return Scaffold(
        appBar: customAppBar(context, title: 'AYA OMAR'),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: ListView.builder(
                    controller: cubit.scrollController,
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) => CustomMessageContainer(
                      isSender: index % 2 == 0,
                      isText: index % 3 == 0,
                      id: index,
                    ),
                  ),
                ),
              ),
              CustomMessageTextField(),
            ],
          ),
        ),
      );
    });
  }
}
