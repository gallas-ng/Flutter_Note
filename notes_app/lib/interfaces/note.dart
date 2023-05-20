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

    String getAppreciation() {
    if (grade <= 5) {
      return 'MEDRIOCRE';
    } else if (grade <= 9) {
      return 'FAIBLE';
    } else if (grade <= 11) {
      return 'MOYEN';
    } else if (grade <= 14) {
      return 'PaASSABLE';
    } else if (grade <= 16) {
      return 'BIEN';
    } else if (grade <= 19) {
      return 'TRES BIEN';
    } else {
      return 'EXCELLENT';
    }
  }
}