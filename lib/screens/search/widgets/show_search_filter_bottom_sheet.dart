import '../../../config/app_config.dart';
import '../search_controller.dart';

Widget chipGrid({
  required List<String> items,
  required RxList<String> selected,
  required Function(String) onTap,
}) {
  return Container(
    width: double.infinity,
    // decoration: BoxDecoration(
    //   color: AppColors.bgColor,
    //   borderRadius: BorderRadius.circular(14),
    // ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
    child: Obx(
      () => Wrap(
        runSpacing: 9,
        spacing: 20,
        children: [
          for (final item in items)
            RawChip(
              label: Text(
                item,
                style: TextStyle(
                  color: selected.contains(item)
                      ? AppColors.whiteColor.withOpacity(1)
                      : AppColors.whiteColor.withOpacity(0.5),
                  fontSize: FontDimen.dimen11,
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
              ),
              backgroundColor: selected.contains(item)
                  ? AppColors.secondaryColor.withOpacity(1)
                  : AppColors.scaffoldBackgroundColor,
              color: WidgetStateProperty.resolveWith<Color>(
                (states) => selected.contains(item)
                    ? AppColors.secondaryColor.withOpacity(1)
                    : AppColors.scaffoldBackgroundColor,
              ),
              side: BorderSide(
                color: AppColors.primaryColor.withOpacity(
                  selected.contains(item) ? 1.0 : 0.50,
                ),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              showCheckmark: false,
              selected: selected.contains(item),
              onSelected: (_) => onTap(item),
              labelPadding:
                  const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
              elevation: 0,
              selectedColor: AppColors.primaryColor.withOpacity(0.08),
              pressElevation: 0,
            ),
        ],
      ),
    ),
  );
}

// --- Search Filter Bottom Sheet ---
void showSearchFilterBottomSheet(
  BuildContext context,
  SearchUserController controller,
    Function() onTap,
) {
  final bool isPeople = controller.selectedTab.value == 0;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.94,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle Indicator
              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColors.textColor4,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              // Title + Reset
              Row(
                children: [
                  Text(
                    AppStrings.reset,
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(0.0),
                      fontSize: FontDimen.dimen14,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        AppStrings.applyFilter,
                        style: TextStyle(
                          fontFamily: AppFonts.appFont,
                          fontSize: FontDimen.dimen18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColor3.withOpacity(1),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: isPeople
                        ? controller.resetPeopleFilters
                        : controller.resetCommunityFilters,
                    child: Text(
                      AppStrings.reset,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.2),
                        fontSize: FontDimen.dimen14,
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Chips Section
              Expanded(
                child: SingleChildScrollView(
                  child: isPeople
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.interests,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontFamily: GoogleFonts.inter().fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: FontDimen.dimen13,
                              ),
                            ),
                            chipGrid(
                              items: (controller.interestsHobbiesController
                                          ?.interestsList ??
                                      [])
                                  .map((e) => e.name ?? '')
                                  .toList()
                                  .cast<String>(),
                              selected: controller.selectedInterests,
                              onTap: controller.togglePeopleInterest,
                            ),
                            const SizedBox(height: 21),
                            Text(
                              AppStrings.hobbies,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontFamily: GoogleFonts.inter().fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: FontDimen.dimen13,
                              ),
                            ),
                            chipGrid(
                              items: controller
                                      .interestsHobbiesController?.hobbiesList
                                      .map((e) => e.name ?? '')
                                      .toList()
                                      .cast<String>() ??
                                  [],
                              selected: controller.selectedHobbies,
                              onTap: controller.togglePeopleHobby,
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            chipGrid(
                              items: controller
                                  .interestsHobbiesController?.communitiesList
                                  .map((e) => e.name ?? '')
                                  .toList()
                                  .cast<String>() ??
                                  [],
                              selected: controller.selectedCommunityFilters,
                              onTap: controller.toggleCommunityFilter,
                            ),
                          ],
                        ),
                ),
              ),
              // Apply Filter Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColorShade,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                        onTap();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppStrings.applyFilter,
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(0.92),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 9),
            ],
          ),
        ),
      );
    },
  );
}
