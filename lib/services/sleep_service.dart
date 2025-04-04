import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sleep_data.dart';

class SleepService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'sleep_data';

  Future<void> addSleepData(SleepData sleepData) async {
    await _firestore.collection(_collection).doc(sleepData.id).set(sleepData.toJson());
  }

  Future<void> updateSleepData(SleepData sleepData) async {
    await _firestore.collection(_collection).doc(sleepData.id).update(sleepData.toJson());
  }

  Future<void> deleteSleepData(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  Stream<List<SleepData>> getSleepData() {
    return _firestore
        .collection(_collection)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SleepData.fromJson(doc.data()))
            .toList());
  }

  Future<List<SleepData>> getSleepDataByDateRange(DateTime start, DateTime end) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('startTime', isGreaterThanOrEqualTo: start.toIso8601String())
        .where('startTime', isLessThanOrEqualTo: end.toIso8601String())
        .orderBy('startTime', descending: true)
        .get();

    return snapshot.docs.map((doc) => SleepData.fromJson(doc.data())).toList();
  }

  Future<double> getAverageSleepQuality(DateTime start, DateTime end) async {
    final sleepData = await getSleepDataByDateRange(start, end);
    if (sleepData.isEmpty) return 0.0;
    
    final totalQuality = sleepData.fold(0, (sum, data) => sum + data.quality);
    return totalQuality / sleepData.length;
  }

  Future<Duration> getAverageSleepDuration(DateTime start, DateTime end) async {
    final sleepData = await getSleepDataByDateRange(start, end);
    if (sleepData.isEmpty) return Duration.zero;
    
    final totalDuration = sleepData.fold(
      Duration.zero,
      (sum, data) => sum + data.endTime.difference(data.startTime),
    );
    
    return Duration(
      milliseconds: (totalDuration.inMilliseconds / sleepData.length).round(),
    );
  }
} 