class ProgressPhoto {
  final String id;
  final String userId;
  final String imageUrl;
  final String thumbnailUrl;
  final DateTime date;
  final String category; // front, back, side, etc.
  final String notes;
  final Map<String, double> measurements;
  final double weight;
  final double bodyFatPercentage;
  final List<String> tags;
  final bool isPublic;

  ProgressPhoto({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.date,
    required this.category,
    this.notes = '',
    this.measurements = const {},
    this.weight = 0.0,
    this.bodyFatPercentage = 0.0,
    this.tags = const [],
    this.isPublic = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'date': date.toIso8601String(),
      'category': category,
      'notes': notes,
      'measurements': measurements,
      'weight': weight,
      'bodyFatPercentage': bodyFatPercentage,
      'tags': tags,
      'isPublic': isPublic,
    };
  }

  factory ProgressPhoto.fromJson(Map<String, dynamic> json) {
    return ProgressPhoto(
      id: json['id'],
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      notes: json['notes'] ?? '',
      measurements: Map<String, double>.from(json['measurements'] ?? {}),
      weight: json['weight'] ?? 0.0,
      bodyFatPercentage: json['bodyFatPercentage'] ?? 0.0,
      tags: List<String>.from(json['tags'] ?? []),
      isPublic: json['isPublic'] ?? false,
    );
  }
} 