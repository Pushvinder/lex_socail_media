import '../../../config/app_config.dart';

class ProfileStatItem extends StatelessWidget {
  final String label;
  final String value;
  const ProfileStatItem({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            color: AppColors.textColor3.withOpacity(1),
            fontSize: FontDimen.dimen15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textColor3.withOpacity(0.7),
            fontSize: FontDimen.dimen10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
