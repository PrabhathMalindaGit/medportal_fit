class PhotoAlbum {
  final String id;
  final String userId;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> photoIds;
  final String coverPhotoId;
  final bool isPublic;
  final List<String> tags;
  final String notes;

  PhotoAlbum({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.photoIds = const [],
    this.coverPhotoId = '',
    this.isPublic = false,
    this.tags = const [],
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'photoIds': photoIds,
      'coverPhotoId': coverPhotoId,
      'isPublic': isPublic,
      'tags': tags,
      'notes': notes,
    };
  }

  factory PhotoAlbum.fromJson(Map<String, dynamic> json) {
    return PhotoAlbum(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      photoIds: List<String>.from(json['photoIds'] ?? []),
      coverPhotoId: json['coverPhotoId'] ?? '',
      isPublic: json['isPublic'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
      notes: json['notes'] ?? '',
    );
  }
}