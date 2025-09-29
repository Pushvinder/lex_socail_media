import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';

import '../../config/app_config.dart';
import '../child_dashboard/child_dashboard_screen.dart';
import '../link_child/link_child_screen.dart';
import 'models/child_account_model.dart';

class ParentalControlController extends GetxController {
  // List to hold child accounts
  final RxList<ChildAccountModel> childAccounts = <ChildAccountModel>[].obs;

  RxList childAccount = [].obs;
  RxBool isLoadingLinkedChildList = true
      .obs; // status of loading list of children to show loader when user comes on this screen

  @override
  void onInit() {
    _getLinkedChildrenList();
    super.onInit();
    childAccounts.value = [
      ChildAccountModel(
        id: 'child1',
        name: 'Kianna Dorwart',
        age: 13,
        avatarUrl: 'https://randomuser.me/api/portraits/women/32.jpg',
        interests:
            'Photography, Music, Health & Fitness, Travel, Movies, DIY Crafts, Foodie, Reading',
        postsCount: 21,
        connectionsCount: 815,
      ),
      ChildAccountModel(
        id: 'child2',
        name: 'Mike Dorwart',
        age: 13,
        avatarUrl: 'https://randomuser.me/api/portraits/men/45.jpg',
        interests:
            'Photography, Music, Health & Fitness, Travel, Movies, DIY Crafts, Foodie, Reading',
        postsCount: 21,
        connectionsCount: 815,
      ),
    ];
  }

  // Method to handle tapping "View Dashboard" for a specific child
  void viewChildDashboard(ChildAccountModel child) {
    Get.to(() => ChildDashboardScreen());
  }

  // Method to handle tapping "Link Child Account"
  void linkChildAccount() {
    Get.to(() => LinkChildAccountScreen());
  }

  // get the list of linked children
  Future<void> _getLinkedChildrenList() async {
    try {
      isLoadingLinkedChildList.value = true;
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.parentId: '$userId',
      }, endPoint: ApiUtils.getListLinkedChildren);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
      isLoadingLinkedChildList.value = false;
    } catch (e, s) {
      isLoadingLinkedChildList.value = false;

      debugPrint(
          'getting error in list of children linked api ${e.toString()} , ======= $s');
    }
  }
}
