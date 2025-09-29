import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class TextFieldController extends GetxController {
  bool isObscureText = false;
  String? validatorMsg;

  void setData(bool value) {
    isObscureText = value;
  }

  void setValidationMessage(String? message) {
    if (validatorMsg != message) {
      validatorMsg = message;
      update();
    }
  }
}
