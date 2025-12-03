import '../../../config/app_config.dart';

class ProfileTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const ProfileTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          height: 28,
          decoration: BoxDecoration(
            color:
                selected ? AppColors.subscriptionBgShade : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: selected
                  ? AppColors.whiteColor
                  : AppColors.textColor3.withOpacity(0.7),
              fontSize: FontDimen.dimen8 + 1,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
