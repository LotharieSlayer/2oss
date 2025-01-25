import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:two_oss/pages/ask_login/ask_login_view.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:two_oss/pages/auth_stage/auth_stage_view.dart';
import 'package:two_oss/pages/register/register_view.dart';
import 'package:two_oss/pages/verified/verified_view.dart';
import 'package:two_oss/providers/provider.dart';
import 'package:two_oss/repositories/notifications_repository.dart';
import 'package:two_oss/services/websocket_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2OSS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AskLoginView(),
      routes: {
        AskLoginView.route: (context) => const AskLoginView(),
        AuthStageView.route: (context) => const AuthStageView(),
        RegisterView.route: (context) => const RegisterView(),
        VerifiedView.route: (context) => const VerifiedView(),
      }
    );
  }
}

final NotificationsRepository notifRepo = NotificationsRepository();
final WebSocketService webSocketService = WebSocketService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await webSocketService.startServer();
  Provider();
  await initializeService();
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  notifRepo.initChannelNotification();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
      autoStartOnBoot: true,
      notificationChannelId: NotificationsRepository.notificationChannelId,
      initialNotificationTitle: '2OSS démarrage en cours...',
      initialNotificationContent: 'Initialisation du service en cours...',
      foregroundServiceNotificationId:
          NotificationsRepository.notificationPermanentId,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  // Faire un compteur de temps pour savoir depuis quand le service est démarré
  DateTime startTime = DateTime.now();
  // Timer.periodic(const Duration(seconds: 3), (timer) async {
    print("service is successfully running ${DateTime.now().second}");

    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        int notifId = await notifRepo.createNotification(true, startTime);
      }
    }
  // });
}
