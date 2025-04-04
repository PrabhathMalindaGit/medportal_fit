class Exercise {
  final String id;
  final String name;
  final String description;
  final String muscleGroup;
  final String equipment;
  final String difficulty;
  final String imageUrl;
  final List<String> instructions;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    this.imageUrl = '',
    this.instructions = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'muscleGroup': muscleGroup,
      'equipment': equipment,
      'difficulty': difficulty,
      'imageUrl': imageUrl,
      'instructions': instructions,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      muscleGroup: json['muscleGroup'],
      equipment: json['equipment'],
      difficulty: json['difficulty'],
      imageUrl: json['imageUrl'] ?? '',
      instructions: List<String>.from(json['instructions'] ?? []),
    );
  }
}

class Workout {
  final String id;
  final String name;
  final String description;
  final List<WorkoutExercise> exercises;
  final String difficulty;
  final Duration estimatedDuration;
  final String imageUrl;
  final List<String> tags;

  Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.exercises,
    required this.difficulty,
    required this.estimatedDuration,
    this.imageUrl = '',
    this.tags = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'difficulty': difficulty,
      'estimatedDuration': estimatedDuration.inMinutes,
      'imageUrl': imageUrl,
      'tags': tags,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExercise.fromJson(e))
          .toList(),
      difficulty: json['difficulty'],
      estimatedDuration: Duration(minutes: json['estimatedDuration']),
      imageUrl: json['imageUrl'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

class WorkoutExercise {
  final String exerciseId;
  final int sets;
  final int reps;
  final double weight;
  final Duration restTime;
  final String notes;

  WorkoutExercise({
    required this.exerciseId,
    required this.sets,
    required this.reps,
    this.weight = 0.0,
    this.restTime = const Duration(minutes: 1),
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'restTime': restTime.inSeconds,
      'notes': notes,
    };
  }

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exerciseId: json['exerciseId'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight'] ?? 0.0,
      restTime: Duration(seconds: json['restTime'] ?? 60),
      notes: json['notes'] ?? '',
    );
  }
}

class WorkoutSession {
  final String id;
  final String workoutId;
  final DateTime startTime;
  final DateTime endTime;
  final List<ExerciseSet> completedSets;
  final double caloriesBurned;
  final String notes;
  final int rating;

  WorkoutSession({
    required this.id,
    required this.workoutId,
    required this.startTime,
    required this.endTime,
    required this.completedSets,
    this.caloriesBurned = 0.0,
    this.notes = '',
    this.rating = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'workoutId': workoutId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'completedSets': completedSets.map((e) => e.toJson()).toList(),
      'caloriesBurned': caloriesBurned,
      'notes': notes,
      'rating': rating,
    };
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    return WorkoutSession(
      id: json['id'],
      workoutId: json['workoutId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      completedSets: (json['completedSets'] as List)
          .map((e) => ExerciseSet.fromJson(e))
          .toList(),
      caloriesBurned: json['caloriesBurned'] ?? 0.0,
      notes: json['notes'] ?? '',
      rating: json['rating'] ?? 0,
    );
  }
}

class ExerciseSet {
  final String exerciseId;
  final int setNumber;
  final int reps;
  final double weight;
  final Duration restTime;
  final String notes;

  ExerciseSet({
    required this.exerciseId,
    required this.setNumber,
    required this.reps,
    this.weight = 0.0,
    this.restTime = const Duration(minutes: 1),
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
      'restTime': restTime.inSeconds,
      'notes': notes,
    };
  }

  factory ExerciseSet.fromJson(Map<String, dynamic> json) {
    return ExerciseSet(
      exerciseId: json['exerciseId'],
      setNumber: json['setNumber'],
      reps: json['reps'],
      weight: json['weight'] ?? 0.0,
      restTime: Duration(seconds: json['restTime'] ?? 60),
      notes: json['notes'] ?? '',
    );
  }
} 