import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/config/app_config.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> _getNotificationList() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.id: '$userId',
      }, endPoint: ApiUtils.notification);

      // ContentAgeResponse response = ContentAgeResponse.fromJson(result);
      // if (response.status == AppStrings.apiSuccess) {
      // }
    } catch (e) {
      debugPrint('error get age list ${e.toString()}');
    }
  }
}
