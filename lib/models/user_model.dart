class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final Map<String, String> stats;
  final String? profileImage; // Add this field

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.stats,
    this.profileImage, // Add this parameter
  });
}