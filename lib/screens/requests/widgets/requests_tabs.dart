import '../../../config/app_config.dart';

class RequestsTabs extends StatelessWidget {
  final int selectedTab;
  final Function(int) onSelect;
  const RequestsTabs(
      {required this.selectedTab, required this.onSelect, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _tab(AppStrings.connectionTab, 0),
        _tab(AppStrings.communityTab, 1),
        _tab(AppStrings.linkAccountTab, 2),
      ],
    );
  }

  Widget _tab(String label, int idx) => Expanded(
        child: GestureDetector(
          onTap: () => onSelect(idx),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: selectedTab == idx
                      ? AppColors.textColor3.withOpacity(1)
                      : AppColors.secondaryColor,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: FontDimen.dimen13,
                ),
              ),
              const SizedBox(height: 4),
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
