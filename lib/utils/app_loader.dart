import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/main.dart';

class AppLoader {
  static void show() {
    Get.dialog(
      Stack(
        children: const [
          ModalBarrier(dismissible: false, color: Colors.black45),
          Center(
              child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          )),
        ],
      ),
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
