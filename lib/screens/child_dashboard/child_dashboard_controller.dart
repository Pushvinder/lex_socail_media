import '../../config/app_config.dart';
import 'models/modelschild_dashboard_model.dart';

class ChildDashboardController extends GetxController {
  final RxInt selectedTab = 0.obs;

  final Rx<ChildDashboardModel> child = ChildDashboardModel(
    username: 'kianna_dorwart',
    fullName: 'Kianna Dorwart',
    age: 13,
    avatarUrl: 'https://randomuser.me/api/portraits/women/82.jpg',
    bio:
        'Photography, Music, Health & Fitness, Travel, Movies, DIY Crafts, Foodie, Reading',
    interests: [
      'Photography',
      'Music',
      'Health & Fitness',
      'Travel',
      'Movies',
      'DIY Crafts',
      'Foodie',
      'Reading'
    ],
    postsCount: 21,
    connectionsCount: 815,
    recentActivities: [
      ActivityItem(
        type: ActivityType.postLiked,
        data: {
          'userAvatar': 'https://randomuser.me/api/portraits/men/11.jpg',
          'userName': 'Charlie Dokidis',
          'userHandle': '@charliedokidis',
          'postText':
              '🐶🤍 My partner in crime, my cuddle buddy, and my forever best friend!…',
          'postImage':
              'https://images.unsplash.com/photo-1518717758536-85ae29035b6d',
          'likes': 25000,
        },
      ),
      ActivityItem(
        type: ActivityType.comment,
        data: {
          'postSnippet': '🧳 Pack your bags, your next adventure awaits!',
          'comment': "That’s so nice. Can I come buy at your place…",
          'time': '7:45pm',
          'date': 'Aug 23, 2025',
        },
      ),
      ActivityItem(
        type: ActivityType.chat,
        data: {
          'avatar': 'https://randomuser.me/api/portraits/women/21.jpg',
          'name': 'Cameron Emma',
          'lastMessage': "I don’t think laptops need to be warmed up…",
          'sentLabel': AppStrings.sent,
          'time': '5:45pm',
          'date': 'Aug 24, 2025',
        },
      ),
      ActivityItem(
        type: ActivityType.request,
        data: {
          'avatar': 'https://randomuser.me/api/portraits/women/41.jpg',
          'name': 'Avery Millikan',
          'time': '7:45pm',
          'date': 'Aug 23, 2025',
        },
      ),
    ],
    postVisibility: AppStrings.connectionsOnly,
    contentAgeRestriction: AppStrings.age18plus,
  ).obs;

  // THE ONLY OBSERVABLE for UI
  final RxString selectedPostVisibility = AppStrings.connectionsOnly.obs;

  void setTab(int i) => selectedTab.value = i;

  void selectPostVisibility(String v) {
    selectedPostVisibility.value = v;
    child.update((c) {
      if (c != null) c.postVisibility = v;
    });
  }

  // Initialize when entering the settings screen
  void syncSelectedPostVisibilityWithModel() {
    selectedPostVisibility.value = child.value.postVisibility;
  }
}
