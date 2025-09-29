import '../../config/app_config.dart';
import 'buy_coins_controller.dart';
import 'widgets/coin_option_tile.dart';

class BuyCoinsScreen extends GetView<BuyCoinsController> {
  BuyCoinsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BuyCoinsController());
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: EdgeInsets.only(right: AppDimens.dimen12),
                      child: Image.asset(
                        AppImages.backArrow,
                        height: AppDimens.dimen14,
                        width: AppDimens.dimen14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        AppStrings.buyCoinsTitle,
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(1),
                          fontSize: FontDimen.dimen18,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.appFont,
                        ),
                      ),
                    ),
                  ),
                  Image.asset(
                    AppImages.calendarIcon,
                    width: 22,
                    height: 22,
                    color: AppColors.whiteColor.withOpacity(0.7),
                  ),
                ],
              ),
            ),
            // Coin Options List
            Expanded(
              child: Obx(
                () => ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.coinOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                  itemBuilder: (context, index) {
                    final item = controller.coinOptions[index];

                    return CoinOptionTile(
                      coins: item['coins']!,
                      price: item['price']!,
                      isSelected: controller.selectedIndex.value == index,
                      onTap: () => controller.selectIndex(index),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
