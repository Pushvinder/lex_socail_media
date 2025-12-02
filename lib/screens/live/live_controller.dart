import 'package:permission_handler/permission_handler.dart';

import '../../config/app_config.dart';

class LiveController extends GetxController {
  final RxString title = ''.obs;
  final TextEditingController titleController = TextEditingController();

  void setTitle(String val) => title.value = val.trim();
  void clearTitle() {
    titleController.clear();
    title.value = '';
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  Future<bool> checkPermission() async {
    final cameraPermission = await Permission.camera.request();
    print(cameraPermission);
    final micPermission = await Permission.camera.request();
    print(micPermission);
    if(cameraPermission.isGranted && micPermission.isGranted){
      return true;
    }
    return false;
  }
}
