// lib/models/user.dart

class User {
  final int id;
  final String username;
  final String email;
  final String firstname;
  final String lastname;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstname,
    required this.lastname,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id'].toString()),
      username: json['username'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}