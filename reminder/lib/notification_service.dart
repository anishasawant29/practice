import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings);
  }

  static Future<void> scheduleDaily({
    required int id,
    required String name,
    required String dose,
    required DateTime time,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'medicine_channel',
        'Medicine Reminder',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _plugin.zonedSchedule(
      id,
      "Medicine Reminder",
      "Take $name ($dose)",
      tz.TZDateTime.from(time, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // daily same time
    );
  }

  static Future<void> cancel(int id) async
   {
    await _plugin.cancel(id);
  }
}
