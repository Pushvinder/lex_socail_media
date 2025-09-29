import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../config/app_config.dart';
import '../../utils/app_colors.dart';

extension PaddingExtension on Widget {
  Widget padding({double left = 0.0, double top = 0.0, double right = 0.0, double bottom = 0.0}) {
    return Padding(padding: EdgeInsets.fromLTRB(left, top, right, bottom), child: this);
  }

  // Widget paddingAll(double padding) {
  //   return Padding(padding: EdgeInsets.all(padding), child: this);
  // }

  Widget symmetricPadding({double horizontal = 0.0, double vertical = 0.0}) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical), child: this);
  }

  Widget bodySymmetricPadding({double horizontal = 20.0, double vertical = 0.0}) {
    return symmetricPadding(horizontal: horizontal, vertical: vertical);
  }
}

extension MarginExtension on Widget {
  Widget margin({double left = 0.0, double top = 0.0, double right = 0.0, double bottom = 0.0}) {
    return Container(margin: EdgeInsets.fromLTRB(left, top, right, bottom), child: this);
  }

  Widget marginAll(double margin) {
    return Container(margin: EdgeInsets.all(margin), child: this);
  }

  Widget symmetricMargin({double horizontal = 0.0, double vertical = 0.0}) {
    return Container(margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical), child: this);
  }
}

extension ExtendedAlign on Widget {
  alignAtTopRight() => Align(alignment: Alignment.topRight, child: this);

  alignAtStart() => Align(alignment: Alignment.centerLeft, child: this);

  alignAtCenter() => Align(alignment: Alignment.center, child: this);

  alignAtEnd() => Align(alignment: AlignmentDirectional.centerEnd, child: this);

  conditionalCenterAlign(bool shall) => Align(alignment: shall ? Alignment.center : Alignment.topLeft, child: this);
}

extension GestureDetectorExtension on Widget {
  GestureDetector onTapGesture(VoidCallback onTap) {
    return GestureDetector(onTap: onTap, behavior: HitTestBehavior.translucent, child: this);
  }
}

extension InkWellExtension on Widget {
  InkWell onTap(VoidCallback onTap, {Color? splashColor, double? borderRadius}) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius ?? 0.0),
      splashColor: splashColor ?? AppColors.primaryColor.withValues(alpha: 0.2),
      onTap: onTap,
      child: this,
    );
  }
}

// extension SizedBoxExtension on num {
//   Widget get height => SizedBox(height: toDouble().h);
//   Widget get width => SizedBox(width: toDouble().w);
// }

extension ExpandedExtension on Widget {
  Expanded expand({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Flexible flexible({int flex = 1}) {
    return Flexible(
      flex: flex,
      child: this,
    );
  }
}

extension IgnoreExtension on Widget {
  IgnorePointer ignore({bool? ignoring}) {
    return IgnorePointer(
      ignoring: ignoring ?? true,
      child: this,
    );
  }
}

extension ScrollableExtensions on Widget {
  Widget withScroll({
    Axis axis = Axis.vertical,
    EdgeInsets? padding,
    ScrollPhysics? physics,
  }) {
    return SingleChildScrollView(
      scrollDirection: axis,
      padding: padding,
      physics: physics ?? const ClampingScrollPhysics(),
      child: this,
    );
  }
}

extension KeyboardDismiss on Widget {
  Widget dismissKeyboardOnTap() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: this,
    );
  }
}

extension LoadingExtension on Widget {
  Widget asLoading({required bool isLoading}) {
    return isLoading ? Center(child: SpinKitThreeBounce(color: AppColors.whiteColor, size: 16)) : this;
  }
}

// extension EmptyExtensions on Widget {
//   Widget asEmptyList(
//           {required bool condition,
//           Widget? button,
//           String? heading,
//           String? message,
//           String? subtitle,
//           bool? image,
//           bool? center}) =>
//       condition
//           ? AppEmptyList(
//               button: button,
//               heading: heading,
//               message: message,
//               subtitle: subtitle,
//               image: image,
//             ).conditionalCenterAlign(center ?? false)
//           : this;
// }
