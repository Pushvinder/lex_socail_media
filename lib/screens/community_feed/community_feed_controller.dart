import 'package:the_friendz_zone/models/community_feed_model.dart';

import '../../api_helpers/api_param.dart';
import '../../config/app_config.dart';
import '../home/models/post_model.dart';

class CommunityFeedController extends GetxController {
  Rx<CommunityFeedModel> posts = CommunityFeedModel().obs;
  RxBool isLoading = false.obs;

  Future<void> getFeed(id) async {
    try {
      isLoading.value = true;

      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
        ApiParam.communityId: id,
      }, endPoint: ApiUtils.getCommunityFeed);

      isLoading.value = false;
      posts.value = CommunityFeedModel.fromJson(result);
      update();
    } catch (e, s) {
      debugPrint('getting error search api ${e.toString()} , ======= $s');
      isLoading.value = false;
      update();
    }
  }

}
