import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:the_friendz_zone/firebase_options.dart';
import 'package:the_friendz_zone/screens/notifications/firebase/firebase_push_notification_config.dart';
import 'config/app_config.dart';
import 'controllers/select_user_controller.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'widgets/bottom_nav_bar/bottom_nav_controller.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebasePushNotificationConfig.configureNotifications();
  await AppHelper.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final overlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: AppTheme.dark,
        navigatorKey: navigatorKey,
        darkTheme: AppTheme.dark,
        themeMode: StorageHelper().isDark == null
            ? ThemeMode.system
            : (StorageHelper().isDark ?? Get.isDarkMode)
                ? ThemeMode.dark
                : ThemeMode.light,
        initialBinding: BindingsBuilder(() {
          Get.put(SelectUserController());
          Get.put(RegisterController());
          Get.put(BottomNavController());
        }),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(FontDimen.textScaleFactor)),
            child: SafeArea(
              top: false,
              bottom: Platform.isIOS ? false : true,
              child: child!,
            ),
          );
        },
        home: const SplashScreen(),
      ),
    );
  }
}
