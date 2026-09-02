class Student {
  String name;
  double score;
  double attendance;

  Student(this.name, this.score, this.attendance);
}

String determineGrade(double score) {
  if (score >= 85) {
    return "A";
  } else if (score >= 75) {
    return "B";
  } else if (score >= 65) {
    return "C";
  } else if (score >= 50) {
    return "D";
  } else {
    return "E";
  }
}

String determineStatus(double score, double attendance) {
  String grade = determineGrade(score);

  if ((grade == "A" ||
          grade == "B" ||
          grade == "C") &&
      attendance >= 75) {
    return "LULUS";
  } else {
    return "TIDAK LULUS";
  }
}

void displayStudent(Student student) {
  String grade = determineGrade(student.score);
  String status =
      determineStatus(student.score, student.attendance);

  print("Nama       : ${student.name}");
  print("Nilai      : ${student.score}");
  print("Kehadiran  : ${student.attendance}%");
  print("Grade      : $grade");
  print("Status     : $status");
  print("--------------------------------");
}

void main() {
  List<Student> students = [
    Student("Amirah", 95, 98),
    Student("Nuzul", 80, 85),
    Student("Ifra", 72, 80),
    Student("Idlan", 50, 90),
    Student("Andi", 45, 70),
  ];

  print("=== STUDENT GRADE TRACKER ===");
  print("");

  for (Student student in students) {
    displayStudent(student);
  }
}