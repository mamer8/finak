abstract class ServicesState {}

class ServicesInitial extends ServicesState {}
class ChangeRangeState extends ServicesState {}
class ChangeServiceTypeState extends ServicesState {}
class GetServiceTypesLoadingState extends ServicesState {}
class GetSubServiceTypesLoadingState extends ServicesState {}
class GetServiceTypesErrorState extends ServicesState {}
class GetSubServiceTypesErrorState extends ServicesState {}
class GetServiceTypesSuccessState extends ServicesState {}
class GetSubServiceTypesSuccessState extends ServicesState {}
