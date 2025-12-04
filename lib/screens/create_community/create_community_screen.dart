import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_friendz_zone/models/interest_response.dart';

import '../../../config/app_config.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
import 'create_community_controller.dart';

class CreateCommunityScreen extends StatelessWidget {
  const CreateCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateCommunityController());
    //final BottomNavController navController = Get.find<BottomNavController>();

    // Helper method to build styled text input
    Widget _buildTextInput({
      required TextEditingController controller,
      required String hintText,
      TextInputType keyboardType = TextInputType.text,
      int? maxLines,
      int? maxLength,
      bool showCharCount = false,
      Widget? suffixIcon,
      bool readOnly = false,
      Function()? onTap,
      void Function(String)? onChanged,
    }) {
      return Stack(
        children: [
          Center(
            child: AppTextField(
              tag: hintText,
              controller: controller,
              keyboardType: keyboardType,
              hintText: hintText,
              maxLines: maxLines,
              maxLength: maxLength,
              style: TextStyle(
                color: AppColors.textColor3.withOpacity(1),
                fontSize: FontDimen.dimen14,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
              hintStyle: TextStyle(
                color: AppColors.textColor2.withOpacity(0.3),
                fontSize: FontDimen.dimen13,
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
              contentPadding: showCharCount && maxLength != null
                  ? const EdgeInsets.fromLTRB(16, 16, 16, 36)
                  : const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              borderRadius: BorderRadius.circular(10),
              suffixIcon: suffixIcon,
              readOnly: readOnly,
              onTap: onTap,
              onChanged: onChanged,
            ),
          ),
          if (showCharCount && maxLength != null)
            Positioned(
              right: 18,
              bottom: 18,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  return Text(
                    '${value.text.characters.length}/$maxLength',
                    style: TextStyle(
                      color: AppColors.textColor2.withOpacity(0.5),
                      fontSize: FontDimen.dimen12,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  );
                },
              ),
            ),
        ],
      );
    }

    Widget _buildChipGrid({
      required List<InterestResponseData> items,
      required List<InterestResponseData> selected,
      required Function(InterestResponseData) onTap,
    }) {
      return Container(
        width: double.infinity,
        // decoration: BoxDecoration(
        //   color: AppColors.bgColor,
        //   borderRadius: BorderRadius.circular(14),
        // ),
        // padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Wrap(
          runSpacing: 9,
          spacing: 18,
          children: [
            for (final item in items)
              Obx(() {
                final bool isSelected = selected.contains(item);
                return RawChip(
                  label: Text(
                    item.name ?? '',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.whiteColor.withOpacity(1)
                          : AppColors.whiteColor.withOpacity(0.5),
                      fontSize: FontDimen.dimen11,
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                  backgroundColor: isSelected
                      ? AppColors.leaveBtnColor.withOpacity(1)
                      : AppColors.scaffoldBackgroundColor,
                  color: WidgetStateProperty.resolveWith<Color>(
                    (states) => isSelected
                        ? AppColors.leaveBtnColor.withOpacity(1)
                        : AppColors.scaffoldBackgroundColor,
                  ),
                  side: BorderSide(
                    color: AppColors.primaryColor
                        .withOpacity(isSelected ? 0.1 : 0.5),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  showCheckmark: false,
                  selected: isSelected,
                  onSelected: (_) => onTap(item),
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity:
                      const VisualDensity(horizontal: -2, vertical: -2),
                  elevation: 0,
                  selectedColor: AppColors.primaryColor.withOpacity(0.08),
                  pressElevation: 0,
                );
              }),
          ],
        ),
      );
    }

    Widget placeholderWidget(){
      return Container(
          height: 138,
          width: 138,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bgColor,
            image:   null,
            boxShadow: [
              BoxShadow(
                color: AppColors.textColor3.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: SizedBox(
              height: 18,
              width: 18,
              child: Image.asset(
                AppImages.profilePicIcon,
                height: 18,
                width: 18,
                fit: BoxFit.contain,
                // color: AppColors.textColor3,
              ),
            ),
          )

      );
    }

    Widget _buildDashedCirclePhotoPicker() {
      return Obx(
        () {
          final img = controller.communityImage.value;
          return GestureDetector(
            onTap: () => controller.pickImageBottomSheet(context),
            child: DottedBorder(
              borderType: BorderType.Circle,
              dashPattern: const [4, 2],
              color: AppColors.primaryColor,
              strokeWidth: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: img.contains('http') ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: img,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                    placeholder: (ctx, _) => Container(
                      color: AppColors.greyShadeColor,
                    ),
                    errorWidget: (ctx, url, error) {
                      return placeholderWidget();
                    },
                  ),
                ) : Container(
                  height: 138,
                  width: 138,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bgColor,
                    image:   img != null && img != ''
                        ? DecorationImage(
                            image: FileImage(File(img)),
                            fit: BoxFit.cover,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textColor3.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 15,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: img == null || img == ''
                      ? Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: SizedBox(
                            height: 18,
                            width: 18,
                            child: Image.asset(
                              AppImages.profilePicIcon,
                              height: 18,
                              width: 18,
                              fit: BoxFit.contain,
                              // color: AppColors.textColor3,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
            ),
          );
        },
      );
    }



    return PopScope(
      canPop: false,
      // onPopInvoked: (didPop) {
      //   // controller.clearData();
      //   Get.delete<CreateCommunityController>();
      //
      //   Get.back();
      // },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        bottomNavigationBar:
            //--- CREATE Button ---
            Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.dimen40,
            vertical: AppDimens.dimen20,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryColor, AppColors.primaryColorShade],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.createCommunity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  controller.isUpdate.value ? AppStrings.createUpdateButton : AppStrings.createCommunityButton,
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
        body: SafeArea(
          child: Column(
            children: [
              // Top AppBar
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 8,
                  right: 8,
                  bottom: 6,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.delete<CreateCommunityController>();

                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Image.asset(
                          AppImages.backArrow,
                          height: 11,
                          width: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          controller.isUpdate.value ? AppStrings.updateCommunityTitle :  AppStrings.createCommunityTitle,
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(1),
                            fontSize: FontDimen.dimen18,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 19),
                  ],
                ),
              ),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.dimen40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppDimens.dimen12),

                        // Profile Image Picker
                        Center(
                          child: _buildDashedCirclePhotoPicker(),
                        ),

                        SizedBox(height: AppDimens.dimen10),

                        //--- Community Name ---
                        Divider(
                          color: AppColors.secondaryColor.withOpacity(0.5),
                          thickness: 1,
                        ),
                        SizedBox(height: AppDimens.dimen12 - 1),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.communityName,
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(1),
                              fontSize: FontDimen.dimen12,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimens.dimen12),
                        _buildTextInput(
                          controller: controller.nameController,
                          hintText: AppStrings.communityNameHint,
                        ),
                        Divider(
                          color: AppColors.secondaryColor.withOpacity(0.5),
                          thickness: 1,
                        ),
                        SizedBox(height: AppDimens.dimen12 - 1),

                        //--- Category ---
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.selectCategory,
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(1),
                              fontSize: FontDimen.dimen12,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimens.dimen12),
                        Obx(
                          () => _buildChipGrid(
                            items: controller.categoriesList,
                            selected: controller.selectedCategories,
                            onTap: controller.toggleCategory,
                          ),
                        ),
                        SizedBox(height: AppDimens.dimen14),
                        Divider(
                          color: AppColors.secondaryColor.withOpacity(0.5),
                          thickness: 1,
                        ),
                        SizedBox(height: AppDimens.dimen14),

                        //--- Description ---
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.communityDescription,
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(1),
                              fontSize: FontDimen.dimen12,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimens.dimen12),
                        _buildTextInput(
                          controller: controller.descriptionController,
                          hintText: AppStrings.communityDescriptionHint,
                          maxLines: 4,
                          maxLength: 300,
                          showCharCount: true,
                        ),
                        SizedBox(height: AppDimens.dimen14),
                        Divider(
                          color: AppColors.secondaryColor.withOpacity(0.5),
                          thickness: 1,
                        ),
                        SizedBox(height: AppDimens.dimen14),

                        //--- Rules ---
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppStrings.communityRules,
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(1),
                              fontSize: FontDimen.dimen12,
                              fontWeight: FontWeight.w500,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimens.dimen12),
                        _buildTextInput(
                          controller: controller.rulesController,
                          hintText: AppStrings.communityRulesHint,
                          maxLines: 4,
                          maxLength: 300,
                          showCharCount: true,
                        ),
                        SizedBox(height: AppDimens.dimen14),

                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
