import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sleep_schedule.dart';
import 'alarm_service.dart';

class SleepScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AlarmService _alarmService;
  final String _collection = 'sleep_schedules';

  SleepScheduleService(this._alarmService);

  Future<void> addSleepSchedule(SleepSchedule schedule) async {
    await _firestore.collection(_collection).doc(schedule.id).set(schedule.toJson());
    if (schedule.isEnabled) {
      await _updateAlarmsForSchedule(schedule);
    }
  }

  Future<void> updateSleepSchedule(SleepSchedule schedule) async {
    await _firestore.collection(_collection).doc(schedule.id).update(schedule.toJson());
    await _updateAlarmsForSchedule(schedule);
  }

  Future<void> deleteSleepSchedule(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
    // Clean up any associated alarms
    await _cleanupAlarmsForSchedule(id);
  }

  Stream<List<SleepSchedule>> getSleepSchedules() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SleepSchedule.fromJson(doc.data()))
            .toList());
  }

  Future<SleepSchedule?> getActiveScheduleForDay(int day) async {
    final now = DateTime.now();
    final snapshot = await _firestore
        .collection(_collection)
        .where('isEnabled', isEqualTo: true)
        .get();

    for (final doc in snapshot.docs) {
      final schedule = SleepSchedule.fromJson(doc.data());
      if (schedule.isActiveOnDay(day)) {
        return schedule;
      }
    }
    return null;
  }

  Future<void> _updateAlarmsForSchedule(SleepSchedule schedule) async {
    if (!schedule.isEnabled) {
      await _cleanupAlarmsForSchedule(schedule.id);
      return;
    }

    // Create bedtime reminder alarm
    final bedtimeAlarm = Alarm(
      id: '${schedule.id}_bedtime',
      time: schedule.targetBedtime,
      label: 'Bedtime Reminder',
      repeatDays: schedule.activeDays,
    );

    // Create wake-up alarm
    final wakeAlarm = Alarm(
      id: '${schedule.id}_wake',
      time: schedule.targetWakeTime,
      label: 'Wake Up',
      repeatDays: schedule.activeDays,
    );

    await _alarmService.addAlarm(bedtimeAlarm);
    await _alarmService.addAlarm(wakeAlarm);
  }

  Future<void> _cleanupAlarmsForSchedule(String scheduleId) async {
    await _alarmService.deleteAlarm('${scheduleId}_bedtime');
    await _alarmService.deleteAlarm('${scheduleId}_wake');
  }

  Future<bool> isScheduleActive(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();
    if (!doc.exists) return false;
    
    final schedule = SleepSchedule.fromJson(doc.data()!);
    return schedule.isEnabled && schedule.isActiveOnDay(DateTime.now().weekday - 1);
  }
} 