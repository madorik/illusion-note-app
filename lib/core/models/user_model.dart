class User {
  final String? id;
  final String email;
  final String? name;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? preferences;

  User({
    this.id,
    required this.email,
    this.name,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
    this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      email: json['email'] ?? '',
      name: json['name'],
      profileImage: json['profileImage'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
      preferences: json['preferences'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      if (name != null) 'name': name,
      if (profileImage != null) 'profileImage': profileImage,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (preferences != null) 'preferences': preferences,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class AuthRequest {
  final String email;
  final String password;

  AuthRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String? name;

  RegisterRequest({
    required this.email,
    required this.password,
    this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (name != null) 'name': name,
    };
  }
}

class AuthResponse {
  final User user;
  final String token;
  final String? refreshToken;

  AuthResponse({
    required this.user,
    required this.token,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user']),
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      if (refreshToken != null) 'refreshToken': refreshToken,
    };
  }
} 