import 'dart:ui';

import '../../../config/app_config.dart';
import 'profile_info_controller.dart';

class ProfileInfoScreen extends GetView<ProfileInfoController> {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileInfoController());

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
                  : const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
              bottom: 12,
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

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          AppStrings.profileInfoTitle,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: FontDimen.dimen22,
            fontWeight: FontWeight.w500,
            fontFamily: AppFonts.appFont,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.dimen40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppDimens.dimen24),

              // Profile Image Picker
              Center(
                child: _buildProfileImagePicker(),
              ),

              SizedBox(height: AppDimens.dimen20),

              // Divider
              Divider(
                color: AppColors.secondaryColor.withOpacity(1),
                thickness: 1,
              ),
              SizedBox(height: AppDimens.dimen6),

              // Username, Date of Birth, and Bio
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.username,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(1),
                        fontSize: FontDimen.dimen14,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.usernameUnique,
                      style: TextStyle(
                        color: AppColors.secondaryColor.withOpacity(1),
                        fontSize: FontDimen.dimen14,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimens.dimen8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: _buildTextInput(
                      controller: controller.usernameController,
                      hintText: AppStrings.usernameHint,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Divider(
                    color: AppColors.secondaryColor.withOpacity(1),
                    thickness: 1,
                  ),
                  SizedBox(height: AppDimens.dimen6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.dob,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(1),
                        fontSize: FontDimen.dimen14,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimens.dimen8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: _buildTextInput(
                      controller: controller.dateOfBirthController,
                      hintText: AppStrings.dateOfBirthHint,
                      readOnly: true,
                      onTap: () => controller.pickDateOfBirth(context),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 14,
                        ),
                        child: Image.asset(
                          AppImages.calendarIcon,
                          height: AppDimens.dimen18,
                          width: AppDimens.dimen18,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: AppColors.secondaryColor.withOpacity(1),
                    thickness: 1,
                  ),
                  SizedBox(height: AppDimens.dimen6 + 1),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppStrings.bio,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(1),
                        fontSize: FontDimen.dimen14,
                        fontWeight: FontWeight.w500,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimens.dimen8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: _buildTextInput(
                      controller: controller.bioController,
                      hintText: AppStrings.bioHint,
                      keyboardType: TextInputType.text,
                      maxLines: 3,
                      maxLength: 300,
                      showCharCount: true,
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(height: AppDimens.dimen10),
                ],
              ),
              // Next Button
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.continueToNext,
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
                      AppStrings.nextText,
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
              SizedBox(height: AppDimens.dimen20),
            ],
          ),
        ),
      ),
    );
  }

  // Profile Image Picker Widget
  Widget _buildProfileImagePicker() {
    return Obx(
      () => GestureDetector(
        onTap: () {
          _showCustomBottomSheet(Get.context!);
        },
        child: DottedBorder(
          borderType: BorderType.Circle,
          dashPattern: const [4, 2],
          color: AppColors.primaryColor,
          strokeWidth: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 118,
              width: 118,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgColor,
                image: controller.profileImage.value != null
                    ? DecorationImage(
                        image: FileImage(controller.profileImage.value!),
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
              child: controller.profileImage.value == null
                  ? Padding(
                      padding: const EdgeInsets.all(40.0),
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
      ),
    );
  }

  // Custom bottom sheet with blur effect
  void _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.secondaryColor.withOpacity(0.5),
      builder: (context) {
        return GestureDetector(
          // Prevents taps inside the sheet from dismissing it
          onTap: () {},
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: AppColors.secondaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle Bar
                  Container(
                    width: 50,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Title
                  Text(
                    "Select profile photo",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: FontDimen.dimen18,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.appFont,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Camera option
                  _buildOptionTile(
                    icon: Icons.camera_alt_rounded,
                    title: "Take a photo",
                    onTap: () {
                      Navigator.pop(context);
                      controller.safePickImage(ImageSource.camera);
                    },
                  ),

                  Divider(height: 1, color: Colors.grey.withOpacity(0.2)),

                  // Gallery option
                  _buildOptionTile(
                    icon: Icons.photo_library_rounded,
                    title: "Choose from gallery",
                    onTap: () {
                      Navigator.pop(context);
                      controller.safePickImage(ImageSource.gallery);
                    },
                  ),

                  SizedBox(height: 20),

                  // Cancel button
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.dimen20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.4),
                          foregroundColor: AppColors.textColor3,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: FontDimen.dimen14,
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method for option tiles
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.dimen20,
          vertical: AppDimens.dimen16,
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: FontDimen.dimen14,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
