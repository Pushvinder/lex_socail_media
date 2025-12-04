import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_friendz_zone/config/app_colors.dart';
import 'package:the_friendz_zone/screens/buy_coins/widgets/coin_option_tile.dart';
import 'package:the_friendz_zone/screens/withdraw_coins/dotted_divider.dart';
import 'package:the_friendz_zone/screens/withdraw_coins/withdraw_coins_controller.dart';
import 'package:the_friendz_zone/utils/app_dimen.dart';
import 'package:the_friendz_zone/utils/app_fonts.dart';
import 'package:the_friendz_zone/utils/app_img.dart';
import 'package:the_friendz_zone/utils/app_strings.dart';

class WithdrawCoinsScreen extends StatelessWidget {
  WithdrawCoinsScreen({super.key});

  final WithdrawCoinsController controller = Get.put(WithdrawCoinsController());

  @override
  Widget build(BuildContext context) {
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
                        AppStrings.requestWithdrawal,
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(1),
                          fontSize: FontDimen.dimen18,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.appFont,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(
                () => Row(
                  children: [
                    buildTab(
                      AppStrings.withdraw,
                      selected: controller.selectedTab.value == 0,
                      onTap: () => controller.switchTab(0),
                    ),
                    buildTab(
                      AppStrings.history,
                      selected: controller.selectedTab.value == 1,
                      onTap: () => controller.switchTab(1),
                    ),
                  ],
                ),
              ),
            ),

            Obx(() => controller.selectedTab.value == 0
                ? withdrawCoins(onTap: (value) {
                    controller.selectedOption.value = value;
                  })
                : withdrawHistory())
          ],
        ),
      ),
    );
  }

  Widget buildTab(
    String text, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    selected ? AppColors.whiteColor : AppColors.secondaryColor,
                fontFamily: GoogleFonts.inter().fontFamily,
                fontWeight: FontWeight.bold,
                fontSize: FontDimen.dimen13,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedContainer(
              duration: const Duration(milliseconds: 210),
              height: 2.5,
              width: double.infinity,
              color: selected
                  ? AppColors.textColor3.withOpacity(1)
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget withdrawCoins({required Function(String coinValue) onTap}) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.selectNumberCoins,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.splashTextColor,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontSize: FontDimen.dimen14,
                  ),
                ),
                SizedBox(height: 20),
                Obx(
                  () => Wrap(
                    runSpacing: 17,
                    spacing: 18,
                    children: [
                      for (final item in controller.coinOptions)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: Offset(0, 3), // Shadow position
                              ),
                            ],
                          ),
                          child: RawChip(
                            avatar: Image.asset(
                              AppImages.coinIcon,
                              width: 40,
                              height: 40,
                            ),
                            label: Text(
                              item['coins'] ?? '',
                              style: TextStyle(
                                color: AppColors.splashTextColor,
                                fontSize: FontDimen.dimen16,
                                fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                            ),
                            backgroundColor:
                                controller.selectedOption.value == item['coins']
                                    ? AppColors.buyCoinPrice.withOpacity(0.75)
                                    : AppColors.cardColor,
                            color: WidgetStateProperty.resolveWith<Color>(
                              (states) => controller.selectedOption.value ==
                                      item['coins']
                                  ? AppColors.buyCoinPrice.withOpacity(0.75)
                                  : AppColors.cardBgColor,
                            ),
                            side: BorderSide(
                              color: AppColors.cardBgColor.withOpacity(
                                controller.selectedOption.value == item['coins']
                                    ? 1.0
                                    : 0.50,
                              ),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            showCheckmark: false,
                            selected: controller.selectedOption.value ==
                                item['coins'],
                            onSelected: (_) => onTap(item['coins'] ?? ''),
                            labelPadding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 1),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: const VisualDensity(
                                horizontal: -2, vertical: -2),
                            elevation: 0.5,
                            selectedColor:
                                AppColors.buyCoinPrice.withOpacity(0.75),
                            pressElevation: 0,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
                  onPressed: () {},
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
                    AppStrings.sendWithdrawalRequest,
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
        ],
      ),
    );
  }

  withdrawHistory() {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: controller.coinOptions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemBuilder: (context, index) {
          final item = controller.coinOptions[index];
          return withdrawHistoryItem();
        },
      ),
    );
  }

  withdrawHistoryItem() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBgColor.withOpacity(1),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Column(
        children: [
          SizedBox(width: 9),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Transaction ID:",
                  style: TextStyle(
                    color: AppColors.splashTextColor.withOpacity(0.3),
                    fontSize: FontDimen.dimen12,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
              Text(
                "45668143546",
                style: TextStyle(
                  color: AppColors.fileSizeColor,
                  fontSize: FontDimen.dimen12,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          DottedLine(
            color: AppColors.buyCoinPrice,
            height: 1,
            gap: 6,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "50000",
                      style: TextStyle(
                        color: AppColors.textColor3.withOpacity(1),
                        fontSize: FontDimen.dimen16,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                    TextSpan(
                      text: ' ${AppStrings.coinsText}',
                      style: TextStyle(
                        color: AppColors.textColor3.withOpacity(0.7),
                        fontSize: FontDimen.dimen16,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 7),
              SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: Image.asset(
                    AppImages.coinIcon,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              Spacer(),
              Text(
                 "\$36.0",
                style: TextStyle(
                  color: AppColors.textColor3.withOpacity(1),
                  fontSize: FontDimen.dimen18,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.inter().fontFamily,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Aug 24, 2025",
                  style: TextStyle(
                    color: AppColors.splashTextColor.withOpacity(0.3),
                    fontSize: FontDimen.dimen14,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
        Text(
          "Withdrawal Successful",
          style: TextStyle(
            color: AppColors.splashTextColor.withOpacity(0.3),
            fontSize: FontDimen.dimen14,
            fontFamily: GoogleFonts.inter().fontFamily,
          ),
        ),
            ],
          )
        ],
      ),
    );
  }
}
