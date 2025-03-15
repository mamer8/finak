class UploadImageState {}

 class UploadImageInitial extends UploadImageState {}
class FilePickError extends UploadImageState {

 final String message;

 FilePickError(this.message);
}
class FilePickCancelled   extends UploadImageState {}
class FilePickedSuccessfully extends UploadImageState {
 final String filePath;
 final String base64String;

 FilePickedSuccessfully(this.filePath, this.base64String);
}
class FileRemovedSuccessfully extends UploadImageState {}
class UpdateProfileError   extends UploadImageState {}
class UpdateProfileImagePicked extends UploadImageState {

}