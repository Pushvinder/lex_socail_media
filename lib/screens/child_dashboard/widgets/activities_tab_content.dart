import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_config.dart';
import '../child_dashboard_controller.dart';
import '../models/modelschild_dashboard_model.dart';
import 'activity_cards.dart';

class ActivitiesTabContent extends StatelessWidget {
  final List<ActivityItem> activities;
  final ChildDashboardController controller;

  const ActivitiesTabContent({
    required this.activities,
    required this.controller,
    Key? key,
  }) : super(key: key);

  // Helper method to get dummy data for a specific type
  ActivityItem _getDummyActivity(ActivityType type) {
    switch (type) {
      case ActivityType.chat:
        return ActivityItem(
          type: ActivityType.chat,
          data: {
            'avatar': 'https://randomuser.me/api/portraits/women/21.jpg',
            'name': 'No recent chats',
            'lastMessage': 'No chat activity available',
            'time': '',
            'date': '',
          },
        );
      default:
        return ActivityItem(type: type, data: {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Show loading indicator while fetching activities
      if (controller.isLoadingActivities.value) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        );
      }

      // Get activities by type
      ActivityItem? postLiked = activities.firstWhereOrNull(
        (a) => a.type == ActivityType.postLiked,
      );
      ActivityItem? comment = activities.firstWhereOrNull(
        (a) => a.type == ActivityType.comment,
      );
      ActivityItem? chat = activities.firstWhereOrNull(
        (a) => a.type == ActivityType.chat,
      ) ?? _getDummyActivity(ActivityType.chat);
      ActivityItem? request = activities.firstWhereOrNull(
        (a) => a.type == ActivityType.request,
      );

      // Create ordered list: PostLiked, Comment, Chat, Request
      List<ActivityItem?> orderedActivities = [
        postLiked,
        comment,
        chat,
        request,
      ];

      // Remove null items
      List<ActivityItem> displayActivities = orderedActivities
          .where((activity) => activity != null)
          .cast<ActivityItem>()
          .toList();

      // Show empty state if no activities at all
      if (displayActivities.isEmpty ||
          (displayActivities.length == 1 &&
              displayActivities[0].type == ActivityType.chat)) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: AppColors.textColor4,
              ),
              SizedBox(height: 16),
              Text(
                'No recent activities',
                style: TextStyle(
                  color: AppColors.textColor3,
                  fontSize: FontDimen.dimen16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      // Build rows of 2 items each
      List<Widget> rows = [];
      for (int i = 0; i < displayActivities.length; i += 2) {
        List<Widget> rowChildren = [];

        // First item in row
        rowChildren.add(
          Expanded(
            child: _buildActivityCard(displayActivities[i]),
          ),
        );

        // Second item in row (if exists)
        if (i + 1 < displayActivities.length) {
          rowChildren.add(SizedBox(width: AppDimens.dimen14));
          rowChildren.add(
            Expanded(
              child: _buildActivityCard(displayActivities[i + 1]),
            ),
          );
        } else {
          // Add empty space if odd number of items
          rowChildren.add(SizedBox(width: AppDimens.dimen14));
          rowChildren.add(Expanded(child: SizedBox()));
        }

        rows.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rowChildren,
            ),
          ),
        );

        // Add spacing between rows
        if (i + 2 < displayActivities.length) {
          rows.add(SizedBox(height: AppDimens.dimen14));
        }
      }

      // Show activities in custom layout with RefreshIndicator
      return RefreshIndicator(
        onRefresh: () => controller.refreshActivities(),
        color: AppColors.primaryColor,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.dimen16,
            vertical: AppDimens.dimen10,
          ),
          child: Column(
            children: rows,
          ),
        ),
      );
    });
  }

  Widget _buildActivityCard(ActivityItem activity) {
    switch (activity.type) {
      case ActivityType.postLiked:
        return ActivityCard_PostLiked(data: activity.data);
      case ActivityType.comment:
        return ActivityCard_Comment(data: activity.data);
      case ActivityType.chat:
        return ActivityCard_Chat(data: activity.data);
      case ActivityType.request:
        return ActivityCard_Request(data: activity.data);
    }
  }
}
