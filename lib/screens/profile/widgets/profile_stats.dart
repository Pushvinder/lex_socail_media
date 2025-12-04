import '../../../config/app_config.dart';
import '../../buy_coins/buy_coins_screen.dart';
import '../profile_controller.dart';

class ProfileStats extends StatelessWidget {
  ProfileStats({
    Key? key,
  }) : super(key: key);

  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                controller.user.value.data?.postCount ?? '0',
                // user.posts.toString(),
                style: GoogleFonts.inter(
                  color: AppColors.textColor3.withOpacity(1),
                  fontSize: FontDimen.dimen15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 2),
                child: Text(
                  AppStrings.profilePosts,
                  style: GoogleFonts.inter(
                    color: AppColors.textColor3.withOpacity(0.7),
                    fontSize: FontDimen.dimen8 + 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                // TODO: UPDATE CONNECTIONS COUNT
                // '21',

                controller.user.value.data?.connCount ?? '0',

                // user.connections.toString(),
                style: GoogleFonts.inter(
                  color: AppColors.textColor3.withOpacity(1),
                  fontSize: FontDimen.dimen15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2, bottom: 2),
                child: Text(
                  AppStrings.profileConnections,
                  style: GoogleFonts.inter(
                    color: AppColors.textColor3.withOpacity(0.7),
                    fontSize: FontDimen.dimen8 + 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
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
              borderRadius: BorderRadius.circular(5),
            ),
            child: SizedBox(
              width: 60,
              height: 22,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => BuyCoinsScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.buyCoins,
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(0.9),
                    fontSize: FontDimen.dimen11,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              Image.asset(
                AppImages.coinIcon,
                width: 18,
                height: 18,
              ),
              const SizedBox(width: 4),
              Text(
                // TODO: UPDATE COINS VALUE
                '234',
                // user.coins.toString(),
                style: GoogleFonts.inter(
                  color: AppColors.textColor3.withOpacity(1),
                  fontSize: FontDimen.dimen13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
