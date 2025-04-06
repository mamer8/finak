import 'package:finak/core/exports.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/messages_widget.dart';

class MyMessagesScreen extends StatelessWidget {
  const MyMessagesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      var cubit = context.read<ChatCubit>();

      return Scaffold(
        appBar: customAppBar(context, title: 'messages'.tr()),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: ListView.separated(
            itemCount: 8,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                color: AppColors.primaryGrey,
                thickness: 1,
              ),
            ),
            itemBuilder: (context, index) {
              return CustomMessagesCard();
            },
          ),
        ),
      );
    });
  }
}
