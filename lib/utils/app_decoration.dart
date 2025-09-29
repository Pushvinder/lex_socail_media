import '../config/app_config.dart';

class AppDecoration {
  static BoxDecoration cardDecoration({
    Color? borderColor,
    Color? shadowColor,
    Color? bgColor,
    double? borderRadius,
    double? spreadRadius,
    double? blurRadius,
    double? dX,
    double? dY,
  }) {
    return BoxDecoration(
      color: bgColor ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius ?? 20),
      border: borderColor == null ? null : Border.all(color: borderColor),
      boxShadow: shadowColor == null
          ? null
          : [
              BoxShadow(
                color: shadowColor ?? AppColors.primaryColor,
                spreadRadius: spreadRadius ?? 1,
                blurRadius: blurRadius ?? 10,
                offset: Offset(dX ?? 0, dY ?? 0), // changes position of shadow
              ),
            ],
    );
  }
}
