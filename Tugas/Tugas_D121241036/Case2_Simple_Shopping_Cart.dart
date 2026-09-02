class Product {
  String name;
  double price;
  int quantity;

  Product(this.name, this.price, this.quantity);

  double get subtotal => price * quantity;
}

double calculateSubtotal(List<Product> products) {
  double subtotal = 0;

  for (Product product in products) {
    subtotal += product.subtotal;
  }

  return subtotal;
}

double calculateDiscount(double subtotal) {
  if (subtotal >= 500000) {
    return subtotal * 0.10;
  } else if (subtotal >= 300000) {
    return subtotal * 0.05;
  } else {
    return 0;
  }
}

double calculateTotal(
    double subtotal, double discount) {
  return subtotal - discount;
}

void displayCart(List<Product> products) {
  print("=== SIMPLE SHOPPING CART ===");
  print("");

  for (Product product in products) {
    print(
      "${product.name} | "
      "Harga: Rp${product.price.toStringAsFixed(0)} | "
      "Jumlah: ${product.quantity} | "
      "Subtotal: Rp${product.subtotal.toStringAsFixed(0)}"
    );
  }

  double subtotal =
      calculateSubtotal(products);

  double discount =
      calculateDiscount(subtotal);

  double total =
      calculateTotal(subtotal, discount);

  print("");
  print(
      "Subtotal         : Rp${subtotal.toStringAsFixed(0)}");

  print(
      "Diskon           : Rp${discount.toStringAsFixed(0)}");

  print(
      "Total Pembayaran : Rp${total.toStringAsFixed(0)}");
}

void main() {
  List<Product> cart = [
    Product("Cooling Pad", 350000, 1),
    Product("Mouse", 150000, 1),
    Product("Flashdisk", 120000, 2),
    Product("Sleeve Laptop", 250000, 1),
  ];

  displayCart(cart);
}