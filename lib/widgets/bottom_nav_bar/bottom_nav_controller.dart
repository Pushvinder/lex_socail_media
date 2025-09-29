import '../../config/app_config.dart';
import '../../screens/community/community_screen.dart';
import '../../screens/create_post/create_post_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/message/message_screen.dart';
import '../../screens/profile/profile_screen.dart';

class BottomNavController extends GetxController with WidgetsBindingObserver {
  final RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    updateSystemUI();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      updateSystemUI();
    }
  }

  void updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  // --- Main Tab Switching ---
  void changeTabIndex(int index) {
    // Do nothing if already on this tab
    if (selectedIndex.value == index) return;

    selectedIndex.value = index;
    updateSystemUI();
    print("Bottom Nav switched to tab: $index");

    // *** Use Get.offAll for tab switching, so only one copy of tab stack exists
    if (index == 0) {
      Get.offAll(() => const HomeScreen());
    } else if (index == 1) {
      Get.offAll(() => CommunityScreen());
    } else if (index == 2) {
      Get.to(() => CreatePostScreen(
            comingFromScreen: '',
        communityId: '',
          ));
    } else if (index == 3) {
      Get.offAll(() => MessageScreen());
    } else if (index == 4) {
      Get.offAll(() => ProfileScreen());
    }
  }

  /// Call this when manually popping or navigating, to ensure index stays correct
  void setTabIndex(int index) {
    selectedIndex.value = index;
    updateSystemUI();
  }

  /// Always go home when requested (by WillPopScope logic in parent)
  Future<bool> onWillPop() async {
    if (selectedIndex.value != 0) {
      // Go to home and do not exit app yet
      changeTabIndex(0);
      return false;
    }
    // At home, allow normal exit
    return true;
  }
}
