import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_config.dart' hide AppColors;
import '../../../utils/app_dimen.dart';
import 'callHistoryTile.dart';
import 'callHistory_controller.dart';


class CallHistoryScreen extends StatelessWidget {
  final CallHistoryController controller = Get.put(CallHistoryController());

  CallHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 6,
              ),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.whiteColor,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Call History',
                    style: TextStyle(
                      color: AppColors.textColor3.withOpacity(1),
                      fontSize: FontDimen.dimen18,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.appFont,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Call History List
            Expanded(
              child: Obx(() {
                // Loading state
                if (controller.isLoading.value && controller.callHistoryList.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                // Error state
                if (controller.errorMessage.value.isNotEmpty && controller.callHistoryList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.textColor3.withOpacity(0.5),
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.7),
                            fontSize: FontDimen.dimen14,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: controller.refreshCallHistory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: FontDimen.dimen14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Empty state
                if (controller.callHistoryList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.call_outlined,
                          color: AppColors.textColor3.withOpacity(0.5),
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No call history',
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.7),
                            fontSize: FontDimen.dimen16,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.appFont,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your call history will appear here',
                          style: TextStyle(
                            color: AppColors.textColor3.withOpacity(0.5),
                            fontSize: FontDimen.dimen13,
                            fontFamily: GoogleFonts.inter().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Call history list
                return RefreshIndicator(
                  onRefresh: controller.refreshCallHistory,
                  color: AppColors.primaryColor,
                  backgroundColor: AppColors.cardBgColor,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.callHistoryList.length,
                    itemBuilder: (context, index) {
                      final call = controller.callHistoryList[index];
                      return CallHistoryTile(
                        call: call,
                        currentUserId: controller.currentUserId,
                        onTap: () {
                          // Handle call history item tap
                          // You can navigate to chat or initiate a call
                          print('Tapped on call: ${call.id}');
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}