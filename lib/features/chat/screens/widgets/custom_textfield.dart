import 'package:easy_localization/easy_localization.dart';
import 'package:finak/core/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../cubit/cubit.dart';
import '../../cubit/state.dart';

class CustomMessageTextField extends StatefulWidget {
  CustomMessageTextField({
    super.key,
  });

  @override
  State<CustomMessageTextField> createState() => _CustomMessageTextFieldState();
}

class _CustomMessageTextFieldState extends State<CustomMessageTextField> {
  // FocusNode myFocusNode = FocusNode();
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatCubit cubit = context.read<ChatCubit>();
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Flexible(
              child: CustomTextField(
                controller: cubit.messageController,
                hintText: 'enter_your_message'.tr(),
                onChanged: (value) {
                  setState(() {
                    cubit.messageController.text = value;
                  });
                  // if (value.isNotEmpty) {
                  //   cubit.changeSendButtonState(true);
                  // } else {
                  //   cubit.changeSendButtonState(false);
                  // }
                },
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () async {
                cubit.messageController.text.isNotEmpty
                    ? await cubit.sendMessage(
                        receiverId: "5",
                        roomId: "5",
                      )
                    : await cubit.pickImage(
                        receiverId: "5",
                        roomId: "5",
                      );
              },
              child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..scale(
                        context.locale.languageCode == 'ar' ? -1.0 : 1.0, 1.0),
                  child: Icon(
                    cubit.messageController.text.isNotEmpty
                        ? CupertinoIcons.paperplane_fill
                        : Icons.photo_camera,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
