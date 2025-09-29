import 'package:get/get.dart';

import '../helpers/storage_helper.dart';

enum UserType { user, child }

class SelectUserController extends GetxController {
  // Reactive variable for UserType
  var userType = UserType.user.obs;

  // Function to toggle user type
  void toggleUserType() {
    userType.value =
        userType.value == UserType.user ? UserType.user : UserType.child;
    StorageHelper().userType = userType.value.toString();
  }
}
