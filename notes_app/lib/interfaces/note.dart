class Note {
  final String id;
  final String title;
  final int grade;
  final String isPublic;
  final String userID;

  Note({required this.id, required this.title, required this.grade, required this.isPublic, required this.userID});

  Map<String, dynamic> toMap() {
    return {'title': title, 'grade': grade};
  }
}