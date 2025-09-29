import 'package:the_friendz_zone/screens/requests/models/linked_acccount_list_response.dart';
import 'package:the_friendz_zone/screens/requests/models/pending_community_request_response.dart';
import 'package:the_friendz_zone/screens/requests/models/pending_user_request_response.dart';
import 'package:the_friendz_zone/screens/requests/models/requests_model.dart';

import '../../config/app_config.dart';
import 'requests_controller.dart';
import 'widgets/request_card.dart';
import 'widgets/requests_tabs.dart';

class RequestsScreen extends StatelessWidget {
  RequestsScreen({super.key});
  final controller = Get.put(RequestsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                        AppStrings.requestsTitle,
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(1),
                          fontSize: FontDimen.dimen18,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppFonts.appFont,
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0,
                    child: Padding(
                      padding: EdgeInsets.only(right: AppDimens.dimen12),
                      child: Image.asset(
                        AppImages.backArrow,
                        height: AppDimens.dimen14,
                        width: AppDimens.dimen14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 14, right: 14),
              child: Obx(
                () => RequestsTabs(
                  selectedTab: controller.selectedTab.value,
                  onSelect: (v) => controller.selectedTab.value = v,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Divider(
                thickness: 1,
                color: AppColors.bgColor.withOpacity(0.76),
                height: 0,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.selectedTab.value == 0) {
                  List<UserRequestData> items = controller.connection;
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No requests.',
                        style: TextStyle(
                          color: AppColors.textColor3,
                          fontSize: 17,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(13, 16, 13, 0),
                    itemCount: items.length,
                    itemBuilder: (context, idx) {
                      final req = items[idx];
                      return RequestCard(
                        onAccept: () {
                          controller.acceptUserRequest(
                              (req.requestId ?? -1).toString(),
                              RequestType.connection,
                              idx);
                        },
                        onDecline: () {
                          controller.declineUserRequest(
                              (req.requestId ?? -1).toString(),
                              RequestType.connection,
                              idx);
                        },
                        profileUrl: req.profile ?? '',
                        name: req.fullname ?? '',
                        requestType: RequestType.connection,
                      );
                    },
                  );
                } else if (controller.selectedTab.value == 1) {
                  List<CommunityRequestData> items = controller.community;
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No requests.',
                        style: TextStyle(
                          color: AppColors.textColor3,
                          fontSize: 17,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(13, 16, 13, 0),
                    itemCount: items.length,
                    itemBuilder: (context, idx) {
                      final req = items[idx];
                      return RequestCard(
                        onAccept: () {
                          controller.acceptCommunityRequest(
                              (items[idx].senderId ?? "-1").toString(),
                              (items[idx].communityId ?? "-1").toString(),
                              RequestType.community,
                              idx);
                        },
                        onDecline: () {
                          controller.declineCommunityRequest(
                              (items[idx].senderId ?? "-1").toString(),
                              (items[idx].communityId ?? "-1").toString(),
                              RequestType.community,
                              idx);
                        },
                        profileUrl: '',
                        name: req.senderUsername ?? '',
                        requestType: RequestType.community,
                        communityName: req.communityName,
                      );
                    },
                  );
                } else {
                  List<Children> items = controller.link;
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'No requests.',
                        style: TextStyle(
                          color: AppColors.textColor3,
                          fontSize: 17,
                          fontFamily: GoogleFonts.inter().fontFamily,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(13, 16, 13, 0),
                    itemCount: items.length,
                    itemBuilder: (context, idx) {
                      final req = items[idx];
                      return RequestCard(
                        onAccept: () {
                          // controller.acceptRequest(req);
                        },
                        onDecline: () {
                          // controller.declineRequest(req);
                        },
                        profileUrl: req.profile ?? '',
                        name: req.fullname ?? '',
                        requestType: RequestType.link,
                      );
                    },
                  );
                }
              }),
            )
          ],
        ),
      ),
    );
  }
}
