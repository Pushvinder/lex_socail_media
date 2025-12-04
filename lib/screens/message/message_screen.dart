import '../../config/app_config.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_bar.dart';
import '../../widgets/bottom_nav_bar/bottom_nav_controller.dart';
import '../home/home_screen.dart';
import 'chat_screen.dart';
import 'message_controller.dart';
import 'widgets/message_tile.dart';

class MessageScreen extends StatelessWidget {
  final MessageController controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.find<BottomNavController>().setTabIndex(0);

        Get.offAll(() => const HomeScreen());
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.scaffoldBackgroundColor,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          // Bottom Navigation Bar
          bottomNavigationBar:
              buildBottomNavBar(Get.find<BottomNavController>()),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 8,
                    right: 8,
                    bottom: 6,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.earth,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppStrings.messages,
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
                const SizedBox(height: 6),
                // Search Box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.cardBgColor.withOpacity(1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 18),
                        Image.asset(
                          AppImages.search,
                          height: 21,
                          width: 21,
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(1),
                              fontSize: FontDimen.dimen13,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppStrings.searchHere,
                              hintStyle: TextStyle(
                                color: AppColors.textColor3.withOpacity(0.7),
                                fontSize: FontDimen.dimen13,
                                fontFamily: GoogleFonts.inter().fontFamily,
                              ),
                            ),
                            onChanged: (value) =>
                                controller.searchQuery.value = value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Message List
                Expanded(
                  child: Obx(() {
                    final msgs = controller.filteredMessages;
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: msgs.length,
                      itemBuilder: (context, idx) {
                        final chatItem = msgs[idx];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => ChatScreen(
                                userName: controller
                                        .getOtherParticipantName(chatItem) ??
                                    'Unknown',
                                userAvatar:
                                    controller.getOtherParticipantProfileUrl(
                                            chatItem) ??
                                        '',
                                otherUserId: chatItem.participantIds.firstWhere(
                                  (id) => id != controller.currentUserId,
                                  orElse: () => '',
                                ),
                                chatId: chatItem.chatId,
                                isGroup: chatItem.isGroupChat,
                              ),
                            );
                          },
                          child: MessageTile(
                            chat: chatItem,
                            otherUser: controller.getOtherParticipant(chatItem),
                            highlighted: idx < 2,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          // Floating Call Button
          floatingActionButton: Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(bottom: 110, right: 6),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {},
              shape: const CircleBorder(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryColor,
                      AppColors.primaryColorShade,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: Image.asset(
                  AppImages.callFilledIcon,
                  width: 34,
                  height: 34,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
