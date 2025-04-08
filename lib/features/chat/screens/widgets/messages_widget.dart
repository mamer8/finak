import 'package:finak/core/exports.dart';
import 'package:finak/features/chat/data/models/get_rooms_model.dart';
import 'package:finak/features/chat/screens/chat_screen.dart';

class CustomMessagesCard extends StatelessWidget {
  const CustomMessagesCard({
    super.key,
    required this.roomModel,
  });
  final RoomModel roomModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Routes.chatRoute,
            arguments: ChatScreenArguments(
              roomModel.roomId ?? 0,
              roomModel.receiverName,
            ));
      },
      child: Row(
        children: [
          CustomNetworkImage(
              image: roomModel.receiverImage ?? "",
              isUser: true,
              width: 40.w,
              height: 40.w,
              borderRadius: 50.w),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        roomModel.receiverName ?? "",
                        style: getMediumStyle(
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      roomModel.createdAt ?? "",
                      style: getRegularStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
                5.verticalSpace,
                Text(
                  roomModel.type == 1
                      ? "image".tr()
                      : roomModel.lastMessage ?? "",
                  style: getRegularStyle(
                    color: AppColors.grey6,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
