import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../config/app_config.dart';

class SettingsController extends GetxController {
  RxBool notificationsOn = true.obs;

  // Your post visibility value used in settings:
  final RxString postVisibility = AppStrings.connectionsOnly.obs;

  // update post visibility setting

  void updatePostVisibility(String v) async {
    postVisibility.value = v;
    try {
      AppLoader.show();
      int userId = StorageHelper().getUserId;
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: "$userId",
        ApiParam.postVisibility: v.trim().toLowerCase()
      }, endPoint: ApiUtils.userPostVisibilityUpdate);
      AppLoader.hide();
    } catch (e) {
      AppLoader.hide();
      debugPrint('error get post list api ${e.toString()}');
    }
  }

  // update notificaiton setting
  // notification status binary 0 or 1
  Future<void> updateNotificationSetting(int notificationStatus) async {
    try {
      AppLoader.show();
      int userId = StorageHelper().getUserId;
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: "$userId",
        ApiParam.notification: '${notificationStatus}'
      }, endPoint: ApiUtils.notification);
      AppLoader.hide();
    } catch (e) {
      AppLoader.hide();
      debugPrint('error get post list api ${e.toString()}');
    }
  }
}
