class UserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        emailVerifiedAt: json['email_verified_at'] as String?,
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        if (emailVerifiedAt != null) 'email_verified_at': emailVerifiedAt,
        if (token != null) 'token': token,
      };

  UserModel copyWith({String? token}) => UserModel(
        id: id,
        name: name,
        email: email,
        emailVerifiedAt: emailVerifiedAt,
        token: token ?? this.token,
      );
}
