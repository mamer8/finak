import 'package:finak/core/exports.dart';
import 'package:finak/features/menu/cubit/cubit.dart';
import 'package:finak/features/menu/cubit/state.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          appBar: customAppBar(context, title: 'privacy_policy'.tr()),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Html(
                    data:
                        context.read<MenuCubit>().settingsModel.data?.privacy ??
                            '')),
          ),
        );
      },
    );
  }
}
