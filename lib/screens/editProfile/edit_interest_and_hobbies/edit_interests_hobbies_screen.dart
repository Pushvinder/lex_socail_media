import 'package:the_friendz_zone/models/interest_response.dart';

import '../../../config/app_config.dart';
import 'edit_interests_hobbies_controller.dart';

class EditInterestsHobbiesScreen extends StatelessWidget {
  EditInterestsHobbiesScreen({super.key});

  final controller = Get.put(EditInterestsHobbiesController());

  Widget sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.whiteColor.withOpacity(1),
            fontSize: FontDimen.dimen14,
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.inter().fontFamily,
          ),
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            subtitle,
            style: TextStyle(
              color: AppColors.secondaryColor.withOpacity(1),
              fontSize: FontDimen.dimen14,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.inter().fontFamily,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget chipGrid({
    required List<InterestResponseData> items,
    required List<InterestResponseData> selected,
    required Function(InterestResponseData) onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Wrap(
        runSpacing: 9,
        spacing: 18,
        children: [
          for (final item in items)
            Obx(() {
              final bool isSelected = selected.contains(item);
              return RawChip(
                label: Text(
                  item.name ?? '',
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.whiteColor.withOpacity(1)
                        : AppColors.whiteColor.withOpacity(0.5),
                    fontSize: FontDimen.dimen11,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
                backgroundColor: isSelected
                    ? AppColors.leaveBtnColor.withOpacity(1)
                    : AppColors.scaffoldBackgroundColor,
                color: WidgetStateProperty.resolveWith<Color>(
                  (states) => isSelected
                      ? AppColors.leaveBtnColor.withOpacity(1)
                      : AppColors.scaffoldBackgroundColor,
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryColor.withOpacity(0.30)
                      : AppColors.primaryColor.withOpacity(0.50),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                showCheckmark: false,
                selected: isSelected,
                onSelected: (_) => onTap(item),
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity:
                    const VisualDensity(horizontal: -2, vertical: -2),
                elevation: 0,
                selectedColor: AppColors.primaryColor.withOpacity(0.08),
                pressElevation: 0,
              );
            }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.scaffoldBackgroundColor,
        automaticallyImplyLeading: true,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: AppDimens.dimen60,
              width: AppDimens.dimen60,
              decoration: BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: Image.asset(
                  AppImages.backArrow,
                  height: AppDimens.dimen20,
                  width: AppDimens.dimen20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          AppStrings.editInterestHobbiesTitle,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: FontDimen.dimen22,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.appFont,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // ------ INTERESTS -------
                      sectionTitle(
                        AppStrings.interests,
                        AppStrings.interestsHint,
                      ),
                      Obx(
                        () => chipGrid(
                          items: controller.interestsList,
                          selected: controller.selectedInterests,
                          onTap: controller.toggleInterest,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // ------- HOBBIES -------
                      sectionTitle(
                        AppStrings.hobbies,
                        AppStrings.hobbiesHint,
                      ),
                      Obx(
                        () => chipGrid(
                          items: controller.hobbiesList,
                          selected: controller.selectedHobbies,
                          onTap: controller.toggleHobby,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // ------- NEXT BUTTON -------
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColorShade,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppStrings.nextText,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.9),
                        fontSize: FontDimen.dimen15,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }
}
