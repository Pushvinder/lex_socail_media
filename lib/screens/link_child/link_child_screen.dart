import '../../config/app_config.dart';
import 'link_child_controller.dart';
import 'widgets/link_child_item.dart';

class LinkChildAccountScreen extends StatelessWidget {
  LinkChildAccountScreen({super.key});
  final controller = Get.put(LinkChildAccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----- Top Bar -----
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimens.dimen16,
                AppDimens.dimen22,
                AppDimens.dimen16,
                AppDimens.dimen2,
              ),
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
                        AppStrings.linkChildAccountTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: FontDimen.dimen18,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.appFont,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: AppDimens.dimen12),
                    child: Image.asset(
                      AppImages.backArrow,
                      height: AppDimens.dimen14,
                      width: AppDimens.dimen14,
                      color: AppColors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimens.dimen20),

            // --- Search box ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen16),
              child: Container(
                height: AppDimens.dimen70,
                decoration: BoxDecoration(
                  color: AppColors.cardBgColor,
                  borderRadius: BorderRadius.circular(AppDimens.dimen15),
                ),
                child: Row(
                  children: [
                    SizedBox(width: AppDimens.dimen30),
                    Image.asset(
                      AppImages.search,
                      width: AppDimens.dimen26,
                      height: AppDimens.dimen26,
                      color: AppColors.whiteColor.withOpacity(1),
                    ),
                    SizedBox(width: AppDimens.dimen12),
                    Expanded(
                      child: TextField(
                        onChanged: controller.onSearch,
                        style: TextStyle(
                          color: AppColors.textColor2.withOpacity(1),
                          fontFamily: GoogleFonts.inter().fontFamily,
                          fontSize: FontDimen.dimen13,
                        ),
                        decoration: InputDecoration(
                          hintText: AppStrings.searchByUsername,
                          hintStyle: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.7),
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontSize: FontDimen.dimen13,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppDimens.dimen6 + 1),

            // --- List ---
            Expanded(
              child: Obx(
                () => controller.isLoadingFriendsList.value
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.textColor5.withOpacity(0.65),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller.filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = controller.filteredUsers[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppDimens.dimen16),
                            child: LinkChildItem(
                              user: user,
                              onTap: () => controller.toggleSelect(index),
                            ),
                          );
                        },
                      ),
              ),
            ),

            // --- Button ---
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.dimen16,
                vertical: AppDimens.dimen30,
              ),
              child: GestureDetector(
                onTap: controller.sendLinkRequest,
                child: Container(
                  width: double.infinity,
                  height: AppDimens.dimen70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColorShade,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      AppStrings.sendLinkRequest,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(0.9),
                        fontSize: FontDimen.dimen15,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimens.dimen10),
          ],
        ),
      ),
    );
  }
}
