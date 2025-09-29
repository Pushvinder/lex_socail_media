import '../../../config/app_config.dart';

class AdBannerWidget extends StatelessWidget {
  final ImageProvider? adImage;

  const AdBannerWidget({super.key, this.adImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: AppColors.subscriptionBgShade,
          child: Row(
            children: [
              // Ad image
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.textColor3,
                  borderRadius: BorderRadius.circular(8),
                  image: adImage != null
                      ? DecorationImage(image: adImage!, fit: BoxFit.cover)
                      : null,
                ),
                child: adImage == null
                    ? Center(
                        child: Text(
                          "Ad",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : null,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.adTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: FontDimen.dimen10,
                        color: Colors.white,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                    SizedBox(height: 0),
                    Text(
                      AppStrings.adDesc,
                      style: TextStyle(
                        fontSize: FontDimen.dimen6 + 1,
                        color: AppColors.adTextColor,
                        fontFamily: GoogleFonts.inter().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.installBg,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
                  child: Text(
                    AppStrings.adInstall,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Yellow "Ad" badge at top-left
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            color: AppColors.adYellowColor,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
            child: Text(
              "Ad",
              style: TextStyle(
                color: Colors.white,
                fontSize: 4,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
