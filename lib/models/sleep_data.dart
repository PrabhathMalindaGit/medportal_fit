class SleepData {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final int quality; // 1-5 scale
  final String notes;
  final List<String> tags;

  SleepData({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.quality,
    this.notes = '',
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'quality': quality,
      'notes': notes,
      'tags': tags,
    };
  }

  factory SleepData.fromJson(Map<String, dynamic> json) {
    return SleepData(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      quality: json['quality'],
      notes: json['notes'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
} 