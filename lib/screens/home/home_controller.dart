import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/connection_list_response.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/screens/home/models/post_list_response.dart';
import 'package:the_friendz_zone/screens/profile/profile_controller.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../config/app_config.dart';
import '../profile/models/user_response.dart';
import '../requests/models/pending_user_request_response.dart';
import 'models/connection_user_model.dart';
import 'models/live_user.dart';
import 'models/post_model.dart';

class HomeController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  final RxList<ConnectionData> connections = <ConnectionData>[].obs;

  final RxList<Posts> posts = <Posts>[].obs;
  RxList<UserRequestData> requests = <UserRequestData>[].obs;
  late AdWithView bannerAds;
  var isBannerAdLoaded = false.obs;
  final RxList<LiveUser> liveUsers = <LiveUser>[
    LiveUser(
      name: "Brody",
      imageUrl: "https://randomuser.me/api/portraits/men/31.jpg",
    ),
    LiveUser(
      name: "Emma",
      imageUrl: "https://randomuser.me/api/portraits/women/44.jpg",
    ),
    LiveUser(
      name: "Callum",
      imageUrl: "https://randomuser.me/api/portraits/men/32.jpg",
    ),
    LiveUser(
      name: "Brayden",
      imageUrl: "https://randomuser.me/api/portraits/men/36.jpg",
    ),
    LiveUser(
      name: "Cameron",
      imageUrl: "https://randomuser.me/api/portraits/men/38.jpg",
    ),
    LiveUser(
      name: "Danielle",
      imageUrl: "https://randomuser.me/api/portraits/women/65.jpg",
    ),
    LiveUser(
      name: "Ava",
      imageUrl: "https://randomuser.me/api/portraits/women/1.jpg",
    ),
    LiveUser(
      name: "Liam",
      imageUrl: "https://randomuser.me/api/portraits/men/2.jpg",
    ),
    LiveUser(
      name: "Noah",
      imageUrl: "https://randomuser.me/api/portraits/men/3.jpg",
    ),
    LiveUser(
      name: "Olivia",
      imageUrl: "https://randomuser.me/api/portraits/women/4.jpg",
    ),
    LiveUser(
      name: "Elijah",
      imageUrl: "https://randomuser.me/api/portraits/men/5.jpg",
    ),
    LiveUser(
      name: "Charlotte",
      imageUrl: "https://randomuser.me/api/portraits/women/6.jpg",
    ),
    LiveUser(
      name: "Benjamin",
      imageUrl: "https://randomuser.me/api/portraits/men/7.jpg",
    ),
    LiveUser(
      name: "Sophia",
      imageUrl: "https://randomuser.me/api/portraits/women/8.jpg",
    ),
    LiveUser(
      name: "Mason",
      imageUrl: "https://randomuser.me/api/portraits/men/9.jpg",
    ),
    LiveUser(
      name: "Isabella",
      imageUrl: "https://randomuser.me/api/portraits/women/10.jpg",
    ),
    LiveUser(
      name: "Jacob",
      imageUrl: "https://randomuser.me/api/portraits/men/11.jpg",
    ),
    LiveUser(
      name: "Mia",
      imageUrl: "https://randomuser.me/api/portraits/women/12.jpg",
    ),
  ].obs;
  UserResponse userResponse = UserResponse();

  @override
  void onInit() {
    _getUserHomeConnectionList();
    _getHomePostList();
    _getPendingRequestList();
    getProfileDetails();
    loadAd();
    super.onInit();
  }

  Future<void> getProfileDetails() async {
    try {
      debugPrint('on init details called');
      int userId = StorageHelper().getUserId;
      var result = await ApiManager.callPostWithFormData(
          body: {ApiParam.id: "$userId"}, endPoint: ApiUtils.getProfileDetail);
       userResponse = UserResponse.fromJson(result);

    } catch (e) {
      AppLoader.hide();
      debugPrint('error user details api ${e.toString()}');
    }
  }

  Future<void> onConnect(
    ConnectionData user,
  ) async {
    int userId = StorageHelper().getUserId;

    VerifyOtpResponse? response =
        await _sendRequest(userId.toString(), user.id ?? '');
    _removeTopUser();
  }

  Future<void> onReject(ConnectionData user) async {
    int userId = StorageHelper().getUserId;

    VerifyOtpResponse? response =
        await _sendRequest(userId.toString(), user.id ?? '');
    _removeTopUser();
  }

  void onViewProfile(ConnectionData user) {}
  void _removeTopUser() {
    if (connections.isNotEmpty) connections.removeAt(0);
  }

  void switchTab(int idx) => selectedTabIndex.value = idx;

  // get the list of user to show on home screen for connections
  Future<void> _getUserHomeConnectionList() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.id: '$userId',
      }, endPoint: ApiUtils.getAllUserProfileList);

      ConnectionListResponse response = ConnectionListResponse.fromJson(result);

      if (response.data != null) {
        connections.value = response.data ?? [];
        connections.refresh();
      }
    } catch (e) {
      debugPrint('getting error in home conenction list api ${e.toString()}');
    }
  }

  /// send conncetion request to other user
  /// @param [receiverId] is the id of the other user we are sending request to
  /// @param [senderId] is the id of the current user
  Future<VerifyOtpResponse?> _sendRequest(
      String senderId, String receiverId) async {
    try {
      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.receiverId: receiverId,
        ApiParam.senderId: senderId,
      }, endPoint: ApiUtils.sendRequest);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);

      return response;
    } catch (e) {
      debugPrint('getting error in home conenction list api ${e.toString()}');
      return null;
    }
  }

  // get the list of posts to show on home screen
  Future<void> _getHomePostList() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
      }, endPoint: ApiUtils.usersPost);

      PostListResponse response = PostListResponse.fromJson(result);

      if (response.posts != null) {
        posts.value = response.posts ?? [];
        posts.refresh();
      }
    } catch (e, s) {
      debugPrint(
          'getting error in home conenction list api ${e.toString()} , ======= $s');
    }
  }

  Future<PendingUserRequestResponse?> _getPendingRequestList() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(
        body: {
          ApiParam.userId: '$userId',
        },
        endPoint: ApiUtils.pendingUserRequest,
      );

      PendingUserRequestResponse pendingUserRequestResponse = PendingUserRequestResponse.fromJson(result);
      if (pendingUserRequestResponse.status == AppStrings.apiSuccess) {
        requests.value = pendingUserRequestResponse.data ?? [];
        requests.refresh();
      }
      return pendingUserRequestResponse;
    } catch (e) {
      AppLoader.hide();

      debugPrint('error register api ${e.toString()}');
      return null;
    }
  }




  // delete post api
  Future<void> deletePost(String postId, int postRemoveIndex) async {
    try {
      AppLoader.show();
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
        ApiParam.postId: postId,
      }, endPoint: ApiUtils.deleteUserPost);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
      if (response.status == AppStrings.apiSuccess) {
        posts.value.removeAt(postRemoveIndex);
        posts.refresh();
        AppLoader.hide();

        SnackBar(
          backgroundColor: AppColors.cardBehindBg,
          content: Text(
            AppStrings.postDeletedSnackbar,
            style: TextStyle(
              color: AppColors.redColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        AppLoader.hide();

        Get.snackbar(
          AppStrings.error,
          response.message ?? ErrorMessages.somethingWrong,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        return;
      }

      // return response;
    } catch (e) {
      AppLoader.hide();

      debugPrint('getting error in delete post ${e.toString()}');
      return;
    }
  }

  /// send like response to backend
  ///
  /// @param [postId] id of the post
  ///
  /// @param [postIndex] index of the post on which user reacted
  ///
  /// @param [like] bool value to indicate whether user liked or dislike
  ///
  /// @param [like]  [like == true] like else false not likes
  Future<void> likeClick(String postId, int postIndex, bool like) async {
    try {
      // AppLoader.show();
      int userId = StorageHelper().getUserId;
      posts[postIndex].likedByUser = like;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.id: '$userId',
        ApiParam.postId: postId,
        ApiParam.like: like.toString(),
      }, endPoint: ApiUtils.postLike);

      VerifyOtpResponse response = VerifyOtpResponse.fromJson(result);
      if (response.status == AppStrings.apiSuccess) {
        if (like) {
          posts[postIndex].likeCount =
              (int.parse(posts[postIndex].likeCount ?? '0') + 1).toString();
        } else {
          posts[postIndex].likeCount =
              (int.parse(posts[postIndex].likeCount ?? '1') - 1).toString();
        }
        posts.refresh();
        // AppLoader.hide();

        SnackBar(
          backgroundColor: AppColors.cardBehindBg,
          content: Text(
            AppStrings.postDeletedSnackbar,
            style: TextStyle(
              color: AppColors.redColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else {
        // AppLoader.hide();

        Get.snackbar(
          AppStrings.error,
          response.message ?? ErrorMessages.somethingWrong,
          colorText: AppColors.whiteColor,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorSnackbarColor.withOpacity(0.7),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        );
        return;
      }

      // return response;
    } catch (e) {
      // AppLoader.hide();
      debugPrint('getting error in delete post ${e.toString()}');
      return;
    }
  }

  void loadAd() async {
    BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/9214589741",
      request: const AdRequest(),
      size: AdSize(width : Get.width.toInt(), height:  50),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAds = ad as BannerAd;
          isBannerAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }

}
