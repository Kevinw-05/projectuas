import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'payment_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF1E6),
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: const Color(0xFFFFB26B),
        foregroundColor: Colors.white,
      ),
      body: cart.items.isEmpty
          ? const Center(
        child: Text(
          'Keranjang masih kosong',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];

                  // Gambar: pakai URL dari API jika ada (produk), kalau tidak fallback aset lokal (layanan)
                  Widget leadingImage;
                  if (item.imageUrl != null &&
                      item.imageUrl!.isNotEmpty) {
                    leadingImage = ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item.imageUrl!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    );
                  } else {
                    // fallback layanan berdasarkan nama
                    String imagePath;
                    final name = item.name.toLowerCase();
                    if (name.contains('haircut')) {
                      imagePath = 'assets/images/haircut.jpg';
                    } else if (name.contains('facial')) {
                      imagePath = 'assets/images/facial.jpg';
                    } else if (name.contains('manicure')) {
                      imagePath = 'assets/images/manicure.jpg';
                    } else if (name.contains('massage')) {
                      imagePath = 'assets/images/massage.jpg';
                    } else {
                      imagePath = 'assets/images/profile.png';
                    }
                    leadingImage = ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        imagePath,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    );
                  }

                  // Subtitle: produk vs layanan
                  final subtitleText = item.isProduct
                      ? 'Produk kecantikan'
                      : '${item.date} • ${item.time}';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8F3),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: leadingImage,
                      title: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subtitleText,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${item.price}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF914D),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        onPressed: () => cart.removeItem(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Total & tombol pembayaran
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Rp ${cart.totalPrice}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF914D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF914D),
                        foregroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                            const Duration(milliseconds: 400),
                            pageBuilder: (_, animation, __) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: const PaymentPage(),
                                ),
                          ),
                        );
                      },
                      child: const Text(
                        'Lanjut ke Pembayaran',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
