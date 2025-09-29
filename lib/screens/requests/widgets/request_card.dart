import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/app_config.dart';
import '../../../utils/app_cache_manager.dart';
import '../models/requests_model.dart';

class RequestCard extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final RequestType requestType;
  final String profileUrl;
  final String name;
  final String? communityName;

  const RequestCard(
      {super.key,
      required this.onAccept,
      required this.onDecline,
      required this.requestType,
      required this.profileUrl,
      required this.name,
       this.communityName});

  // String _timeString(int daysAgo) {
  //   if (daysAgo <= 0) return AppStrings.requestToday;
  //   if (daysAgo == 1) return '1' + AppStrings.requestDayAgo;
  //   return '$daysAgo' + AppStrings.requestDaysAgo;
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 8,
          right: 12,
          left: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (requestType == RequestType.connection)
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: CachedNetworkImage(
                  imageUrl: profileUrl,
                  fit: BoxFit.cover,
                  width: AppDimens.dimen50,
                  height: AppDimens.dimen50,
                  fadeInDuration: const Duration(milliseconds: 400),
                  cacheManager: appCacheManager,
                  useOldImageOnUrlChange: true,
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
              ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Name + message + time
                  Row(
                    children: [
                      if (requestType == RequestType.community ||
                          requestType == RequestType.link)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: profileUrl,
                              fit: BoxFit.cover,
                              width: AppDimens.dimen50,
                              height: AppDimens.dimen50,
                              fadeInDuration: const Duration(milliseconds: 400),
                              cacheManager: appCacheManager,
                              useOldImageOnUrlChange: true,
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
                          ),
                        ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: name,
                                style: TextStyle(
                                  color: AppColors.textColor3.withOpacity(1),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontSize: FontDimen.dimen14,
                                ),
                              ),
                              const WidgetSpan(child: SizedBox(width: 7)),
                              TextSpan(
                                text: _requestMsg(),
                                style: TextStyle(
                                  color: AppColors.textColor3.withOpacity(0.50),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: GoogleFonts.inter().fontFamily,
                                  fontSize: FontDimen.dimen8 + 1,
                                ),
                              ),
                              const WidgetSpan(child: SizedBox(width: 7)),

                              // todo: time 
                              // TextSpan(
                              //   text: _timeString(request.daysAgo),
                              //   style: TextStyle(
                              //     color: AppColors.textColor4.withOpacity(1),
                              //     fontWeight: FontWeight.w500,
                              //     fontFamily: GoogleFonts.inter().fontFamily,
                              //     fontSize: FontDimen.dimen10,
                              //   ),
                              // ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  if (requestType == RequestType.community ||
                      requestType == RequestType.link)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Expanded(child: _declineBtn()),
                          const SizedBox(width: 6),
                          Expanded(child: _acceptBtn()),
                        ],
                      ),
                    )
                ],
              ),
            ),
            if (requestType == RequestType.connection)
              Row(
                children: [
                  const SizedBox(width: 9),
                  _declineBtn(),
                  const SizedBox(width: 8),
                  _acceptBtn(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _requestMsg() {
    if (requestType == RequestType.community && communityName != null) {
      return ' has sent a request to join the ${communityName} community.';
    }
    if (requestType == RequestType.link) {
      return ' has sent a request to link your account.';
    }
    return 'sent you connection request';
  }

  Widget _acceptBtn() => Container(
        height: 30,
        width: 60,
        decoration: BoxDecoration(
          color: AppColors.connectBg.withOpacity(0.20),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: AppColors.connectBg.withOpacity(0.10),
            width: 1.3,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onAccept,
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
      );

  Widget _declineBtn() => Container(
        height: 30,
        width: 60,
        decoration: BoxDecoration(
          color: AppColors.rejectBgColor.withOpacity(0.20),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: AppColors.rejectBgColor.withOpacity(0.10),
            width: 1.3,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onDecline,
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
      );
}
