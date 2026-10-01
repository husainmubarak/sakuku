// lib/features/profile/data/models/profile_model.dart

class ProfileModel {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;

  ProfileModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json, String email) {
    return ProfileModel(
      id: json['id'] as String,
      email: email,
      fullName: json['full_name'] as String? ?? 'Pengguna SakuKu',
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
    };
  }

  ProfileModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? avatarUrl,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}