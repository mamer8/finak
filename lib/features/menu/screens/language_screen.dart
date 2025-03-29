import 'package:finak/core/exports.dart';
import 'package:finak/features/menu/cubit/cubit.dart';
import 'package:finak/features/menu/cubit/state.dart';

// class AppStrings {
//   static const String arabicCode = 'ar';
//   static const String englishCode = 'en';
//   static const String germanCode = 'de';
//   static const String italianCode = 'it';
//   static const String koreanCode = 'ko';
//   static const String russianCode = 'ru';
//   static const String spanishCode = 'es';
// }
class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (BuildContext context, state) {
        final currentLangCode =
            EasyLocalization.of(context)!.locale.languageCode;

        return Scaffold(
          appBar: customAppBar(context, title: 'language'.tr()),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildLanguageOption(
                    isSelected: currentLangCode == 'ar',
                    title: 'اللغه العربيه',
                    value: 'Arabic',
                  ),
                  SizedBox(height: 16),
                  buildLanguageOption(
                    isSelected: currentLangCode == 'en',
                    title: 'English',
                    value: 'English',
                  ),
                  // SizedBox(height: 16),
                  // buildLanguageOption(
                  //   isSelected: currentLangCode == 'de',
                  //   title: 'Deutsch',
                  //   value: 'German',
                  // ),
                  // SizedBox(height: 16),
                  // buildLanguageOption(
                  //   isSelected: currentLangCode == 'it',
                  //   title: 'Italiano',
                  //   value: 'Italian',
                  // ),
                  // SizedBox(height: 16),
                  // buildLanguageOption(
                  //   isSelected: currentLangCode == 'ko',
                  //   title: '한국어',
                  //   value: 'Korean',
                  // ),
                  // SizedBox(height: 16),
                  // buildLanguageOption(
                  //   isSelected: currentLangCode == 'ru',
                  //   title: 'Русский',
                  //   value: 'Russian',
                  // ),
                  // SizedBox(height: 16),
                  // buildLanguageOption(
                  //   isSelected: currentLangCode == 'es',
                  //   title: 'Español',
                  //   value: 'Spanish',
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildLanguageOption(
      {required String title,
      required String value,
      required bool isSelected}) {
    var cubit = context.read<MenuCubit>();
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (BuildContext context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              cubit.changeLanguage(context, value);
            },
            child: ListTile(
              leading: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primary : AppColors.gray,
                size: 24.sp,
              ),
              title: Text(
                title,
                style: getMediumStyle(fontSize: 14.sp),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16.sp, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
// Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2ZpbmFrLnRvcGJ1c2luZXNzLmViaGFyYm9vay5jb20vYXBpL3YxL3VzZXIvcmVnaXN0ZXIiLCJpYXQiOjE3NDMxNzIyMDcsImV4cCI6MTc3NDcwODIwNywibmJmIjoxNzQzMTcyMjA3LCJqdGkiOiJKanM5cUhLa2xydzJFRmJ0Iiwic3ViIjoiMSIsInBydiI6IjIzYmQ1Yzg5NDlmNjAwYWRiMzllNzAxYzQwMDg3MmRiN2E1OTc2ZjcifQ.cbXhmQ8V3X6OIASpkw5a8gg9HClHp-XhtHR6rDSfdVM