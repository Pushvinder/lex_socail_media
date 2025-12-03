import '../../../config/app_config.dart';

class ChildDashboardTabs extends StatelessWidget {
  final int selectedTab;
  final Function(int) onSelect;
  const ChildDashboardTabs(
      {required this.selectedTab, required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildTab(AppStrings.recentActivities, 0),
        buildTab(AppStrings.manageSettings, 1),
      ],
    );
  }

  Widget buildTab(String label, int idx) => Expanded(
        child: GestureDetector(
          onTap: () => onSelect(idx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: selectedTab == idx
                      ? AppColors.whiteColor.withOpacity(1)
                      : AppColors.secondaryColor,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: FontDimen.dimen13,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedContainer(
                duration: const Duration(milliseconds: 210),
                height: 2.5,
                width: double.infinity,
                color: selectedTab == idx
                    ? AppColors.textColor3.withOpacity(1)
                    : Colors.transparent,
              ),
            ],
          ),
        ),
      );
}
