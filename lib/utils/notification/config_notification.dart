import 'dart:convert';

import 'package:app_health_connect/config/helper/logging.dart';
import 'package:app_health_connect/data/repositories/authentication/authentication_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

final log = logger(FirebaseApiMessaging);

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log.i('Title:  ${message.notification?.title}');
  log.i('Body:  ${message.notification?.body}');
  log.i('Payload:  ${message.data}');
}

class FirebaseApiMessaging {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'Notificaciones de Alta Importancia',
      description: 'Este canal es usado para notificaciones importantes',
      importance: Importance.defaultImportance);

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    AuthenticationRepository.instance.screenRedirect();
    /*  navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments:message
    ); */
  }

  Future initLocalNotifications() async {
    // const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(
      settings,
      onSelectNotification: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload!));
      handleMessage(message);
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    log.i('PushTokenFirebase:  $fCMToken');
    initPushNotifications();
    initLocalNotifications();
  }

    //Programar notificación para un plan diario localmente
  Future<void> scheduleNotificationForPlanDiario(String fechaPlan, String hora, String titulo, String mensaje) async {
    try {
      // Combinar fecha y hora para generar un DateTime
      final DateTime date = DateTime.parse(fechaPlan); // Tu fecha en formato DateTime

      // Combinar fecha y hora en un solo DateTime
      final DateTime fechaHora = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(hora.split(":")[0]), // hora
        int.parse(hora.split(":")[1]), // minutos
        int.parse('00'), // segundos
      );

      var androidDetails = const AndroidNotificationDetails(
        'plan_diario_channel', // Debe coincidir con el ID del canal
        'Plan_Diario', // Nombre del canal
        channelDescription: 'Notificaciones de recordatorios importantes', // Breve descripción de la notificación
        icon: '@drawable/logo', // Icono de la notificación
        priority: Priority.high, // Alta prioridad
        playSound: true, // Reproduce sonido
        enableVibration: true, // Vibración habilitada
      );

      var platformDetails = NotificationDetails(android: androidDetails);

      // Convertir a TZDateTime
      final tz.TZDateTime scheduledDate = convertToTZDateTime(fechaHora);

      // Programar la notificación para la fecha y hora especificada
      await _localNotifications.zonedSchedule(
        0, // ID de la notificación
        titulo, // Título de la notificación
        mensaje, // Cuerpo de la notificación
        scheduledDate, // Fecha y hora para mostrar la notificación
        platformDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Notificación a la hora exacta
      );

      log.i("Notificación programada para el $fechaPlan a las $hora");
    } catch (e) {
      log.e("Error al programar la notificación: $e");
    }
  }

  TZDateTime convertToTZDateTime(DateTime dateTime) {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
    return scheduledDate;
  }
}
