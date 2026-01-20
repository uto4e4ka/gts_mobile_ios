class User {
  final int id;

  User({required this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id']);
  }
}
