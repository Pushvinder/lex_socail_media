import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:the_friendz_zone/models/connection_list_response.dart';

import '../../../config/app_config.dart';

class ConnectionsCardWidget extends StatelessWidget {
  final ConnectionData user;
  final VoidCallback onConnect;
  final VoidCallback onReject;
  final VoidCallback onViewProfile;

  const ConnectionsCardWidget({
    super.key,
    required this.user,
    required this.onConnect,
    required this.onReject,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    List<String> tempInterestNames = [];
    (user.interests ?? [])
        .map((e) => tempInterestNames.add(e.name ?? ''))
        .toList()
        .join(", ");
    String interests = tempInterestNames.join(' ,');
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          // image
          CachedNetworkImage(
            imageUrl: user.profile ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            fadeInDuration: const Duration(milliseconds: 400),
            placeholder: (context, url) =>
                Container(color: AppColors.greyShadeColor),
            errorWidget: (context, url, error) => Container(
              color: AppColors.greyShadeColor,
              child: Icon(
                Icons.person,
                color: AppColors.greyColor,
              ),
            ),
          ),

          // Dark gradient overlay with blur
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 178,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.cardShadow.withOpacity(0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Info and buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 5, 22, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${user.fullname}, ",
                        style: TextStyle(
                          color: AppColors.textColor3.withOpacity(1),
                          fontSize: FontDimen.dimen22,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppFonts.appFont,
                        ),
                      ),
                      Text(
                        "${user.age}",
                        style: TextStyle(
                          color: AppColors.textColor3.withOpacity(1),
                          fontSize: FontDimen.dimen18,
                          fontWeight: FontWeight.w500,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "@${user.username}",
                    style: TextStyle(
                      color: AppColors.textColor3.withOpacity(0.8),
                      fontSize: FontDimen.dimen12,
                      fontWeight: FontWeight.w700,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    interests,
                    style: TextStyle(
                      color: AppColors.textColor3.withOpacity(0.7),
                      fontSize: FontDimen.dimen13,
                      fontWeight: FontWeight.w400,
                      fontFamily: GoogleFonts.inter().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 17),
                  // Bottom actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _bottomAction(
                        icon: AppImages.greenCheck,
                        fillColor: AppColors.connectBg.withOpacity(1),
                        borderColor: Colors.greenAccent,
                        iconColor: Colors.greenAccent,
                        onTap: onConnect,
                        label: AppStrings.connect,
                      ),
                      _bottomAction(
                        icon: AppImages.blueProfile,
                        fillColor: AppColors.viewProfileBg.withOpacity(1),
                        borderColor: AppColors.primaryColor,
                        iconColor: AppColors.primaryColor,
                        onTap: onViewProfile,
                        label: AppStrings.viewProfile,
                      ),
                      _bottomAction(
                        icon: AppImages.rejectRed,
                        fillColor: AppColors.rejectBgColor.withOpacity(1),
                        borderColor: Colors.redAccent,
                        iconColor: Colors.redAccent,
                        onTap: onReject,
                        label: AppStrings.reject,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomAction({
    required String icon,
    required Color fillColor,
    required Color borderColor,
    required Color iconColor,
    required VoidCallback onTap,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: fillColor.withOpacity(0.13),
              shape: BoxShape.circle,
              // border: Border.all(color: borderColor, width: 2.1),
            ),
            child: Image.asset(
              icon,
              height: 26,
              width: 26,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: AppColors.connectionsBtnTextColor.withOpacity(1),
            fontSize: FontDimen.dimen10,
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.inter().fontFamily,
          ),
        ),
      ],
    );
  }
}
