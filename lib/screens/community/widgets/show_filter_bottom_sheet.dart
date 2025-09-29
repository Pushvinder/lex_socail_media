import 'package:the_friendz_zone/models/interest_response.dart';

import '../../../config/app_config.dart';
import '../community_controller.dart';

Widget chipGrid({
  required List<InterestResponseData> items,
  required RxList<InterestResponseData> selected,
  required Function(InterestResponseData) onTap,
}) {
  return Container(
    width: double.infinity,
    // decoration: BoxDecoration(
    //   color: AppColors.bgColor,
    //   borderRadius: BorderRadius.circular(14),
    // ),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    child: Obx(
      () => Wrap(
        runSpacing: 17,
        spacing: 18,
        children: [
          for (final item in items)
            RawChip(
              label: Text(
                item.name ?? '',
                style: TextStyle(
                  color: selected.contains(item)
                      ? AppColors.whiteColor.withOpacity(1)
                      : AppColors.whiteColor.withOpacity(0.5),
                  fontSize: FontDimen.dimen12,
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
                  const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
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

// ---2. Bottom Sheet code ---
void showFilterBottomSheet(
  BuildContext context,
  CommunityController controller,
) {
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
              // Line Indicator
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
              // Text
              Row(
                children: [
                  Text(
                    AppStrings.reset,
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(0.0),
                      fontSize: FontDimen.dimen14,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w500,
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
                    onTap: controller.resetFilters,
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
              const SizedBox(height: 22),
              // ----------- Scrollable area for chips ----------
              Expanded(
                child: SingleChildScrollView(
                  child: chipGrid(
                    items: controller.filters,
                    selected: controller.selectedFilters,
                    onTap: controller.toggleFilter,
                  ),
                ),
              ),
              // ------------------- Button ---------------------
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
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppStrings.applyFilter,
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(0.92),
                          fontSize: 17,
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
