import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/alarm.dart';

class AlarmService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final String _collection = 'alarms';

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _notifications.initialize(initSettings);
  }

  Future<void> addAlarm(Alarm alarm) async {
    await _firestore.collection(_collection).doc(alarm.id).set(alarm.toJson());
    await _scheduleAlarm(alarm);
  }

  Future<void> updateAlarm(Alarm alarm) async {
    await _firestore.collection(_collection).doc(alarm.id).update(alarm.toJson());
    await _cancelAlarm(alarm.id);
    if (alarm.isEnabled) {
      await _scheduleAlarm(alarm);
    }
  }

  Future<void> deleteAlarm(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
    await _cancelAlarm(id);
  }

  Stream<List<Alarm>> getAlarms() {
    return _firestore
        .collection(_collection)
        .orderBy('time')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Alarm.fromJson(doc.data()))
            .toList());
  }

  Future<void> _scheduleAlarm(Alarm alarm) async {
    if (!alarm.isEnabled) return;

    final androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      channelDescription: 'Channel for alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: const RawResourceAndroidNotificationSound('alarm_sound'),
    );

    final iosDetails = const DarwinNotificationDetails(
      sound: 'alarm_sound.aiff',
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (alarm.repeatDays.isEmpty) {
      // One-time alarm
      await _notifications.zonedSchedule(
        alarm.id.hashCode,
        alarm.label,
        'Time to wake up!',
        _nextInstanceOfTime(alarm.time),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } else {
      // Repeating alarm
      for (final day in alarm.repeatDays) {
        final scheduledTime = _nextInstanceOfTimeForDay(alarm.time, day);
        await _notifications.zonedSchedule(
          '${alarm.id}_$day'.hashCode,
          alarm.label,
          'Time to wake up!',
          scheduledTime,
          notificationDetails,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }

  Future<void> _cancelAlarm(String id) async {
    await _notifications.cancel(id.hashCode);
  }

  TZDateTime _nextInstanceOfTime(DateTime time) {
    final now = TZDateTime.now(local);
    var scheduledDate = TZDateTime.from(
      DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      ),
      local,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  TZDateTime _nextInstanceOfTimeForDay(DateTime time, int day) {
    final now = TZDateTime.now(local);
    var scheduledDate = TZDateTime.from(
      DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      ),
      local,
    );

    // Adjust to the next occurrence of the specified day
    while (scheduledDate.weekday != day + 1 || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
} 