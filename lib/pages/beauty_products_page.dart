import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/beauty_product_service.dart';
import '../providers/cart_provider.dart';

class BeautyProductsPage extends StatefulWidget {
  const BeautyProductsPage({super.key});

  @override
  State<BeautyProductsPage> createState() => _BeautyProductsPageState();
}

class _BeautyProductsPageState extends State<BeautyProductsPage> {
  final List<String> _types = [
    'lipstick',
    'blush',
    'foundation',
    'eyeliner',
    'mascara',
    'nail_polish',
  ];

  String _selectedType = 'lipstick';
  late Future<List<BeautyProduct>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = BeautyProductService.fetchProducts(_selectedType);
  }

  void _loadProducts(String type) {
    setState(() {
      _selectedType = type;
      _futureProducts = BeautyProductService.fetchProducts(_selectedType);
    });
  }

  String _prettyType(String type) {
    return toBeginningOfSentenceCase(type.replaceAll('_', ' ')) ?? type;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFFFDFD0),
      appBar: AppBar(
        title: const Text('Produk Kecantikan (API)'),
        backgroundColor: const Color(0xFFFFAA4D),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Dropdown jenis produk
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pilih Jenis Produk',
              ),
              items: _types
                  .map(
                    (t) => DropdownMenuItem(
                  value: t,
                  child: Text(_prettyType(t)),
                ),
              )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _loadProducts(value);
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<BeautyProduct>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Terjadi kesalahan saat memuat data:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final products = snapshot.data ?? [];
                if (products.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada produk untuk kategori ini.'),
                  );
                }
                return ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    final double priceUsd = double.tryParse(p.price) ?? 0.0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: p.imageUrl.isNotEmpty
                              ? Image.network(
                            p.imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) =>
                            const Icon(Icons.image_not_supported),
                          )
                              : const Icon(Icons.image_not_supported),
                        ),
                        title: Text(
                          p.name.isNotEmpty ? p.name : '(Tanpa nama)',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (p.brand.isNotEmpty)
                              Text('Brand: ${p.brand.toUpperCase()}'),
                            Text(
                              priceUsd > 0
                                  ? 'Harga (approx): \$${p.price}'
                                  : 'Harga: -',
                            ),
                            if (p.description.isNotEmpty)
                              Text(
                                p.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          color: const Color(0xFFFFAA4D),
                          onPressed: priceUsd == 0
                              ? null
                              : () {
                            cart.addProductItem(
                              p.name,
                              priceUsd,
                              imageUrl: p.imageUrl, // <-- kirim URL gambar
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text('Ditambahkan: ${p.name}'),
                                duration:
                                const Duration(milliseconds: 900),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
