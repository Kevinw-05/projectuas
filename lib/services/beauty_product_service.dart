import 'dart:convert';
import 'package:http/http.dart' as http;

class BeautyProduct {
  final String name;
  final String brand;
  final String price;
  final String imageUrl;
  final String productType;
  final String description;

  BeautyProduct({
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.productType,
    required this.description,
  });

  factory BeautyProduct.fromJson(Map<String, dynamic> json) {
    return BeautyProduct(
      name: json['name'] ?? '',
      brand: json['brand'] ?? '',
      price: json['price']?.toString() ?? '-',
      imageUrl: json['image_link'] ?? '',
      productType: json['product_type'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class BeautyProductService {
  static const String _baseUrl =
      'https://makeup-api.herokuapp.com/api/v1/products.json';

  /// productType contoh: lipstick, blush, foundation, eyeliner, mascara, nail_polish
  static Future<List<BeautyProduct>> fetchProducts(String productType) async {
    final uri = Uri.parse('$_baseUrl?product_type=$productType');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((e) => BeautyProduct.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
          'Gagal memuat data produk (status: ${response.statusCode})');
    }
  }
}
