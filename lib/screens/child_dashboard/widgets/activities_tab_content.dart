import '../../../config/app_config.dart';
import '../models/modelschild_dashboard_model.dart';
import 'activity_cards.dart';

class ActivitiesTabContent extends StatelessWidget {
  final List<ActivityItem> activities;
  const ActivitiesTabContent({
    required this.activities,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.dimen16,
        AppDimens.dimen20,
        AppDimens.dimen16,
        AppDimens.dimen10,
      ),
      child: GridView.builder(
        itemCount: activities.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppDimens.dimen16,
          mainAxisSpacing: AppDimens.dimen18,
          childAspectRatio: 0.88,
        ),
        itemBuilder: (context, idx) {
          final item = activities[idx];
          switch (item.type) {
            case ActivityType.postLiked:
              return ActivityCard_PostLiked(data: item.data);
            case ActivityType.comment:
              return ActivityCard_Comment(data: item.data);
            case ActivityType.chat:
              return ActivityCard_Chat(data: item.data);
            case ActivityType.request:
              return ActivityCard_Request(data: item.data);
          }
        },
      ),
    );
  }
}
