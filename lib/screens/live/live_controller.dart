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
}
