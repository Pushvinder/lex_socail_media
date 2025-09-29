import '../config/app_config.dart';

Widget appButton(
  String title, {
  Color? color,
  Color? textColor,
  double? width,
  double? height,
  Function()? onTap,
  BorderRadiusGeometry? borderRadius,
  bool isShowBottom = true,
}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height ?? AppDimens.dimen70,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius:
                borderRadius ?? BorderRadius.circular(10), // <-- Radius
          ),
          disabledBackgroundColor: color ?? AppColors.primaryColor,
          backgroundColor: color ?? AppColors.primaryColor),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: FontDimen.dimen15,
        ),
      ),
    ),
  );
}
