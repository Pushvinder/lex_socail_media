import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_friendz_zone/screens/community/models/community_model_response.dart';

import '../../../config/app_config.dart';
import '../../community_feed/community_feed_screen.dart';
import '../models/community_model.dart';

class CommunityCard extends StatelessWidget {
  final CommunityModelData community;
  final int tabIndex;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final VoidCallback? onExplore;
  final VoidCallback? onMenu;
  final VoidCallback? onMember;
  final bool isMemberClickable;

  CommunityCard({
    required this.community,
    required this.tabIndex,
    this.onJoin,
    this.onLeave,
    this.onExplore,
    this.onMenu,
    this.onMember,
    this.isMemberClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.5, bottom: 5),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 12),
            decoration: BoxDecoration(
              color: AppColors.cardBgColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => CommunityFeedScreen(
                              communityName: community.communityName ?? '' , communityId: community.communityId.toString()),
                        );
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.textColor3,
                            radius: 18.5,
                            backgroundImage:
                                NetworkImage(community.communityProfile ?? ''),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            community.communityName ?? '',
                            style: TextStyle(
                              color: AppColors.textColor3.withOpacity(1),
                              fontFamily: AppFonts.appFont,
                              fontWeight: FontWeight.w500,
                              fontSize: FontDimen.dimen14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (tabIndex == 1)
                      GestureDetector(
                        onTap: onLeave,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.leaveBtnColor.withOpacity(1),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            AppStrings.leaveGroup,
                            style: TextStyle(
                              color: AppColors.textColor3.withOpacity(1),
                              fontFamily: GoogleFonts.inter().fontFamily,
                              fontWeight: FontWeight.w500,
                              fontSize: FontDimen.dimen11,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  community.communityDescription ?? '',
                  style: TextStyle(
                    color: AppColors.textColor3.withOpacity(1),
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontWeight: FontWeight.w500,
                    fontSize: FontDimen.dimen12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                if (community.recentPostImages != null &&
                    community.recentPostImages!.isNotEmpty) ...[
                  Text(
                    AppStrings.recentPosts,
                    style: TextStyle(
                      color: AppColors.secondaryColor.withOpacity(1),
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w500,
                      fontSize: FontDimen.dimen12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      itemBuilder: (cxt, imageIndex) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 11),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl:
                                  community.recentPostImages?[imageIndex] ?? '',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 206,
                              fadeInDuration: Duration(milliseconds: 500),
                              placeholder: (context, url) =>
                                  Container(color: AppColors.greyShadeColor),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.greyShadeColor,
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  // if (community.recentPostImages != null &&
                  //     community.recentPostImages!.isNotEmpty)
                  //   Row(
                  //     children: community.recentPostImages!
                  //         .take(2)
                  //         .map(
                  //           (imgUrl) => Padding(
                  //             padding: const EdgeInsets.only(right: 11),
                  //             child: ClipRRect(
                  //               borderRadius: BorderRadius.circular(12),
                  //               child: Image.network(
                  //                 imgUrl,
                  //                 width: 145,
                  //                 height: 92,
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             ),
                  //           ),
                  //         )
                  //         .toList(),
                  //   ),
                ],
                const SizedBox(height: 9),
                Row(
                  children: [
                    GestureDetector(
                      onTap: isMemberClickable ? onMember : null,
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          Text(
                            AppStrings.members,
                            style: TextStyle(
                              color: AppColors.secondaryColor.withOpacity(1),
                              fontFamily: GoogleFonts.inter().fontFamily,
                              fontWeight: FontWeight.w500,
                              fontSize: FontDimen.dimen12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  AppImages.groupIcon,
                                  width: 16,
                                  height: 16,
                                  color: AppColors.textColor3.withOpacity(1),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${(community.joinedMemberCount ?? 0) >= 1000 ? '${((community.joinedMemberCount ?? 0) / 1000).toStringAsFixed(1)}K' : (community.joinedMemberCount ?? 0)}",
                                  style: TextStyle(
                                    color: AppColors.textColor3.withOpacity(1),
                                    fontFamily: GoogleFonts.inter().fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: FontDimen.dimen13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Explore on Joined tab
                    if (tabIndex == 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 21),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: onExplore,
                          child: Row(
                            children: [
                              Text(
                                AppStrings.explore,
                                style: TextStyle(
                                  color: AppColors.textColor3.withOpacity(1),
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontWeight: FontWeight.w600,
                                  fontSize: FontDimen.dimen12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              RotatedBox(
                                quarterTurns: 2,
                                child: Image.asset(
                                  AppImages.backArrow,
                                  width: 10,
                                  height: 10,
                                  color: AppColors.textColor3.withOpacity(1),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    // Join Community on Explore tab
                    if (tabIndex == 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: GestureDetector(
                          onTap: onJoin,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.textColor4),
                            ),
                            child: Text(
                              (community.joinStatus == null ||
                                      community.joinStatus! ==
                                          AppStrings.notRequested)
                                  ? AppStrings.joinCommunity
                                  : community.joinStatus!,
                              style: TextStyle(
                                color: AppColors.textColor3.withOpacity(1),
                                fontWeight: FontWeight.w500,
                                fontFamily: GoogleFonts.inter().fontFamily,
                                fontSize: FontDimen.dimen12,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                )
              ],
            ),
          ),
          // Menu on My Communities tab
          if (tabIndex == 2)
            Positioned(
              top: 0,
              right: 4,
              child: IconButton(
                icon: Image.asset(
                  AppImages.threeDottedMenu,
                  width: 20,
                  height: 20,
                ),
                onPressed: onMenu,
              ),
            ),
        ],
      ),
    );
  }
}
