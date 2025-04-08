import 'package:finak/core/exports.dart';
import 'package:finak/features/chat/data/models/get_messages_model.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CustomMessageContainer extends StatelessWidget {
  const CustomMessageContainer({
    super.key,
    required this.messageModel,
  });
  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: messageModel.isMe == 1
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        messageModel.type == 0
            ? BubbleSpecialOne(
                text: messageModel.message ?? "",
                isSender: messageModel.isMe == 1,
                color: messageModel.isMe == 1
                    ? AppColors.primary
                    : AppColors.grey8,
                textStyle: getRegularStyle(
                    fontSize: 16.sp,
                    color: messageModel.isMe == 1
                        ? AppColors.white
                        : AppColors.black),
              )
            : BubbleNormalImage(
                id: id.toString(),
                image: CustomNetworkImage(
                  image: messageModel.message ?? "",

                  width: getWidthSize(context) / 2,
                  // height: getSize(context) / 2,
                ),
                color: messageModel.isMe == 1
                    ? AppColors.primary
                    : AppColors.grey8,
                isSender: messageModel.isMe == 1,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewScreen(
                        imageUrl: messageModel.message ?? "",
                      ),
                    ),
                  );
                },
                tail: true,
              ),
        Container(
          alignment: messageModel.isMe == 1
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            messageModel.createdAt ?? "",
            style: getRegularStyle(
              color: AppColors.grey2,
              fontSize: 12.sp,
            ),
          ),
        )
      ],
    );
  }
}

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: PhotoViewGallery.builder(
            itemCount: 1,
            pageController: PageController(initialPage: 0),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                  imageUrl,
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            }));
  }
}
