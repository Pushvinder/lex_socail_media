import '../config/app_config.dart';

class StorageHelper {
  GetStorage get storage => GetStorage();

  set isDarkMode(bool value) => storage.write("isDark", value);
  bool? get isDark => storage.read('isDark');

  removeData() async {
    await storage.erase();
    await Get.deleteAll(force: true);
  }

  set isLoggedIn(bool value) => storage.write("isLoggedIn", value);
  bool get isLoggedIn => storage.read('isLoggedIn') ?? false;

  set userType(String value) => storage.write("userType", value);
  String get userType => storage.read('userType') ?? "rider";

  set setAuthToken(String value) => storage.write("token", value);
  String get getAuthToken => storage.read('token') ?? '';

  set setUserId(int value) => storage.write("userId", value);
  int get getUserId => storage.read('userId') ?? -1;

  // ✅ NEW: FCM Token storage
  set setFcmToken(String value) => storage.write("fcmToken", value);
  String get getFcmToken => storage.read('fcmToken') ?? '';

  // ✅ NEW: User Email storage (needed for Firestore registration)
  set setUserEmail(String value) => storage.write("userEmail", value);
  String get getUserEmail => storage.read('userEmail') ?? '';
}