import 'package:google_fonts/google_fonts.dart';

import '../config/app_config.dart';

class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;
  final String label;
  final double width;
  final double height;
  final double borderRadius;

  const SocialButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.width = 300,
    this.height = 54,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 50.0,
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 15),
        boxShadow: [
          BoxShadow(
            color: AppColors.textColor1.withOpacity(0.06),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
        border: Border.all(
          color: AppColors.textColor1.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: icon,
              ),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textColor3.withOpacity(0.6),
                  fontSize: FontDimen.dimen13,
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
