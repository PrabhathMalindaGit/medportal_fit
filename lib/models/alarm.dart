class Alarm {
  final String id;
  final DateTime time;
  final String label;
  final bool isEnabled;
  final List<int> repeatDays; // 0-6 for Sunday-Saturday
  final String sound;
  final bool vibrate;
  final int snoozeDuration; // in minutes

  Alarm({
    required this.id,
    required this.time,
    this.label = 'Alarm',
    this.isEnabled = true,
    this.repeatDays = const [],
    this.sound = 'default',
    this.vibrate = true,
    this.snoozeDuration = 5,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'label': label,
      'isEnabled': isEnabled,
      'repeatDays': repeatDays,
      'sound': sound,
      'vibrate': vibrate,
      'snoozeDuration': snoozeDuration,
    };
  }

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      time: DateTime.parse(json['time']),
      label: json['label'] ?? 'Alarm',
      isEnabled: json['isEnabled'] ?? true,
      repeatDays: List<int>.from(json['repeatDays'] ?? []),
      sound: json['sound'] ?? 'default',
      vibrate: json['vibrate'] ?? true,
      snoozeDuration: json['snoozeDuration'] ?? 5,
    );
  }
} 