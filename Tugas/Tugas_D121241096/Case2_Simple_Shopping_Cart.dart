class Produk {
  String nama;
  double harga;
  int jumlah;

  Produk(this.nama, this.harga, this.jumlah);

  double hitungSubtotal() {
    return harga * jumlah;
  }
}

double tentukanDiskon(double totalBelanja) {
  if (totalBelanja >= 1000000) {
    return 0.20; // 20%
  } else if (totalBelanja >= 500000) {
    return 0.10; // 10%
  } else if (totalBelanja >= 200000) {
    return 0.05; // 5%
  } else {
    return 0.0; // tidak dapat diskon
  }
}

void main() {
  List<Produk> keranjang = [
    Produk('Kaos Polos', 75000, 3),
    Produk('Celana Jeans', 250000, 2),
    Produk('Sepatu Sneakers', 450000, 1),
    Produk('Topi', 50000, 4),
  ];

  print('SIMPLE SHOPPING CART\n');

  double totalBelanja = 0;

  for (var produk in keranjang) {
    double subtotal = produk.hitungSubtotal();
    totalBelanja += subtotal;

    print('Produk   : ${produk.nama}');
    print('Harga    : Rp${produk.harga}');
    print('Jumlah   : ${produk.jumlah}');
    print('Subtotal : Rp$subtotal');
    print('----------------------------------');
  }

  double persenDiskon = tentukanDiskon(totalBelanja);
  double nilaiDiskon = totalBelanja * persenDiskon;
  double totalPembayaran = totalBelanja - nilaiDiskon;

  print('\nTotal Belanja     : Rp$totalBelanja');

  if (persenDiskon > 0) {
    print('Diskon Didapatkan : ${(persenDiskon * 100).toStringAsFixed(0)}% (Rp$nilaiDiskon)');
  } else {
    print('Diskon Didapatkan : Tidak ada diskon');
  }

  print('Total Pembayaran  : Rp$totalPembayaran');
}