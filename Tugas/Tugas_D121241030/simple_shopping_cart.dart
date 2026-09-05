int hitungSubtotal(int harga, int jumlah) {
  return harga * jumlah;
}

double tentukanPersentaseDiskon(int totalBelanja) {
  if (totalBelanja >= 500000) {
    return 0.10; // diskon 10%
  } else if (totalBelanja >=250000) {
    return 0.05; // diskon 5%
  } else {
    return 0.0; // tidak mendapat diskon
  }
}

String formatRupiah(num nilai) {
  return "Rp${nilai.toStringAsFixed(0)}";
}

void main() {
  List<Map<String, dynamic>> daftarProduk = [
    {
      "nama": "Tas Ransel",
      "harga": 200000,
      "jumlah": 1,
    },
    {
      "nama": "Buku Tulis",
      "harga": 10000,
      "jumlah": 5,
    },
    {
      "nama": "Pulpen",
      "harga": 5000,
      "jumlah": 4,
    },
    {
      "nama": "Botol Minum",
      "harga": 80000,
      "jumlah": 1,
    },
  ];
  
  int totalBelanja = 0;
  
  print("=== SIMPLE SHOPPING CART ===");
  print("");
  
  for (int i = 0; i < daftarProduk.length; i++) {
    String nama = daftarProduk[i]["nama"];
    int harga = daftarProduk[i]["harga"];
    int jumlah = daftarProduk[i]["jumlah"];
    
    int subtotal = hitungSubtotal(harga, jumlah);
    
    totalBelanja += subtotal;
    
    print("Produk ke-${i + 1}");
    print("Nama     : $nama");
    print("Harga    : ${formatRupiah(harga)}");
    print("Jumlah   : $jumlah");
    print("Subtotal : ${formatRupiah(subtotal)}");
    print("----------------------------------");
  }
  
  double persentaseDiskon = tentukanPersentaseDiskon(totalBelanja);
  double jumlahDiskon = totalBelanja * persentaseDiskon;
  double totalPembayaran = totalBelanja - jumlahDiskon;
  
  print("");
  print("=== RINGKASAN PEMBAYARAN ===");
  print("Total belanja    : ${formatRupiah(totalBelanja)}");
  print("Diskon           : ${(persentaseDiskon * 100).toStringAsFixed(0)}%",
  );
  print("Potongan diskon: ${formatRupiah(jumlahDiskon)}");
  print("Total pembayaran: ${formatRupiah(totalPembayaran)}");
}