import '../../config/app_config.dart';
import 'community_profile_controller.dart';
import 'models/community_profile_model.dart';
import 'widgets/community_member_tile.dart';

class CommunityProfileScreen extends StatelessWidget {
  final bool isEdit;
  final CommunityProfileModel community;

  const CommunityProfileScreen(
      {Key? key, this.isEdit = false, required this.community})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommunityProfileController>(
      init: CommunityProfileController()..initializedData(community),
      builder: (controller) {
        var c = controller.communityProfileModel;

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackgroundColor,
          body: SafeArea(
            child: controller.communityProfileModel == null
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textColor5.withOpacity(0.65),
                    ),
                  )
                : Column(
                    children: [
                      // --- Custom AppBar Row ---
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                          left: 8,
                          right: 8,
                          bottom: 6,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
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
                                  AppStrings.communityProfile,
                                  style: TextStyle(
                                    color: AppColors.textColor3.withOpacity(1),
                                    fontSize: FontDimen.dimen18,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppFonts.appFont,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            // --- Edit Icon (only if isEdit is true) ---
                            if (isEdit)
                              GestureDetector(
                                onTap: () => controller
                                    .editCommunity(controller.communityProfileModel),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Image.asset(
                                    AppImages.editIcon,
                                    height: 18,
                                    width: 18,
                                  ),
                                ),
                              ),

                            if (!isEdit) const SizedBox(width: 18),
                          ],
                        ),
                      ),

