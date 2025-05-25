class GoogleLoginRequest {
  final String idToken;

  GoogleLoginRequest({
    required this.idToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'idToken': idToken,
    };
  }
}

class GoogleLoginResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final GoogleUser user;

  GoogleLoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  factory GoogleLoginResponse.fromJson(Map<String, dynamic> json) {
    return GoogleLoginResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresIn: json['expiresIn'] ?? 3600,
      user: GoogleUser.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
      'user': user.toJson(),
    };
  }
}

class GoogleUser {
  final String id;
  final String name;
  final String email;
  final String? picture;

  GoogleUser({
    required this.id,
    required this.name,
    required this.email,
    this.picture,
  });

  factory GoogleUser.fromJson(Map<String, dynamic> json) {
    return GoogleUser(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (picture != null) 'picture': picture,
    };
  }

  @override
  String toString() {
    return 'GoogleUser(id: $id, name: $name, email: $email)';
  }
} 