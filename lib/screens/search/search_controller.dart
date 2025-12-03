import 'package:get/get.dart';
import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/helpers/storage_helper.dart';
import 'package:the_friendz_zone/models/search_comunity_model.dart' hide Data;
import 'package:the_friendz_zone/models/search_user_model.dart';
import 'dart:async';

import '../../utils/app_loader.dart';
import '../community/models/join_comminit_request_response.dart';
import '../profile_creation/invest_and_hobbies/interests_hobbies_controller.dart';

class SearchUserController extends GetxController {
  //0 = People, 1 = Communities
  final RxInt selectedTab = 0.obs;

  final RxString searchQuery = ''.obs;
  final RxList<String> selectedPeopleFilters = <String>[].obs;
  final RxList<String> selectedCommunityFilters = <String>[].obs;
  final RxList<String> selectedHobbies = <String>[].obs;
  final RxList<String> selectedInterests = <String>[].obs;
  Rx<SearchUserModel> searchUserModel = SearchUserModel().obs;
  Rx<SearchComunityModel> searchComunityModel = SearchComunityModel().obs;

  InterestsHobbiesController? interestsHobbiesController;

  Timer? _debounce;



  @override
  void onInit() {
    super.onInit();
    interestsHobbiesController = Get.findOrPut(InterestsHobbiesController());
  }

  // Tabs: you can use AppStrings if added
  final List<String> tabs = ['People', 'Communities'];


  void onChangeSearch(String value) {
    searchQuery.value = value;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if(selectedTab.value == 0) {
        getSearchUser();
      }else{
        getSearchCommunity();
      }
    });
  }

  void togglePeopleInterest(String filter) {
    selectedInterests.contains(filter)
        ? selectedInterests.remove(filter)
        : selectedInterests.add(filter);
  }

  void togglePeopleHobby(String filter) {
    selectedHobbies.contains(filter)
        ? selectedHobbies.remove(filter)
        : selectedHobbies.add(filter);
  }

  void toggleCommunityFilter(String filter) {
    selectedCommunityFilters.contains(filter)
        ? selectedCommunityFilters.remove(filter)
        : selectedCommunityFilters.add(filter);
  }

  void resetPeopleFilters() => selectedPeopleFilters.clear();
  void resetCommunityFilters() => selectedCommunityFilters.clear();

  List<Data> get filteredPeople {
    var q = searchQuery.value.trim().toLowerCase();
    var list = searchUserModel.value.data
            ?.where((p) =>
                q.isEmpty || (p.fullname?.toLowerCase().contains(q) ?? false))
            .toList() ??
        [];
    return list;
  }



  // get the list searched user
  Future<void> getSearchUser() async {
    print('getSearchUser called with query: ${searchQuery.value}');
    try {
      int userId = StorageHelper().getUserId;

      // // get ids of selected interests
      // List<int> selectedInterestIds = selectedPeopleFilters
      //     .map((interest) {
      //       var interestObj = interestsHobbiesController?.interestsList
      //           .firstWhere((element) => element.name == interest);
      //       return interestObj?.id ?? 0;
      //     })
      //     .where((id) => id != 0)
      //     .toList();
      // print('Selected Interest IDs: $selectedInterestIds');

      // get ids of selected hobbies
      List<int> selectedHobbyIds = selectedHobbies
          .map((hobby) {
            var hobbyObj = interestsHobbiesController?.hobbiesList
                .firstWhere((element) => element.name == hobby);
            return hobbyObj?.id ?? 0;
          })
          .where((id) => id != 0)
          .toList();

      // get ids of selected intrests
      List<int> selectedInterestsIds = selectedInterests
          .map((hobby) {
        var hobbyObj = interestsHobbiesController?.interestsList
            .firstWhere((element) => element.name == hobby);
        return hobbyObj?.id ?? 0;
      })
          .where((id) => id != 0)
          .toList();

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.id: '$userId',
        ApiParam.search: searchQuery.value,
        ApiParam.hobby + '[]': selectedHobbyIds,
        ApiParam.interest + '[]': selectedInterestsIds,
        // ApiParam.community + '[]': selectedCommunityFilters, // Uncomment if communities also use interest/hobbies or add a separate param
      }, endPoint: ApiUtils.searchUser);

      print('API Response: $result');

      searchUserModel.value = SearchUserModel.fromJson(result);
      searchUserModel.refresh();

      if (searchUserModel.value.data != null) {}
    } catch (e, s) {
      debugPrint('getting error search api ${e.toString()} , ======= $s');
    }
  }


  Future<void> getSearchCommunity() async {
    print('getSearchCommunity called with query: ${searchQuery.value}');
    try {
      int userId = StorageHelper().getUserId;


      List<int> selectedCommunitiesIds = selectedCommunityFilters
          .map((hobby) {
        var hobbyObj = interestsHobbiesController?.communitiesList
            .firstWhere((element) => element.name == hobby);
        return hobbyObj?.id ?? 0;
      })
          .where((id) => id != 0)
          .toList();

      print('Selected Community IDs: $selectedCommunitiesIds');

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.id: '$userId',
        ApiParam.search: searchQuery.value,
         ApiParam.tag + '[]': selectedCommunitiesIds, // Uncomment if communities also use interest/hobbies or add a separate param
      }, endPoint: ApiUtils.searchCommunities);

      print('API Response: $result');

      searchComunityModel.value = SearchComunityModel.fromJson(result);
      searchComunityModel.refresh();

      if (searchComunityModel.value.data != null) {}
    } catch (e, s) {
      debugPrint('getting error search api ${e.toString()} , ======= $s');
    }
  }

  Future<void> getHobbies() async {
    try {
      int userId = StorageHelper().getUserId;

      await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
      }, endPoint: ApiUtils.getHobbies);

      // PostListResponse response = PostListResponse.fromJson(result);
      // if (response.posts != null) {}
    } catch (e, s) {
      debugPrint('getting error search api ${e.toString()} , ======= $s');
    }
  }


  Future<JoinCommunityRequestResponse?> joinCommunity(
      String communityId, String receiverId) async {
    try {
      AppLoader.show();
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.senderId: '$userId',
        ApiParam.communityId: communityId,
        ApiParam.receiverId: receiverId
      }, endPoint: ApiUtils.sendCommunityJoinRequest);

      JoinCommunityRequestResponse response = JoinCommunityRequestResponse.fromJson(result);
      AppLoader.hide();
      return response;
    } catch (e) {
      AppLoader.hide();

      return null;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
