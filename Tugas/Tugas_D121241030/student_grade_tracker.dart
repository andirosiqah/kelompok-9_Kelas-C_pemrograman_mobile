String tentukanGrade(double nilai) {
  if (nilai >= 85) {
    return "A";
  } else if (nilai >=75) {
    return "B";
  } else if (nilai >=65) {
    return "C";
  } else if (nilai >= 55) {
    return "D";
  } else {
    return "E";
  }
}

String tentukanStatus(double nilai, double kehadiran) {
  if (nilai >= 65 && kehadiran >=75) {
    return "Lulus";
  } else {
    return "Tidak Lulus";
  }
}

void main() {
  List<Map<String, dynamic>> daftarMahasiswa = [
    {
      "nama": "Aca",
      "nilai": 91.0,
      "kehadiran": 90.0,
    },
    {
      "nama": "Beni",
      "nilai": 84.0,
      "kehadiran": 85.0,
    },
    {
      "nama": "Citra",
      "nilai": 65.0,
      "kehadiran": 70.0,
    },
    {
      "nama": "Dinda",
      "nilai": 50.0,
      "kehadiran": 75.0,
    },
  ];
  
  print("=== STUDENT GRADE TRACKER ===");
  print("");
  
  for (int i = 0; i < daftarMahasiswa.length; i++) {
    String nama = daftarMahasiswa[i]["nama"];
    double nilai = daftarMahasiswa[i]["nilai"];
    double kehadiran = daftarMahasiswa[i]["kehadiran"];
    
    String grade = tentukanGrade(nilai);
    String status = tentukanStatus(nilai, kehadiran);
    
    print("Mahasiswa ke-${i + 1}");
    print("Nama       : $nama");
    print("Nilai      : $nilai");
    print("Kehadiran  : $kehadiran%");
    print("Grade      : $grade");
    print("Status     : $status");
    print("------------------------------");
  }
}