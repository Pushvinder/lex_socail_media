import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import '../../../config/app_config.dart';

class ActivityCard_PostLiked extends StatelessWidget {
  final Map<String, dynamic> data;
  const ActivityCard_PostLiked({
    required this.data,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return CardBase(
      title: AppStrings.recentPostLiked,
      iconAsset: AppImages.like,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  imageUrl: data['userAvatar'],
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  placeholder: (ctx, _) => Container(
                    color: AppColors.greyShadeColor,
                  ),
                  errorWidget: (ctx, url, error) => Container(
                    color: AppColors.greyShadeColor,
                    child: Icon(
                      Icons.person,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['userName'] ?? '',
                    style: TextStyle(
                      color: AppColors.textColor3.withOpacity(1),
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.bold,
                      fontSize: FontDimen.dimen10,
                    ),
                  ),
                  Text(
                    data['userHandle'] ?? '',
                    style: TextStyle(
                      color: AppColors.textColor4.withOpacity(1),
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: FontDimen.dimen8,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            data['postText'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textColor3.withOpacity(0.9),
              fontFamily: GoogleFonts.inter().fontFamily,
              fontWeight: FontWeight.w400,
              fontSize: FontDimen.dimen8,
            ),
          ),
          SizedBox(height: 8),
          // Image + likes
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: data['postImage'],
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (ctx, _) =>
                        Container(color: AppColors.greyShadeColor),
                    errorWidget: (ctx, url, error) => Container(
                      color: AppColors.greyShadeColor,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 2.2),
                        decoration: BoxDecoration(
                          color: AppColors.scaffoldBackgroundColor
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.filledLike,
                              color: AppColors.whiteColor,
                              width: 18,
                              height: 18,
                            ),
                            SizedBox(width: 3),
                            Text(
                              "${(data['likes'] / 1000).toStringAsFixed(0)}K",
                              style: TextStyle(
                                fontFamily: GoogleFonts.inter().fontFamily,
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w500,
                                fontSize: FontDimen.dimen12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityCard_Comment extends StatelessWidget {
  final Map<String, dynamic> data;
  const ActivityCard_Comment({required this.data, super.key});
  @override
  Widget build(BuildContext context) {
    return CardBase(
      title: AppStrings.recentComment,
      iconAsset: AppImages.comments,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['postSnippet'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textColor3.withOpacity(0.9),
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.w400,
                  fontSize: FontDimen.dimen11,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 3),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: AppDimens.dimen30,
                  decoration: BoxDecoration(
                    color: AppColors.subscriptionBgShade,
                    borderRadius: BorderRadius.circular(AppDimens.dimen8),
                  ),
                  child: Center(
                    child: Text(
                      AppStrings.viewPost,
                      style: TextStyle(
                        color: AppColors.textColor3.withOpacity(1),
                        fontFamily: GoogleFonts.inter().fontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: FontDimen.dimen12,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 9),
              Text(
                "${AppStrings.commentLabel}",
                style: TextStyle(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: AppColors.primaryColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: FontDimen.dimen11,
                ),
              ),
              SizedBox(height: 3),
              Text(
                data['comment'] ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textColor3.withOpacity(1),
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: FontDimen.dimen11,
                  height: 1.3,
                ),
              ),
              SizedBox(height: AppDimens.dimen20),
            ],
          ),
          Positioned(
            top: 0,
            bottom: -145,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Text(
                  data['time'] ?? '',
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    color: AppColors.textColor4.withOpacity(1),
                    fontWeight: FontWeight.w500,
                    fontSize: FontDimen.dimen11,
                  ),
                ),
                Spacer(),
                Text(
                  data['date'] ?? '',
                  style: TextStyle(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    color: AppColors.textColor4.withOpacity(1),
                    fontWeight: FontWeight.w500,
                    fontSize: FontDimen.dimen11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityCard_Chat extends StatelessWidget {
  final Map<String, dynamic> data;
  const ActivityCard_Chat({required this.data, super.key});
  @override
  Widget build(BuildContext context) {
    return CardBase(
      title: AppStrings.lastChatActivity,
      iconAsset: AppImages.messageUnselected,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: data['avatar'],
                width: 29,
                height: 29,
                fit: BoxFit.cover,
                placeholder: (ctx, _) => Container(
                  color: AppColors.greyShadeColor,
                ),
                errorWidget: (ctx, url, error) => Container(
                  color: AppColors.greyShadeColor,
                  child: Icon(
                    Icons.person,
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2),
          Center(
            child: Text(
              data['name'] ?? '',
              style: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                color: AppColors.textColor3.withOpacity(1),
                fontWeight: FontWeight.w600,
                fontSize: FontDimen.dimen11,
              ),
            ),
          ),
          SizedBox(height: AppDimens.dimen14),
          Text(
            AppStrings.sent,
            style: TextStyle(
              fontFamily: GoogleFonts.inter().fontFamily,
              color: AppColors.textColor4.withOpacity(1),
              fontWeight: FontWeight.w500,
              fontSize: FontDimen.dimen11,
            ),
          ),
          SizedBox(height: 1),
          Text(
            data['lastMessage'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: GoogleFonts.inter().fontFamily,
              color: AppColors.textColor3.withOpacity(1),
              fontWeight: FontWeight.w400,
              fontSize: FontDimen.dimen11,
              height: 1.55,
            ),
          ),
          Spacer(),
          Row(
            children: [
              Text(
                data['time'] ?? '',
                style: TextStyle(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: AppColors.textColor4.withOpacity(1),
                  fontWeight: FontWeight.w500,
                  fontSize: FontDimen.dimen11,
                ),
              ),
              Spacer(),
              Text(
                data['date'] ?? '',
                style: TextStyle(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: AppColors.textColor4.withOpacity(1),
                  fontWeight: FontWeight.w500,
                  fontSize: FontDimen.dimen11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActivityCard_Request extends StatelessWidget {
  final Map<String, dynamic> data;
  const ActivityCard_Request({required this.data, super.key});
  @override
  Widget build(BuildContext context) {
    return CardBase(
      title: AppStrings.connectionRequest,
      iconAsset: AppImages.profileAdd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl: data['avatar'],
                width: 29,
                height: 29,
                fit: BoxFit.cover,
                placeholder: (ctx, _) => Container(
                  color: AppColors.greyShadeColor,
                ),
                errorWidget: (ctx, url, error) => Container(
                  color: AppColors.greyShadeColor,
                  child: Icon(
                    Icons.person,
                    color: AppColors.greyColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 2),
          Center(
            child: Text(
              data['name'] ?? '',
              style: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                color: AppColors.textColor3.withOpacity(1),
                fontWeight: FontWeight.w600,
                fontSize: FontDimen.dimen11,
              ),
            ),
          ),
          SizedBox(height: 9),
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.rejectBgColor.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: AppColors.rejectBgColor.withOpacity(0.10),
                    width: 1.3,
                  ),
                ),
                child: Center(
                  child: Text(
                    AppStrings.decline,
                    style: TextStyle(
                      color: AppColors.textColor3.withOpacity(0.70),
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: FontDimen.dimen11,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.connectBg.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: AppColors.connectBg.withOpacity(0.10),
                    width: 1.3,
                  ),
                ),
                child: Center(
                  child: Text(
                    AppStrings.accept,
                    style: TextStyle(
                      color: AppColors.textColor3.withOpacity(1),
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.inter().fontFamily,
                      fontSize: FontDimen.dimen11,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Text(
                data['time'] ?? '',
                style: TextStyle(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: AppColors.textColor4.withOpacity(1),
                  fontWeight: FontWeight.w500,
                  fontSize: FontDimen.dimen11,
                ),
              ),
              Spacer(),
              Text(
                data['date'] ?? '',
                style: TextStyle(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  color: AppColors.textColor4.withOpacity(1),
                  fontWeight: FontWeight.w500,
                  fontSize: FontDimen.dimen11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CardBase extends StatelessWidget {
  final String title;
  final String iconAsset;
  final Widget child;

  const CardBase({
    required this.title,
    required this.iconAsset,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: AppColors.cardBgColor,
        borderRadius: BorderRadius.circular(AppDimens.dimen15),
      ),
      padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with icon image
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.viewProfileBg,
                  fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: FontDimen.dimen11,
                ),
              ),
              SizedBox(width: 4),
              Image.asset(
                iconAsset,
                width: 16,
                height: 16,
                color: AppColors.secondaryColor,
              ),
            ],
          ),
          // Divider
          Divider(
            color: AppColors.textColor4.withOpacity(1),
            thickness: 1,
          ),
          SizedBox(height: 4),
          Expanded(child: child),
        ],
      ),
    );
  }
}
