import '../../config/app_config.dart';
import 'models/community_profile_model.dart';

class CommunityProfileController extends GetxController {
  late CommunityProfileModel community;

  @override
  void onInit() {
    super.onInit();
    community = CommunityProfileModel(
      id: '1',
      name: 'Gamers Hub',
      imageUrl:
          'https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=400&q=80',
      description:
          "Whether you're a casual player or a hardcore pro, this is your ultimate gaming destination! Discuss the latest game releases, share winning strategies, exchange tips, and stay updated on industry news. Connect with fellow gamers, join exciting tournaments, and level up your gaming experience together!",
      rules:
          "– Treat everyone with kindness and respect. No hate speech, bullying, or harassment.\n– Keep discussions relevant to the community’s theme.\n– Avoid excessive promotions or irrelevant links.\n– No fake news, misinformation, or inappropriate content.\n– Don’t share personal information of yourself or others.",
      membersCount: 2500,
      members: [
        CommunityMember(
          id: '1',
          name: 'Brody Cora',
          avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        ),
        CommunityMember(
          id: '2',
          name: 'Cameron Emma',
          avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
        ),
        CommunityMember(
          id: '3',
          name: 'Callum Ezra',
          avatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
        ),
        CommunityMember(
          id: '4',
          name: 'Danielle Ezra',
          avatarUrl: 'https://randomuser.me/api/portraits/women/68.jpg',
        ),
        CommunityMember(
          id: '5',
          name: 'Brayden Cole',
          avatarUrl: 'https://randomuser.me/api/portraits/men/41.jpg',
        ),
        CommunityMember(
          id: '6',
          name: 'Cameron Cora',
          avatarUrl: 'https://randomuser.me/api/portraits/men/42.jpg',
        ),
        CommunityMember(
          id: '7',
          name: 'Avery Everett',
          avatarUrl: 'https://randomuser.me/api/portraits/women/43.jpg',
        ),
      ],
    );
  }

  void removeMember(String memberId) {
    community.members.removeWhere((m) => m.id == memberId);
    update();
  }

  void inviteMembers() {
    // invite logic
  }

  void leaveGroup() {
    // leave group logic
    AppDialogs.showConfirmationDialog(
      title: AppStrings.dialogLeaveGroupTitle,
      description: AppStrings.dialogLeaveGroupDescription,
      iconAsset: AppImages.groupIcon,
      iconBgColor: AppColors.redColor.withOpacity(0.13),
      iconColor: AppColors.redColor,
      confirmButtonText: AppStrings.leaveGroup,
      confirmButtonColor: AppColors.redColor,
      onConfirm: () {
        // logic to leave
        Get.back();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.cardBehindBg,
            content: Text(
              AppStrings.leftCommunitySnackbar,
              style: TextStyle(
                color: AppColors.redColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteCommunity() {
    // delete logic
  }

  void editCommunity() {
    // edit logic
  }
}
