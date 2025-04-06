import 'package:finak/core/exports.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class CustomMessageContainer extends StatelessWidget {
  const CustomMessageContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isSender = true;
    bool isText = true;
    return Column(
      crossAxisAlignment:
          !isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        isText
            ? BubbleSpecialOne(
                text: "HIII",
                isSender: isSender,
                color: isSender ? AppColors.primary : AppColors.grey8,
                textStyle: getRegularStyle(
                    color: isSender ? AppColors.white : AppColors.black),
              )
            : Container(
                alignment:
                    isSender ? Alignment.centerRight : Alignment.centerLeft,
                // color: Colors.red,
                // width: getSize(context),
                child: CustomNetworkImage(
                  image:
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCTY9yQsemri6TJEiZB-2n7UK--Yv5oPw6IA&s",
                  width: getWidthSize(context) / 2,
                  // height: getSize(context) / 2,
                )),
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
