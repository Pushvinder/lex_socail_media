import 'package:the_friendz_zone/models/interest_response.dart';

import '../../../config/app_config.dart';
import 'community_preferences_controller.dart';

class CommunityPreferencesScreen extends StatelessWidget {
  const CommunityPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommunityPreferencesController());

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
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
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
          AppStrings.communityPreferencesTitle,
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
              // Content scrolls, button stays:
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 17),
                      sectionTitle(
                        AppStrings.communities,
                        AppStrings.communitiesHint,
                      ),
                      Obx(() =>
                          chipGrid(
                            items: controller.communitiesList,
                            selected: controller.selectedCommunities,
                            onTap: controller.toggleCommunity,
                          )
                      ),
                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
              // Spacing before button
              const SizedBox(height: 10),
              // ------- DONE BUTTON -------
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
                    onPressed: controller.onDone,
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
                      AppStrings.doneText,
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
              // For safe spacing
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }
}
