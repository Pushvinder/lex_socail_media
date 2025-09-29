import '../../../config/app_config.dart';

class CoinOptionTile extends StatelessWidget {
  final String coins;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const CoinOptionTile({
    required this.coins,
    required this.price,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withOpacity(0.22)
              : AppColors.cardBgColor.withOpacity(1),
          borderRadius: BorderRadius.circular(15),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 2)
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
        child: Row(
          children: [
            SizedBox(width: 9),
            // Coins and Price
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: coins,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.whiteColor
                          : AppColors.textColor3.withOpacity(1),
                      fontSize: FontDimen.dimen16,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                  TextSpan(
                    text: ' ${AppStrings.coinsText}',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.textColor3.withOpacity(1)
                          : AppColors.textColor3.withOpacity(0.7),
                      fontSize: FontDimen.dimen16,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                  TextSpan(
                    text: '   $price',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.buyCoinPrice
                          : AppColors.buyCoinPrice.withOpacity(0.7),
                      fontSize: FontDimen.dimen16,
                      fontWeight: FontWeight.w600,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            // Coin Icon
            SizedBox(
              width: 56,
              height: 56,
              child: Center(
                child: Image.asset(
                  AppImages.coinIcon,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
