import 'package:the_friendz_zone/api_helpers/api_param.dart';
import 'package:the_friendz_zone/models/interest_response.dart';
import 'package:the_friendz_zone/models/verify_otp_response.dart';
import 'package:the_friendz_zone/screens/community/models/community_model_response.dart';
import 'package:the_friendz_zone/screens/community/models/join_comminit_request_response.dart';
import 'package:the_friendz_zone/utils/app_loader.dart';

import '../../config/app_config.dart';
import 'models/community_model.dart';

class CommunityController extends GetxController {
  final RxInt selectedTab = 0.obs;

  final RxString search = ''.obs;
  final RxList<InterestResponseData> selectedFilters =
      <InterestResponseData>[].obs;

  RxList<CommunityModelData> exploreCommunityList = <CommunityModelData>[].obs;
  RxList<CommunityModelData> joinedCommunityList = <CommunityModelData>[].obs;
  RxList<CommunityModelData> myCommunityList = <CommunityModelData>[].obs;

  RxBool isLoadingCommunity = true.obs;

  RxList<InterestResponseData> filters = <InterestResponseData>[].obs;

  // Sample categories
  // final List<String> filters = [
  //   // General interests & lifestyle
  //   "Photography",
  //   "Crafting & DIY",
  //   "Singing",
  //   "Dance",
  //   "Literature & Writing",
  //   "Music",
  //   "Movies & TV Shows",
  //   "Travel",
  //   "Food & Drinks",
  //   "Health & Fitness",
  //   "Sports",
  //   "Science",
  //   // Enrichment & Education
  //   "Reading",
  //   "Technology",
  //   "Coding",
  //   "Gaming",
  //   "Art & Painting",
  //   "Fashion & Style",
  //   "Nature & Outdoors",
  //   "Gardening",
  //   // Social & Culture
  //   "Volunteering",
  //   "Board Games",
  //   "Animals & Pets",
  //   "Parties & Events",
  //   "Nightlife",
  //   "Podcasts & Audio",
  //   "Makeup & Beauty",
  //   "Self Improvement",
  //   "Languages & Learning",
  //   "Finance & Investing",
  //   // Modern & Digital trends
  //   "Live Streaming",
  //   "Media & Content Creation",
  //   "Influencer Life",
  //   "Entrepreneurship",
  //   "Startups",
  //   "Blogging & Vlogging",
  //   "Podcasts",
  //   // Group activities & hobbies
  //   "Cooking",
  //   "Baking",
  //   "Hiking",
  //   "Cycling",
  //   "Travel Planning",
  //   "Fitness Challenges",
  //   "Yoga & Meditation",
  //   "Martial Arts",
  //   "Comic Books & Manga",
  //   "Collecting",
  //   "Roleplaying Games",
  //   // Tech & nerd culture
  //   "Esports",
  //   "Anime",
  //   "K-Pop & J-Pop",
  //   "Science Fiction",
  //   "Astrology",
  //   "Space & Astronomy",
  //   "Cars & Automobiles",
  //   "Home Improvement",
  //   "Parenting",
  //   "Pets",
  // ];

  // Sample dummy communities
  // final List<CommunityModel> allCommunities = [
  //   CommunityModel(
  //     name: 'Travel Buddies',
  //     description:
  //         '🗺️ For those who live to explore! Share travel tips, hidden gems, and unforgettable adventures with fellow globetrotters.',
  //     avatarUrl:
  //         'https://img.freepik.com/free-photo/travel-concept-with-landmarks_23-2149153259.jpg',
  //     posts: [
  //       'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
  //       'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=800&q=80',
  //     ],
  //     members: 2500,
  //     isJoined: true,
  //     isMine: true,
  //   ),
  //   CommunityModel(
  //     name: 'Science Room',
  //     description:
  //         'Exploring the wonders of the universe, from quantum physics to space exploration. Join the discussion and expand your mind!',
  //     avatarUrl:
  //         'https://img.freepik.com/free-photo/test-tubes-with-colorful-liquid_23-2148881002.jpg?w=900&q=60',
  //     posts: [],
  //     members: 1880,
  //     isJoined: true,
  //     isMine: false,
  //   ),
  //   CommunityModel(
  //     name: 'Music Lovers',
  //     description:
  //         'A place for singing, jamming, sharing playlists, and meeting music creators or fans.',
  //     avatarUrl:
  //         'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80',
  //     posts: [],
  //     members: 777,
  //     isJoined: false,
  //     isMine: false,
  //   ),
  // ];

  // List<CommunityModel> get communitiesForTab {
  //   if (selectedTab.value == 0) {
  //     return allCommunities;
  //   } else if (selectedTab.value == 1) {
  //     return allCommunities.where((c) => c.isJoined).toList();
  //   } else if (selectedTab.value == 2) {
  //     return allCommunities.where((c) => c.isMine).toList();
  //   } else {
  //     return [];
  //   }
  // }

  @override
  void onInit() {
    _getFilterList();

    _getExploreCommunities();
    _getJoinedCommunities();
    _getMyCommunities();
    super.onInit();
  }

  // Handles toggling a filter selection
  void toggleFilter(InterestResponseData val) {
    if (selectedFilters.contains(val)) {
      selectedFilters.remove(val);
    } else {
      selectedFilters.add(val);
    }
  }

  void resetFilters() => selectedFilters.clear();

  // list of communities to show on explore tab
  Future<void> _getExploreCommunities() async {
    try {
      isLoadingCommunity.value = true;
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.id: '$userId',
      }, endPoint: ApiUtils.getAllCommunityDetails);

      CommunityModelResponse response = CommunityModelResponse.fromJson(result);

      if (response.status == AppStrings.apiSuccess && response.data != null) {
        exploreCommunityList.value = response.data ?? [];
        exploreCommunityList.refresh();
      }
      isLoadingCommunity.value = false;
    } catch (e) {
      isLoadingCommunity.value = false;
    }
  }

  // list of joined communities that user has joined
  Future<void> _getJoinedCommunities() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
      }, endPoint: ApiUtils.userJoinedCommunities);

      CommunityModelResponse response = CommunityModelResponse.fromJson(result);

      if (response.status == AppStrings.apiSuccess && response.data != null) {
        joinedCommunityList.value = response.data ?? [];
        joinedCommunityList.refresh();
      }
    } catch (e, s) {
      debugPrint('ERROR join COMMUNITY ${e.toString()} ,  $s');
    }
  }

  Future<void> getRefreshedMyCommunity() async {
    try {
      _getMyCommunities();
    } catch (e) {}
  }

  // list of my communities that user has created
  Future<void> _getMyCommunities() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
      }, endPoint: ApiUtils.myCommunities);

      CommunityModelResponse response = CommunityModelResponse.fromJson(result);

      if (response.status == AppStrings.apiSuccess && response.data != null) {
        myCommunityList.value = response.data ?? [];
        myCommunityList.refresh();
      }
    } catch (e, s) {
      debugPrint('ERROR MY COMMUNITY ${e.toString()} ,  $s');
    }
  }

  // send join community request
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

  Future<void> _getFilterList() async {
    try {
      int userId = StorageHelper().getUserId;

      var result = await ApiManager.callPostWithFormData(body: {
        ApiParam.userId: '$userId',
      }, endPoint: ApiUtils.getCommunities);

      InterestResponse response = InterestResponse.fromJson(result);

      if (response.data != null) {
        filters.value = response.data ?? [];
        filters.refresh();
        // categoriesList.value = response.data ?? [];
        // categoriesList.refresh();
      }
    } catch (e) {}
  }
}
