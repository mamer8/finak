import 'package:finak/core/exports.dart';
import 'package:finak/features/home/screens/widgets/category_widget.dart';
import 'package:finak/features/home/screens/widgets/custom_search_text_field.dart';
import 'package:finak/features/services/screens/widgets/service_widget.dart';

import '../cubit/cubit.dart';
import '../cubit/state.dart';

class MyOffersScreen extends StatelessWidget {
  const MyOffersScreen({
    super.key,
  });

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
            const CustomSearchTextField(
              isFiler: false,
            ),

            20.h.verticalSpace,
            // categories
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: SizedBox(
                height: getHeightSize(context) * 0.05,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (context, index) {
                    return 10.w.horizontalSpace;
                  },
                  itemBuilder: (context, index) {
                    return CustomCategoryContainer(
                      isSelected: index == 0,
                    );
                  },
                ),
              ),
            ),

            20.h.verticalSpace,
            // services
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: 20.h,
                      left: 12.w,
                      right: 12.w,
                    ),
                    child: const CustomServiceWidget(
                      isOffers: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
