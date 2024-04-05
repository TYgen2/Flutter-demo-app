class Art {
  final String name;
  final String artist;
  final String imagePath;
  bool isFav = false;

  Art(
      {required this.name,
      required this.artist,
      required this.imagePath,
      required this.isFav});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'artist': artist,
      'imagePath': imagePath,
      'status': isFav,
    };
  }
}
