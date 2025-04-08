abstract class ChatState {}

class ChatInitial extends ChatState {}
class LoadedPickedImageState extends ChatState {}

class LoadinglogoNewImage extends ChatState {}
class LoadingSendMessageState extends ChatState {}
class FailureSendMessageState extends ChatState {}
class SuccessSendMessageState extends ChatState {}
class LoadingGetChatState extends ChatState {}
class FailureGetChatState extends ChatState {}
class SuccessGetChatState extends ChatState {}
class ScrollToLastMessageState extends ChatState {}
class LoadingGetMyChatsState extends ChatState {}
class FailureGetMyChatsState extends ChatState {}
class SuccessGetMyChatsState extends ChatState {}
class LoadingCreateRoomState extends ChatState {}
class FailureCreateRoomState extends ChatState {}
class SuccessCreateRoomState extends ChatState {}

