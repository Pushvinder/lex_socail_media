import 'package:get/get.dart';

class PostVisibilityController extends GetxController {
  // The observable currently selected value.
  final RxString selected = ''.obs;

  // Call this once screen open for initial value.
  void setInitial(String value) {
    selected.value = value;
  }
}
