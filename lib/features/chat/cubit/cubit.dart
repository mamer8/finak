import 'dart:async';
import 'dart:io';

import 'package:finak/features/Auth/data/models/default_model.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/exports.dart';
import '../data/repo.dart';
import 'state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this.api) : super(ChatInitial());

  ChatRepo api;
  TextEditingController messageController = TextEditingController();

  //File? pickedImage;

  Future pickImage({
    required String roomId,
    required String receiverId,
 
  }) async {
    emit(LoadinglogoNewImage());
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      // pickedImage = imageTemporary;
      sendMessage(
        roomId: roomId,
        receiverId: receiverId,
        image: imageTemporary.path,
      );
      emit(LoadedPickedImageState());
    } on PlatformException catch (e) {
      print('error $e');
    }
  }

  sendMessage({
    required String roomId,
    required String receiverId,
    String? image,
  }) async {
    emit(LoadingSendMessageState());

    final res = await api.sendMessage(
      roomId: roomId,
      receiverId: receiverId,
      messageOrPath: image ?? messageController.text,
      type: image != null ? 1 : 0, // 1 for image, 0 for text
    );
    res.fold((l) {
      emit(FailureSendMessageState());
    }, (r) {
      messageController.clear();
      getChat(
        roomId: roomId,
      );
      Timer(Duration(milliseconds: 200), () {
        scrollToLastMessage();
      });

      emit(SuccessSendMessageState());
    });
  }

  DefaultPostModel? getChatModel;

  final ScrollController scrollController = ScrollController();

  scrollToLastMessage() {
    //scrollController.position.maxScrollExtent
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
    emit(ScrollToLastMessageState());
  }

  Future getChat({required String roomId, bool isFirst = false}) async {
    emit(LoadingGetChatState());

    final res = await api.getChat(
      roomId: roomId,
    );
    res.fold((l) {
      emit(FailureGetChatState());
    }, (r) {
      print(r.msg);
      getChatModel = r;
      if (isFirst && getChatModel != null) {
        scrollToLastMessage();
      }
      emit(SuccessGetChatState());
    });
  }
}
