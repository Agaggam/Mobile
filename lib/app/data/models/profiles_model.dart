class Profile {
  final String id;
  final String? email;
  final String role;

  Profile({
    required this.id,
    this.email,
    required this.role,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id']?.toString() ?? '', // aman meski tidak ada
      email: json['email']?.toString(), // boleh null
      role: json['role']?.toString() ?? 'user', // default 'user'
    );
  }
}
