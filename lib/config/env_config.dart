import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const String _envFileName = '.env';

  static Future<void> load() async {
    await dotenv.load(fileName: "lib/$_envFileName");
  }
}
