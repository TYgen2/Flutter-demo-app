class User {
  late final String uid;

  User({required this.uid});
}

class UserData {
  late final String uid;
  late final String name;
  late final String artist;
  late final String imagePath;

  UserData({
    required this.uid,
    required this.name,
    required this.artist,
    required this.imagePath,
  });
}
