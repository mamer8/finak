import 'package:easy_debounce/easy_debounce.dart';
import 'package:finak/core/exports.dart';
import 'package:finak/core/widgets/no_data_widget.dart';
import 'package:finak/features/home/screens/widgets/category_widget.dart';
import 'package:finak/features/home/screens/widgets/custom_search_text_field.dart';
import 'package:finak/features/services/screens/widgets/service_widget.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';

class MyOffersScreen extends StatefulWidget {
  const MyOffersScreen({
    super.key,
  });

  @override
  State<MyOffersScreen> createState() => _MyOffersScreenState();
}

class _MyOffersScreenState extends State<MyOffersScreen> {
  @override
  void initState() {
    if (context.read<MyOffersCubit>().serviceTypesModel.data == null) {
      context.read<MyOffersCubit>().getServiceTypes();
    }

    context.read<MyOffersCubit>().getMyOffers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyOffersCubit, MyOffersState>(builder: (context, state) {
      var cubit = context.read<MyOffersCubit>();
      return Scaffold(
        appBar: customAppBar(
          context,
          title: 'my_offers'.tr(),
        ),
        body: Column(
          children: [
            10.h.verticalSpace,
            CustomSearchTextField(
              isFiler: false,
              controller: cubit.searchController,
              onChanged: (value) {
                EasyDebounce.debounce(
                    'saerch-offer-debouncer', const Duration(seconds: 1),
                    () async {
                  cubit.getMyOffers();
                });
              },
            ),

            20.h.verticalSpace,

            // categories
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
                  height: getHeightSize(context) * 0.05,
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
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

            20.h.verticalSpace,

            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  cubit.getMyOffers();
                },
                child: state is GetServicesErrorState
                    ? CustomNoDataWidget(
                        message: 'error_happened'.tr(),
                        onTap: () {
                          cubit.getMyOffers();
                        },
                      )
                    : state is GetServicesLoadingState ||
                            cubit.myOffersModel.data == null
                        ? const Center(child: CustomLoadingIndicator())
                        : cubit.myOffersModel.data!.isEmpty
                            ? CustomNoDataWidget(
                                message: 'no_offers'.tr(),
                                onTap: () {
                                  cubit.getMyOffers();
                                },
                              )
                            : ListView.builder(
                                itemCount:
                                    cubit.myOffersModel.data?.length ?? 0,
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
                                          cubit.myOffersModel.data![index],
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
