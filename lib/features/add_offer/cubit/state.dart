abstract class AddOfferState {}

class AddOfferInitial extends AddOfferState {}
class SelectServiceState extends AddOfferState {}
class FilePickedSuccessfully extends AddOfferState {}
class FileNotPicked extends AddOfferState {}
class FileRemovedSuccessfully extends AddOfferState {}