                      // --- Scrolling Content ---
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: AppDimens.dimen12),

                              // --- Community Image ---
                              Center(
                                child: Container(
                                  width: 135,
                                  height: 135,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.secondaryColor,
                                      width: 3,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          c?.data.communityProfile ?? ''),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: AppDimens.dimen14),

                              // --- Community Name ---
                              Text(
                                c?.data.communityName ?? '',
                                style: TextStyle(
                                  color: AppColors.textColor3.withOpacity(1),
                                  fontSize: FontDimen.dimen18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: AppFonts.appFont,
                                ),
                              ),
                              SizedBox(height: AppDimens.dimen8 - 1),

                              // --- Divider ---
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color:
                                      AppColors.secondaryColor.withOpacity(0.5),
                                  thickness: 1,
                                  height: 1,
                                ),
                              ),

                              // --- Description Section ---
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: double.infinity),
                                    Text(
                                      AppStrings.description,
                                      style: TextStyle(
                                        color: AppColors.secondaryColor
                                            .withOpacity(1),
                                        fontSize: FontDimen.dimen12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.inter().fontFamily,
                                      ),
                                    ),
                                    SizedBox(height: AppDimens.dimen5),
                                    Text(
                                      c?.data.communityDescription ?? '',
                                      style: TextStyle(
                                        color: AppColors.textColor3
                                            .withOpacity(0.7),
                                        fontSize: FontDimen.dimen10,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.inter().fontFamily,
                                        height: 1.71,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: AppDimens.dimen2),

                              // --- Divider ---
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color:
                                      AppColors.secondaryColor.withOpacity(0.5),
                                  thickness: 1,
                                  height: 1,
                                ),
                              ),
                              SizedBox(height: AppDimens.dimen5),

                              // --- Rules Section ---
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: double.infinity),
                                    Text(
                                      AppStrings.rulesOfCommunity,
                                      style: TextStyle(
                                        color: AppColors.secondaryColor
                                            .withOpacity(1),
                                        fontSize: FontDimen.dimen12,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.inter().fontFamily,
                                      ),
                                    ),
                                    SizedBox(height: AppDimens.dimen5),
                                    Text(
                                      c!.data.communityRules,
                                      style: TextStyle(
                                        color: AppColors.textColor3
                                            .withOpacity(0.7),
                                        fontSize: FontDimen.dimen10,
                                        fontWeight: FontWeight.w500,
                                        fontFamily:
                                            GoogleFonts.inter().fontFamily,
                                        height: 1.75,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // --- Divider ---
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Divider(
                                  color:
                                      AppColors.secondaryColor.withOpacity(0.5),
                                  thickness: 1,
                                  height: 5,
                                ),
                              ),

                              // --- Members Section ---
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppStrings.members,
                                          style: TextStyle(
                                            color: AppColors.secondaryColor
                                                .withOpacity(1),
                                            fontSize: FontDimen.dimen12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily:
                                                GoogleFonts.inter().fontFamily,
                                          ),
                                        ),
                                        SizedBox(height: AppDimens.dimen8 + 1),
                                        Row(
                                          children: [
                                            Image.asset(
                                              AppImages.groupIcon,
                                              width: 16,
                                              height: 16,
                                              color: AppColors.textColor3
                                                  .withOpacity(1),
                                            ),
                                            SizedBox(width: AppDimens.dimen6),
                                            Text(
                                              "${controller.membersList.length >= 1000 ? '${(controller.membersList.length / 1000).toStringAsFixed(1)}K' : controller.membersList.length}",
                                              style: TextStyle(
                                                color: AppColors.textColor3
                                                    .withOpacity(1),
                                                fontFamily: GoogleFonts.inter()
                                                    .fontFamily,
                                                fontWeight: FontWeight.w500,
                                                fontSize: FontDimen.dimen13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AppDimens.dimen4),

                                    // --- Member List ---
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: controller.membersList.length,
                                      itemBuilder: (context, idx) {
                                        final member = controller.membersList[idx];
                                        return CommunityMemberTile(
                                          member: member,
                                          showRemove: isEdit,
                                          loader: controller.loaderId.value == member.id.toString(),
                                          onRemove: () =>
                                              controller.removeMember(member.id.toString(), controller.communityProfileModel.data.communityId),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // --- Bottom Buttons ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: isEdit
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // --- Divider ---
                                  Divider(
                                    color: AppColors.secondaryColor
                                        .withOpacity(0.5),
                                    thickness: 1,
                                    height: 5,
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: controller.inviteMembers,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.textColor4
                                            .withOpacity(0.5),
                                        elevation: 0,
                                        padding: EdgeInsets.symmetric(
                                            vertical: AppDimens.dimen14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDimens.dimen8),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            AppStrings.inviteMembers,
                                            style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontFamily: GoogleFonts.inter()
                                                  .fontFamily,
                                              fontWeight: FontWeight.w500,
                                              fontSize: FontDimen.dimen15,
                                            ),
                                          ),
                                          SizedBox(width: AppDimens.dimen10),
                                          Image.asset(
                                            AppImages.inviteIcon,
                                            height: AppDimens.dimen26,
                                            width: AppDimens.dimen26,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: () => controller
                                          .deleteCommunity(controller.communityProfileModel
                                              .data.communityId),
                                      child: Text(
                                        AppStrings.deleteCommunity,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily:
                                              GoogleFonts.inter().fontFamily,
                                          fontWeight: FontWeight.w500,
                                          fontSize: FontDimen.dimen15,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.rejectBgColor
                                            .withOpacity(0.3),
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // --- Divider ---
                                  Divider(
                                    color: AppColors.secondaryColor
                                        .withOpacity(0.5),
                                    thickness: 1,
                                    height: 5,
                                  ),
                                  const SizedBox(height: 10),
                                  // --- Leave Group Button ---
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: controller.leaveGroup,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.textColor4
                                            .withOpacity(0.5),
                                        elevation: 0,
                                        padding: EdgeInsets.symmetric(
                                          vertical: AppDimens.dimen14,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text(
                                        AppStrings.leaveGroup,
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontFamily:
                                              GoogleFonts.inter().fontFamily,
                                          fontWeight: FontWeight.w500,
                                          fontSize: FontDimen.dimen15,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10),
                                ],
                              ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
