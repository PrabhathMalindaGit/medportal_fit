class SleepSchedule {
  final String id;
  final DateTime targetBedtime;
  final DateTime targetWakeTime;
  final List<int> activeDays; // 0-6 for Sunday-Saturday
  final bool isEnabled;
  final String notes;

  SleepSchedule({
    required this.id,
    required this.targetBedtime,
    required this.targetWakeTime,
    this.activeDays = const [0, 1, 2, 3, 4, 5, 6], // Default to all days
    this.isEnabled = true,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetBedtime': targetBedtime.toIso8601String(),
      'targetWakeTime': targetWakeTime.toIso8601String(),
      'activeDays': activeDays,
      'isEnabled': isEnabled,
      'notes': notes,
    };
  }

  factory SleepSchedule.fromJson(Map<String, dynamic> json) {
    return SleepSchedule(
      id: json['id'],
      targetBedtime: DateTime.parse(json['targetBedtime']),
      targetWakeTime: DateTime.parse(json['targetWakeTime']),
      activeDays: List<int>.from(json['activeDays'] ?? [0, 1, 2, 3, 4, 5, 6]),
      isEnabled: json['isEnabled'] ?? true,
      notes: json['notes'] ?? '',
    );
  }

  Duration get targetSleepDuration {
    // Handle case where wake time is the next day
    if (targetWakeTime.isBefore(targetBedtime)) {
      return targetWakeTime.add(const Duration(days: 1)).difference(targetBedtime);
    }
    return targetWakeTime.difference(targetBedtime);
  }

  bool isActiveOnDay(int day) {
    return activeDays.contains(day);
  }
} 