import 'package:finak/core/exports.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CustomMessageContainer extends StatelessWidget {
  const CustomMessageContainer({
    super.key,
    required this.isSender,
    required this.isText,
    required this.id,
  });
  final bool isSender;
  final bool isText;
  final int id;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          !isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        isText
            ? BubbleSpecialOne(
                text: "i’m fine , how are you",
                isSender: isSender,
                color: isSender ? AppColors.primary : AppColors.grey8,
                textStyle: getRegularStyle(
                    fontSize: 16.sp,
                    color: isSender ? AppColors.white : AppColors.black),
              )
            : BubbleNormalImage(
                id: id.toString(),
                image: CustomNetworkImage(
                  image:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCTY9yQsemri6TJEiZB-2n7UK--Yv5oPw6IA&s",
                  width: getWidthSize(context) / 2,
                  // height: getSize(context) / 2,
                ),
                color: isSender ? AppColors.primary : AppColors.grey8,
                isSender: isSender,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewScreen(
                        imageUrl:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCTY9yQsemri6TJEiZB-2n7UK--Yv5oPw6IA&s",
                      ),
                    ),
                  );
                },
                tail: true,
              )
        // Container(
        //     alignment:
        //         isSender ? Alignment.centerRight : Alignment.centerLeft,
        //     // color: Colors.red,
        //     // width: getSize(context),
        //     child: CustomNetworkImage(
        //       image:
        //           "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCTY9yQsemri6TJEiZB-2n7UK--Yv5oPw6IA&s",
        //       width: getWidthSize(context) / 2,
        //       // height: getSize(context) / 2,
        //     ))
        ,
        Container(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "10:00 AM",
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
