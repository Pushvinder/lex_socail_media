import '../../../config/app_config.dart';
import '../models/live_user.dart';

class LiveUsersList extends StatelessWidget {
  final List<LiveUser> users;

  const LiveUsersList({
    required this.users,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 69,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: users.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          final user = users[idx];
          return Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // border: Border.all(
                      //   color: user.isLive
                      //       ? Color(0xFFFF2E71)
                      //       : Colors.transparent,
                      //   width: 2.4,
                      // ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        user.imageUrl,
                        fit: BoxFit.cover,
                        width: 38,
                        height: 38,
                        errorBuilder: (a, b, c) => Container(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ),
                  if (user.isLive)
                    Positioned(
                      top: 30,
                      child: Container(
                        height: 17,
                        width: 32,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF2E71),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            "LIVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: FontDimen.dimen8 - 1,
                              letterSpacing: 1.2,
                              fontFamily: GoogleFonts.inter().fontFamily,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 7),
              SizedBox(
                width: 58,
                child: Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textColor3.withOpacity(1),
                    fontSize: FontDimen.dimen8,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.inter().fontFamily,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
