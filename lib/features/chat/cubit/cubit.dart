import 'dart:async';
import 'dart:io';

import 'package:finak/core/utils/appwidget.dart';
import 'package:finak/features/Auth/data/models/default_model.dart';
import 'package:finak/features/chat/data/models/add_message_model.dart';
import 'package:finak/features/chat/data/models/create_room_model.dart';
import 'package:finak/features/chat/data/models/get_messages_model.dart';
import 'package:finak/features/chat/data/models/get_rooms_model.dart';
import 'package:finak/features/services/cubit/cubit.dart';
import 'package:finak/features/services/cubit/state.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import '../screens/chat_screen.dart';
import 'state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this.api) : super(ChatInitial());

  ChatRepo api;
  TextEditingController messageController = TextEditingController();

  //File? pickedImage;

  Future pickImage({
    required String roomId,
  }) async {
    emit(LoadinglogoNewImage());
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      // pickedImage = imageTemporary;
      sendMessage(
        roomId: roomId,
        image: imageTemporary.path,
      );
      emit(LoadedPickedImageState());
    } on PlatformException catch (e) {
      print('error $e');
    }
  }

  AddMessageModel? addMessageModel;
  sendMessage({
    required String roomId,
    String? image,
  }) async {
    String message = messageController.text.trim();
    messageController.clear();
    if (message.isNotEmpty) {
      getMessagesModel?.data?.add(
        MessageModel(
          message: message,
          isMe: 1,
          type: 0,
          id: 0,
        ),
      );
      scrollToLastMessage();
    }
    emit(LoadingSendMessageState());

    final res = await api.sendMessage(
      roomId: roomId,
      messageOrPath: image ?? message,
      type: image != null ? 1 : 0, // 1 for image, 0 for text
    );
    res.fold((l) {
      getMessagesModel?.data?.removeLast();
      emit(FailureSendMessageState());
    }, (r) {
      if (r.data?.message == null) {
        getMessagesModel?.data?.removeLast();
        errorGetBar(r.msg ?? "error".tr());
      } else {
        if (image != null) {
          getMessagesModel?.data?.add(r.data!);
          getMessagesModel?.data?.sort((a, b) => a.id!.compareTo(b.id!));
          scrollToLastMessage();
        } else {
          getMessages(
            roomId: roomId,
          );
          // getMessagesModel?.data?.add(r.data!);
          // getMessagesModel?.data?.sort((a, b) => a.id!.compareTo(b.id!));
        }
        // addMessageModel = r;
        // getMessagesModel?.data?.add(r.data!);
        // getMessagesModel?.data?.sort((a, b) => a.id!.compareTo(b.id!));
        // getMessages(
        //   roomId: roomId,
        // );
      }

      emit(SuccessSendMessageState());
    });
  }

  final ScrollController scrollController = ScrollController();

  scrollToLastMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn);
    });
    emit(ScrollToLastMessageState());
  }

  GetMessagesModel? getMessagesModel;
  getMessages(
      {required String roomId,
      bool isFirst = false,
      bool isNotification = false}) async {
    if (isFirst) {
      messageController.clear();
      getMessagesModel = null;
    }
    emit(LoadingGetChatState());

    final res = await api.getMessages(
      roomId: roomId,
    );
    res.fold((l) {
      emit(FailureGetChatState());
    }, (r) {
      getMessagesModel = r;
      if (isFirst && r.data != null) {
        scrollToLastMessage();
      } else if (isNotification && r.data != null) {
        scrollToLastMessage();
      }
      emit(SuccessGetChatState());
    });
  }

  GetRoomsModel? getRoomsModel;
  getMyChats() async {
    emit(LoadingGetMyChatsState());

    final res = await api.getMyChats();
    res.fold((l) {
      emit(FailureGetMyChatsState());
    }, (r) {
      getRoomsModel = r;
      emit(SuccessGetMyChatsState());
    });
  }

  CreateRoomModel? createRoomModel;
  createRoom(
    BuildContext context, {
    required String recieverId,
    required String recieverName,
  }) async {
    AppWidget.createProgressDialog(context);
    emit(LoadingCreateRoomState());

    final res = await api.createRoom(
      recieverId: recieverId,
    );
    res.fold((l) {
      Navigator.pop(context);
      emit(FailureCreateRoomState());
    }, (r) {
      Navigator.pop(context);
      if (r.data?.roomId != null) {
        Navigator.pushNamed(context, Routes.chatRoute,
            arguments: ChatScreenArguments(
              r.data?.roomId ?? 0,
              recieverName,
            ));
        if (context
                .read<ServicesCubit>()
                .getServiceDetailsModel
                .data
                ?.provider !=
            null) {
          context
              .read<ServicesCubit>()
              .getServiceDetailsModel
              .data!
              .provider!
              .roomId = r.data?.roomId;
          context.read<ServicesCubit>().emit(GetServiceDetailsSuccessState());
        }
      } else {
        errorGetBar(r.msg ?? "error".tr());
      }

      emit(SuccessCreateRoomState());
    });
  }
}
