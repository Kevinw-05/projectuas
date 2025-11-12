import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartItem {
  final String name;
  final String date;   // untuk layanan = tanggal terformat, untuk produk = "Produk kecantikan"
  final String time;   // untuk layanan diisi jam, untuk produk boleh ""
  final int price;
  final String? imageUrl; // <-- baru: url gambar dari API jika item = produk
  final bool isProduct;   // <-- baru: penanda jenis item

  CartItem({
    required this.name,
    required this.date,
    required this.time,
    required this.price,
    this.imageUrl,
    this.isProduct = false,
  });
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  int get totalPrice => _items.fold(0, (sum, item) => sum + item.price);

  /// Tambah item dari reservasi layanan
  void addItem(String serviceName, DateTime date, String time, [int? price]) {
    // Tentukan harga berdasarkan nama layanan (dummy rules)
    final lowerName = serviceName.toLowerCase();
    int finalPrice;
    if (lowerName.contains('haircut')) {
      finalPrice = 50000;
    } else if (lowerName.contains('manicure')) {
      finalPrice = 70000;
    } else if (lowerName.contains('facial')) {
      finalPrice = 90000;
    } else if (lowerName.contains('massage')) {
      finalPrice = 100000;
    } else {
      finalPrice = 50000;
    }

    final formattedDate = DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(date);

    _items.add(
      CartItem(
        name: 'Layanan $serviceName',
        date: formattedDate,
        time: time,
        price: finalPrice,
        imageUrl: null,
        isProduct: false,
      ),
    );
    notifyListeners();
  }

  /// Tambah item dari produk kecantikan (API)
  void addProductItem(String productName, double priceInUsd, {String? imageUrl}) {
    // Konversi kasar USD -> IDR untuk tugas/demo
    final int priceInIdr = (priceInUsd * 15000).round();

    _items.add(
      CartItem(
        name: 'Produk $productName',
        date: 'Produk kecantikan',
        time: '',
        price: priceInIdr,
        imageUrl: imageUrl,
        isProduct: true,
      ),
    );
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
