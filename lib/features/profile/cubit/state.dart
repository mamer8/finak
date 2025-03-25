abstract class ProfileState {}

class ProfileInitial extends ProfileState {}
class FilePickedSuccessfully extends ProfileState {}
class FileNotPicked extends ProfileState {}
class FileRemovedSuccessfully extends ProfileState {}
class HidePhoneChangedSuccessfully extends ProfileState {}
class GetAccountLoading extends ProfileState {}
class GetAccountError extends ProfileState {}
class GetAccountSuccess extends ProfileState {}
class ProfileChangedSuccessfully extends ProfileState {}