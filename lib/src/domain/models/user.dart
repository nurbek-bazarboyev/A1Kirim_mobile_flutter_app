class User {
  final String userId;
  final String language;
  final String phoneNumber;
  final String name;

  User(
      {required this.userId,
      required this.language,
      required this.name,
      required this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> response) {
    final userMap = response['map']['user'];
    return User(
        userId: userMap['userId'].toString(),
        language: userMap['lang'],
        name: userMap['name'].toString(),
        phoneNumber: userMap['telefon'].toString()
    );
  }
}
