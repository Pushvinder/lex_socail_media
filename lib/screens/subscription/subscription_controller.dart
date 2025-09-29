import 'package:get/get.dart';
import '../home/home_screen.dart';

enum Plan { monthly, yearly }

class SubscriptionController extends GetxController {
  Rx<Plan> selectedPlan = Plan.monthly.obs;
  void selectPlan(Plan v) => selectedPlan.value = v;

  void onSubscribe() {
    // Handle subscribe logic here
    Get.to(() => HomeScreen());
  }

  void onRestorePurchase() {
    // Handle restore logic here
  }
}
