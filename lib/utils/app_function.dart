import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:intl/intl.dart';

class AppFunctions {
  // static String timestampToDateTime(String timestamp) {
  //   var date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
  //   final f = DateFormat('dd MMM yyyy hh:mm a');
  //   return f.format(date).toString();
  // }

  static Future<bool> checkInternet() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      return true;
    }
    return false;
  }
}
