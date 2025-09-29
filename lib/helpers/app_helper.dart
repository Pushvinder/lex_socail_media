import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config/app_config.dart';
import '../config/env_config.dart';

class AppHelper {
  static init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load .env
    await EnvConfig.load();

    await GetStorage.init();
  }
}
