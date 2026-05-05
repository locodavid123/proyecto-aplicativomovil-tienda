import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (!kIsWeb && Platform.isWindows) {
      await localNotifier.setup(
        appName: 'Oliva y Pimienta',
      );
      return;
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(); // Agregado para robustez
    const linux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );
    const macOS = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
      linux: linux,
      macOS: macOS,
    );

    // No hay cambios en este archivo, ya que la implementación de onDidReceiveNotificationResponse
    // es una mejora futura y no un error actual.
    // El código ya está como se sugirió en la revisión anterior.
    // Mantengo el comentario para recordar la oportunidad de mejora.
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Aquí podrías manejar la navegación al tocar la notificación
      },
    );

    // Permisos en Android 13+
    if (!kIsWeb && Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  static Future<void> showWelcome(String nombre) async {
    if (!kIsWeb && Platform.isWindows) {
      LocalNotification notification = LocalNotification(
        title: 'Bienvenido Sr. $nombre',
        body: 'Has ingresado a Oliva y Pimienta',
      );
      notification.show();
      return;
    }

    const androidDetalles = AndroidNotificationDetails(
      'canal_login',
      'notificaciones_login',
      channelDescription: 'Muestra un saludo de bienvenida al usuario',
      importance: Importance.max,
      priority: Priority.high,
    );

    final detalles = NotificationDetails(
      android: androidDetalles,
      iOS: const DarwinNotificationDetails(),
      linux: const LinuxNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
    );

    await _notifications.show(
      0,
      'Bienvenido Sr. $nombre',
      'Has ingresado a Oliva y Pimienta',
      detalles,
    );
  }

  /// Muestra una notificación genérica con título y cuerpo personalizados.
  static Future<void> showGeneralNotification({
    required String title,
    required String body,
  }) async {
    if (!kIsWeb && Platform.isWindows) {
      LocalNotification notification = LocalNotification(
        title: title,
        body: body,
      );
      notification.show();
      return;
    }

    const androidDetalles = AndroidNotificationDetails(
      'canal_general',
      'Notificaciones Generales',
      channelDescription: 'Canal para avisos informativos y promociones',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    final detalles = NotificationDetails(
      android: androidDetalles,
      iOS: const DarwinNotificationDetails(),
      linux: const LinuxNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(
        100000,
      ), // ID único más seguro para Android
      title,
      body,
      detalles,
    );
  }
}
