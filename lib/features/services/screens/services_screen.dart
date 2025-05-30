import 'package:easy_debounce/easy_debounce.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/no_data_widget.dart';
import 'package:finak/features/home/screens/widgets/category_widget.dart';
import 'package:finak/features/services/data/models/sub_service_types_model.dart';
import 'package:finak/features/services/screens/widgets/custom_search_text_field.dart';
import 'package:finak/features/services/data/models/service_types_model.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';
import 'widgets/filter_widget.dart';
import 'widgets/service_widget.dart';

class ServicesScreenArgs {
  final ServiceTypeModel? selected;
  final SubServiceTypeModel? selectedSubServiceType;

  ServicesScreenArgs( {this.selected , this.selectedSubServiceType});
}

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({
    super.key,
    this.args,
  });
  final ServicesScreenArgs? args;
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  void initState() {
    if (widget.args?.selected != null) {
      context.read<ServicesCubit>().selectedServiceType = widget.args?.selected;
      if (widget.args?.selectedSubServiceType != null) {
        context.read<ServicesCubit>().selectedSubServiceType =
            widget.args?.selectedSubServiceType;
      } else {
        context.read<ServicesCubit>().selectedSubServiceType = null;
      }
      
      
    } else {
      context.read<ServicesCubit>().selectedServiceType = null;
      context.read<ServicesCubit>().selectedSubServiceType = null;
      context.read<ServicesCubit>().subServiceTypesModel =
          GetSubServiceTypesModel();
    }

    if (context.read<ServicesCubit>().serviceTypesModel.data == null) {
      context.read<ServicesCubit>().getServiceTypes();
    }
    context.read<ServicesCubit>().getServices(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<ServicesCubit>();
    return BlocBuilder<ServicesCubit, ServicesState>(builder: (context, state) {
      return Scaffold(
        appBar: customAppBar(
          context,
          title: 'services'.tr(),
        ),
        body: Column(
          children: [
            10.h.verticalSpace,
            CustomSearchTextField(
              controller: cubit.searchController,
              onChanged: (value) {
                EasyDebounce.debounce(
                    'saerch-offers-debouncer', const Duration(seconds: 1),
                    () async {
                  cubit.getServices(context);
                });
              },
            ),
            if (state is GetServicesTypeLoadingState ||
                cubit.serviceTypesModel.data == null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.w),
                child: LinearProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.white,
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SizedBox(
                  height: getHeightSize(context) * 0.09,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: cubit.serviceTypesModel.data!.length,
                    separatorBuilder: (context, index) {
                      return 10.w.horizontalSpace;
                    },
                    itemBuilder: (context, index) {
                      return CustomCategoryContainer(
                        isSelected: cubit.selectedServiceType?.id ==
                            cubit.serviceTypesModel.data![index].id,
                        model: cubit.serviceTypesModel.data![index],
                        onTap: () {
                          cubit.changeSelectedServiceType(
                            cubit.serviceTypesModel.data![index],
                            isGetServices: true,
                            context: context,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            if (state is GetSubServiceTypesLoadingState)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LinearProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.white,
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SizedBox(
                  height: getHeightSize(context) * 0.05,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: cubit.subServiceTypesModel.data?.length ?? 0,
                      separatorBuilder: (context, index) {
                        return 10.w.horizontalSpace;
                      },
                      itemBuilder: (context, index) {
                        return Center(
                          child: CustomTypesWidget(
                            isSelected: cubit.selectedSubServiceType?.id ==
                                cubit.subServiceTypesModel.data![index].id,
                            title:
                                cubit.subServiceTypesModel.data![index].name ??
                                    '',
                            onTap: () {
                              cubit.onTapToSelectSubServiceType(
                                cubit.subServiceTypesModel.data![index],
                                isGetServices: true,
                                context: context,
                              );
                            },
                          ),
                        );
                      }),
                ),
              ),

            // Wrap(
            //   spacing: 10,
            //   runSpacing: 10,
            //   children: (cubit.subServiceTypesModel.data
            //           ?.map(
            //             (e) => CustomTypesWidget(
            //               title: e.name ?? '',
            //               isSelected:
            //                   cubit.selectedSubServiceType?.id == e.id,
            //               onTap: () {
            //                 cubit.onTapToSelectSubServiceType(
            //                   e,
            //                 );
            //               },
            //             ),
            //           )
            //           .toList()) ??
            //       [],
            // ),
            // 20.h.verticalSpace,

            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  cubit.getServices(context);
                },
                child: state is GetServicesErrorState
                    ? CustomNoDataWidget(
                        message: 'error_happened'.tr(),
                        onTap: () {
                          cubit.getServices(context);
                        },
                      )
                    : state is GetServicesLoadingState ||
                            cubit.getServicesModel.data == null
                        ? const Center(child: CustomLoadingIndicator())
                        : cubit.getServicesModel.data!.isEmpty
                            ? CustomNoDataWidget(
                                message: 'no_offers'.tr(),
                                onTap: () {
                                  cubit.getServices(context);
                                },
                              )
                            : ListView.builder(
                                itemCount:
                                    cubit.getServicesModel.data?.length ?? 0,
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 20.h,
                                      left: 12.w,
                                      right: 12.w,
                                    ),
                                    child: CustomServiceWidget(
                                      isOffers: true,
                                      serviceModel:
                                          cubit.getServicesModel.data![index],
                                    ),
                                  );
                                },
                              ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
