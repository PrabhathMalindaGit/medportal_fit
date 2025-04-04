import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/progress_photo.dart';
import '../models/photo_album.dart';

class ProgressPhotoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _photosCollection = FirebaseFirestore.instance.collection('progress_photos');
  final CollectionReference _albumsCollection = FirebaseFirestore.instance.collection('photo_albums');

  // Progress Photo Operations
  Future<String> addProgressPhoto(ProgressPhoto photo) async {
    final docRef = await _photosCollection.add(photo.toJson());
    return docRef.id;
  }

  Future<void> updateProgressPhoto(ProgressPhoto photo) async {
    await _photosCollection.doc(photo.id).update(photo.toJson());
  }

  Future<void> deleteProgressPhoto(String photoId) async {
    await _photosCollection.doc(photoId).delete();
  }

  Future<ProgressPhoto?> getProgressPhoto(String photoId) async {
    final doc = await _photosCollection.doc(photoId).get();
    if (!doc.exists) return null;
    return ProgressPhoto.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
  }

  Stream<List<ProgressPhoto>> getProgressPhotosByUser(String userId) {
    return _photosCollection
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProgressPhoto.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
            .toList());
  }

  Stream<List<ProgressPhoto>> getProgressPhotosByCategory(String userId, String category) {
    return _photosCollection
        .where('userId', isEqualTo: userId)
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProgressPhoto.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
            .toList());
  }

  Stream<List<ProgressPhoto>> getProgressPhotosByDateRange(String userId, DateTime startDate, DateTime endDate) {
    return _photosCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProgressPhoto.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
            .toList());
  }

  // Photo Album Operations
  Future<String> addPhotoAlbum(PhotoAlbum album) async {
    final docRef = await _albumsCollection.add(album.toJson());
    return docRef.id;
  }

  Future<void> updatePhotoAlbum(PhotoAlbum album) async {
    await _albumsCollection.doc(album.id).update(album.toJson());
  }

  Future<void> deletePhotoAlbum(String albumId) async {
    await _albumsCollection.doc(albumId).delete();
  }

  Future<PhotoAlbum?> getPhotoAlbum(String albumId) async {
    final doc = await _albumsCollection.doc(albumId).get();
    if (!doc.exists) return null;
    return PhotoAlbum.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
  }

  Stream<List<PhotoAlbum>> getPhotoAlbumsByUser(String userId) {
    return _albumsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PhotoAlbum.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
            .toList());
  }

  Future<void> addPhotoToAlbum(String albumId, String photoId) async {
    await _albumsCollection.doc(albumId).update({
      'photoIds': FieldValue.arrayUnion([photoId])
    });
  }

  Future<void> removePhotoFromAlbum(String albumId, String photoId) async {
    await _albumsCollection.doc(albumId).update({
      'photoIds': FieldValue.arrayRemove([photoId])
    });
  }

  Future<void> setCoverPhoto(String albumId, String photoId) async {
    await _albumsCollection.doc(albumId).update({
      'coverPhotoId': photoId
    });
  }

  // Analytics and Progress Tracking
  Future<Map<String, dynamic>> getProgressSummary(String userId, DateTime startDate, DateTime endDate) async {
    final photos = await _photosCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get();

    if (photos.docs.isEmpty) {
      return {
        'totalPhotos': 0,
        'categories': {},
        'measurements': {},
        'weightChange': 0.0,
        'bodyFatChange': 0.0,
      };
    }

    final firstPhoto = ProgressPhoto.fromJson({...photos.docs.first.data() as Map<String, dynamic>, 'id': photos.docs.first.id});
    final lastPhoto = ProgressPhoto.fromJson({...photos.docs.last.data() as Map<String, dynamic>, 'id': photos.docs.last.id});

    final categories = <String, int>{};
    final measurements = <String, List<double>>{};

    for (final doc in photos.docs) {
      final photo = ProgressPhoto.fromJson({...doc.data() as Map<String, dynamic>, 'id': doc.id});
      categories[photo.category] = (categories[photo.category] ?? 0) + 1;
      
      photo.measurements.forEach((key, value) {
        if (!measurements.containsKey(key)) {
          measurements[key] = [];
        }
        measurements[key]!.add(value);
      });
    }

    return {
      'totalPhotos': photos.docs.length,
      'categories': categories,
      'measurements': measurements,
      'weightChange': lastPhoto.weight - firstPhoto.weight,
      'bodyFatChange': lastPhoto.bodyFatPercentage - firstPhoto.bodyFatPercentage,
    };
  }
} 