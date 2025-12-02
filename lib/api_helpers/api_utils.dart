import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUtils {
  static String get baseUrl => dotenv.env['BASEURL'] ?? '';

  //end point
  static const String login = 'UserLogin';
  static const String register = 'register';
  static const String forgetPassowrd = 'forgot_password';
  static const String verifyOtp = 'verify_otp';
  static const String resetPassword = 'reset_password';
  static const String resendOtp = 'resend_otp';
  static const String getInterest = 'get_interest';
  static const String getHobbies = 'get_hobbies';
  static const String getCommunityFeed = 'get_all_community_posts_details';
  static const String addPostComment = 'add_post_comment';
  static const String getCommunities = 'get_communities';
  static const String searchUser = 'search_user';
  static const String communityPerference = 'community_preference';
  static const String searchCommunities = 'search_communities';
  static const String respondRequest = 'respond_request';
  static const String friendList = 'friend_list';
  static const String pendingUserRequest = 'pending_user_requests';
  static const String sendCommunityJoinRequest = 'send_community_join_request';
  static const String respondCommunityRequuest = 'respond_community_request';
  static const String communityFriendList = 'community_friend_list';
  static const String pendingCommunityRequest = 'pending_community_requests';
  static const String recentConnectionRequest = 'recent_connection_request';
  static const String userAgeContentUpdate = 'user_age_content_update';
  static const String userPostVisibilityUpdate = 'user_post_visibility_update';
  static const String notification = 'notification';
  static const String createProfile = 'create_profile';
  static const String updateInterest = 'update_interest';
  static const String updateHobbies = 'update_hobbies';
  static const String updateCommunities = 'update_communities';
  static const String getProfileDetail = 'get_profile_detail';
  static const String createPost = 'create_post';
  static const String getPostDetails = 'get_post_details';
  static const String getAllPostDetails = 'get_all_post_details';
  static const String updatePost = 'update_post';
  static const String deleteUserPost = 'delete_user_post';
  static const String createCommunity = 'create_community';
  static const String updaetCommunity = 'update_community';
  static const String getCommunityDetails = 'get_community_details';
  static const String getAllCommunityDetails = 'get_all_community_details';
  static const String myCommunities = 'my_community';
  static const String communityFilter = 'community_filter';
  static const String createCommunityPost = 'create_community_post';
  static const String updateCommunityPost = 'update_community_post';
  static const String deleteCommunityPost = 'delete_community_post';
  static const String deleteCommunity = 'delete_community';
  static const String sendLinkRequest = 'send_link_request';
  static const String respondeLinkRequest = 'respond_link_request';
  static const String getListLinkedChildren = 'get_list_linked_children';
  static const String childAgeContentUpdate = 'child_age_content_update';
  static const String childPostVisibiltyUpdate = 'child_post_visibility_update';
  static const String getAllUserProfileList = 'get_all_user_profile_list';
  static const String linkAccountLIst = 'linkAccountLIst';
  static const String usersPost = 'usersPost';
  static const String commentList = 'comment_list';
  static const String getAgeContentList = 'get_age_content_list';
  static const String userJoinedCommunities = 'userJoinedCommunites';
  static const String postLike = 'postlike';
  static const String userProfileDetails = 'userProfileDetails';
  static const String socialLogin = 'Social_login';
  static const String sendRequest = 'send_request';

}
