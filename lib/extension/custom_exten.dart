import '../config/app_config.dart';

extension CustomExtensions on Widget {
  GestureDetector asButton({required Function() onTap}) => GestureDetector(
        onTap: onTap,
        child: this,
      );

  Align align({AlignmentGeometry alignment = Alignment.center}) => Align(
        alignment: alignment,
        child: this,
      );


      
}

extension FindOrPut on GetInterface {
  S findOrPut<S>(S dependency,
      {String? tag, bool permanent = false, bool reInitialize = false}) {
    if (GetInstance().isRegistered<S>(tag: tag)) {
      if (reInitialize) {
        GetInstance().delete<S>(tag: tag);
        return GetInstance().put<S>(dependency, tag: tag, permanent: permanent);
      }
      return GetInstance().find<S>(tag: tag);
    }
    return GetInstance().put<S>(dependency, tag: tag, permanent: permanent);
  }

  removeController<S>(S dependency, {String? tag, bool permanent = false}) {
    if (GetInstance().isRegistered<S>(tag: tag)) {
      return GetInstance().delete<S>(tag: tag);
    }
  }
}
