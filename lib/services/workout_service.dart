import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _exercisesCollection = 'exercises';
  final String _workoutsCollection = 'workouts';
  final String _workoutSessionsCollection = 'workout_sessions';

  // Exercise CRUD operations
  Future<void> addExercise(Exercise exercise) async {
    await _firestore.collection(_exercisesCollection).doc(exercise.id).set(exercise.toJson());
  }

  Future<void> updateExercise(Exercise exercise) async {
    await _firestore.collection(_exercisesCollection).doc(exercise.id).update(exercise.toJson());
  }

  Future<void> deleteExercise(String id) async {
    await _firestore.collection(_exercisesCollection).doc(id).delete();
  }

  Stream<List<Exercise>> getExercises() {
    return _firestore
        .collection(_exercisesCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Exercise.fromJson(doc.data()))
            .toList());
  }

  Future<List<Exercise>> getExercisesByMuscleGroup(String muscleGroup) async {
    final snapshot = await _firestore
        .collection(_exercisesCollection)
        .where('muscleGroup', isEqualTo: muscleGroup)
        .get();

    return snapshot.docs.map((doc) => Exercise.fromJson(doc.data())).toList();
  }

  // Workout CRUD operations
  Future<void> addWorkout(Workout workout) async {
    await _firestore.collection(_workoutsCollection).doc(workout.id).set(workout.toJson());
  }

  Future<void> updateWorkout(Workout workout) async {
    await _firestore.collection(_workoutsCollection).doc(workout.id).update(workout.toJson());
  }

  Future<void> deleteWorkout(String id) async {
    await _firestore.collection(_workoutsCollection).doc(id).delete();
  }

  Stream<List<Workout>> getWorkouts() {
    return _firestore
        .collection(_workoutsCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Workout.fromJson(doc.data()))
            .toList());
  }

  Future<List<Workout>> getWorkoutsByDifficulty(String difficulty) async {
    final snapshot = await _firestore
        .collection(_workoutsCollection)
        .where('difficulty', isEqualTo: difficulty)
        .get();

    return snapshot.docs.map((doc) => Workout.fromJson(doc.data())).toList();
  }

  // Workout Session operations
  Future<void> startWorkoutSession(WorkoutSession session) async {
    await _firestore.collection(_workoutSessionsCollection).doc(session.id).set(session.toJson());
  }

  Future<void> updateWorkoutSession(WorkoutSession session) async {
    await _firestore.collection(_workoutSessionsCollection).doc(session.id).update(session.toJson());
  }

  Future<void> completeWorkoutSession(WorkoutSession session) async {
    final completedSession = WorkoutSession(
      id: session.id,
      workoutId: session.workoutId,
      startTime: session.startTime,
      endTime: DateTime.now(),
      completedSets: session.completedSets,
      caloriesBurned: session.caloriesBurned,
      notes: session.notes,
      rating: session.rating,
    );
    await updateWorkoutSession(completedSession);
  }

  Stream<List<WorkoutSession>> getWorkoutSessions() {
    return _firestore
        .collection(_workoutSessionsCollection)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkoutSession.fromJson(doc.data()))
            .toList());
  }

  Future<List<WorkoutSession>> getWorkoutSessionsByDateRange(DateTime start, DateTime end) async {
    final snapshot = await _firestore
        .collection(_workoutSessionsCollection)
        .where('startTime', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('startTime', isLessThanOrEqualTo: end.toIso8601String())
        .orderBy('startTime', descending: true)
        .get();

    return snapshot.docs.map((doc) => WorkoutSession.fromJson(doc.data())).toList();
  }

  Future<double> getTotalCaloriesBurned(DateTime start, DateTime end) async {
    final sessions = await getWorkoutSessionsByDateRange(start, end);
    return sessions.fold(0, (sum, session) => sum + session.caloriesBurned);
  }

  Future<Map<String, int>> getWorkoutFrequency(DateTime start, DateTime end) async {
    final sessions = await getWorkoutSessionsByDateRange(start, end);
    final frequency = <String, int>{};
    
    for (final session in sessions) {
      frequency[session.workoutId] = (frequency[session.workoutId] ?? 0) + 1;
    }
    
    return frequency;
  }

  Future<double> getAverageWorkoutDuration(DateTime start, DateTime end) async {
    final sessions = await getWorkoutSessionsByDateRange(start, end);
    if (sessions.isEmpty) return 0.0;
    
    final totalDuration = sessions.fold(
      Duration.zero,
      (sum, session) => sum + session.endTime.difference(session.startTime),
    );
    
    return totalDuration.inMinutes / sessions.length;
  }
} 