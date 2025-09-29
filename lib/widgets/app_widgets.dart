import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../config/app_config.dart';

class AppWidgets {
  static Widget getLoadingView() => Center(
          child: SpinKitThreeBounce(
        color: AppColors.terneryColor,
        size: AppDimens.dimen35,
      ));

  static Widget getDataNotFoundView({String? msg}) => Center(
          child: Text(
        msg ?? AppStrings.dataNotFound,
        style: Get.theme.textTheme.labelLarge,
      ));

  static Widget getNetworkImage(String path,
          {double? width,
          double? height,
          BoxFit? fit,
          bool isLoading = true}) =>
      CachedNetworkImage(
        imageUrl: path,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            isLoading ? getLoadingView() : const SizedBox(),
        errorWidget: (context, url, error) => Image.asset(
          AppImages.logo,
          height: height,
          width: width,
        ),
      );

  static AppBar titleBar(String title,
          {bool isBack = true,
          TextAlign? textAlign,
          List<Widget>? actions,
          Function()? onTap}) =>
      AppBar(
        automaticallyImplyLeading: isBack,
        scrolledUnderElevation: 0.0,
        leading: isBack
            ? GestureDetector(
                onTap: onTap ?? () => Get.back(),
                child: Icon(
                  Icons.arrow_back,
                  size: AppDimens.dimen24,
                  color: Get.theme.dividerColor,
                ).paddingAll(AppDimens.dimen10))
            : null,
        titleTextStyle: Get.theme.textTheme.displaySmall,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: Get.theme.textTheme.displaySmall,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: actions,
      );

  static Widget getDialogView(String title, String msg) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.theme.textTheme.displayLarge
                ?.copyWith(color: Get.theme.dividerColor),
          ),
          Text(
            msg,
            style: Get.theme.textTheme.titleSmall,
          ).paddingSymmetric(vertical: AppDimens.dimen30),
        ],
      );

  // static exitDialog() => AppDialogs.showCommonDialog(
  //       AppWidgets.getDialogView(AppStrings.exit, AppStrings.exitMsg),
  //       isbottom: true,
  //       onTap: () => SystemNavigator.pop(),
  //     );

  static Widget get devider => Container(
        color: Get.theme.dividerColor,
        width: double.infinity,
        height: 1,
      );
}
