class Activity {
  final String id;
  final String name;
  final String description;
  final String category; // walking, running, cycling, swimming, etc.
  final double caloriesPerMinute;
  final String imageUrl;
  final List<String> instructions;
  final List<String> benefits;
  final String difficulty;
  final String equipment;

  Activity({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.caloriesPerMinute,
    this.imageUrl = '',
    this.instructions = const [],
    this.benefits = const [],
    this.difficulty = 'medium',
    this.equipment = 'none',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'caloriesPerMinute': caloriesPerMinute,
      'imageUrl': imageUrl,
      'instructions': instructions,
      'benefits': benefits,
      'difficulty': difficulty,
      'equipment': equipment,
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      caloriesPerMinute: json['caloriesPerMinute'],
      imageUrl: json['imageUrl'] ?? '',
      instructions: List<String>.from(json['instructions'] ?? []),
      benefits: List<String>.from(json['benefits'] ?? []),
      difficulty: json['difficulty'] ?? 'medium',
      equipment: json['equipment'] ?? 'none',
    );
  }
}

class ActivitySession {
  final String id;
  final String activityId;
  final DateTime startTime;
  final DateTime endTime;
  final double distance; // in kilometers
  final int steps;
  final double caloriesBurned;
  final double averageHeartRate;
  final String notes;
  final Map<String, dynamic> additionalMetrics;
  final String weather;
  final String location;

  ActivitySession({
    required this.id,
    required this.activityId,
    required this.startTime,
    required this.endTime,
    this.distance = 0.0,
    this.steps = 0,
    this.caloriesBurned = 0.0,
    this.averageHeartRate = 0.0,
    this.notes = '',
    this.additionalMetrics = const {},
    this.weather = '',
    this.location = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityId': activityId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'distance': distance,
      'steps': steps,
      'caloriesBurned': caloriesBurned,
      'averageHeartRate': averageHeartRate,
      'notes': notes,
      'additionalMetrics': additionalMetrics,
      'weather': weather,
      'location': location,
    };
  }

  factory ActivitySession.fromJson(Map<String, dynamic> json) {
    return ActivitySession(
      id: json['id'],
      activityId: json['activityId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      distance: json['distance'] ?? 0.0,
      steps: json['steps'] ?? 0,
      caloriesBurned: json['caloriesBurned'] ?? 0.0,
      averageHeartRate: json['averageHeartRate'] ?? 0.0,
      notes: json['notes'] ?? '',
      additionalMetrics: Map<String, dynamic>.from(json['additionalMetrics'] ?? {}),
      weather: json['weather'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Duration get duration => endTime.difference(startTime);
  double get averageSpeed => duration.inMinutes > 0 ? distance / (duration.inMinutes / 60) : 0.0;
}

class ActivityGoal {
  final String id;
  final String activityId;
  final String type; // daily, weekly, monthly
  final double targetValue;
  final String metric; // steps, distance, duration, calories
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;
  final String notes;
  final double progress;

  ActivityGoal({
    required this.id,
    required this.activityId,
    required this.type,
    required this.targetValue,
    required this.metric,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    this.notes = '',
    this.progress = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityId': activityId,
      'type': type,
      'targetValue': targetValue,
      'metric': metric,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCompleted': isCompleted,
      'notes': notes,
      'progress': progress,
    };
  }

  factory ActivityGoal.fromJson(Map<String, dynamic> json) {
    return ActivityGoal(
      id: json['id'],
      activityId: json['activityId'],
      type: json['type'],
      targetValue: json['targetValue'],
      metric: json['metric'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isCompleted: json['isCompleted'] ?? false,
      notes: json['notes'] ?? '',
      progress: json['progress'] ?? 0.0,
    );
  }

  double get progressPercentage => (progress / targetValue) * 100;
  bool get isActive => DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
} 