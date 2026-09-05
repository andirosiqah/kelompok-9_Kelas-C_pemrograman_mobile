class Mahasiswa {
  String nama;
  double nilai;
  double kehadiran; // dalam persen (%)

  Mahasiswa(this.nama, this.nilai, this.kehadiran);
}

String tentukanGrade(double nilai) {
  if (nilai >= 85) {
    return 'A';
  } else if (nilai >= 70) {
    return 'B';
  } else if (nilai >= 55) {
    return 'C';
  } else if (nilai >= 40) {
    return 'D';
  } else {
    return 'E';
  }
}

String tentukanStatus(double nilai, double kehadiran) {
  bool lulusNilai = nilai >= 55;
  bool lulusKehadiran = kehadiran >= 80;

  if (lulusNilai && lulusKehadiran) {
    return 'Lulus';
  } else {
    return 'Tidak Lulus';
  }
}

void main() {
  List<Mahasiswa> daftarMahasiswa = [
    Mahasiswa('Jek', 88.0, 90.0),
    Mahasiswa('Budi', 60.0, 75.0),
    Mahasiswa('Citra', 45.0, 60.0),
    Mahasiswa('Dewi', 72.0, 85.0),
    Mahasiswa('Eka', 95.0, 95.0),
  ];

  print('STUDENT GRADE TRACKER\n');

  for (var mhs in daftarMahasiswa) {
    String grade = tentukanGrade(mhs.nilai);
    String status = tentukanStatus(mhs.nilai, mhs.kehadiran);

    print('Nama       : ${mhs.nama}');
    print('Nilai      : ${mhs.nilai}');
    print('Kehadiran  : ${mhs.kehadiran}%');
    print('Grade      : $grade');
    print('Status     : $status');
    print('----------------------------------');
  }

  int jumlahLulus = 0;
  int jumlahTidakLulus = 0;

  for (var mhs in daftarMahasiswa) {
    String status = tentukanStatus(mhs.nilai, mhs.kehadiran);
    if (status == 'Lulus') {
      jumlahLulus++;
    } else {
      jumlahTidakLulus++;
    }
  }

  print('\nTotal Mahasiswa Lulus      : $jumlahLulus');
  print('Total Mahasiswa Tidak Lulus: $jumlahTidakLulus');
}