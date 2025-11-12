import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedMethod;
  bool paymentSuccess = false;

  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'Transfer Bank', 'icon': Icons.account_balance},
    {'name': 'E-Wallet', 'icon': Icons.account_balance_wallet_outlined},
    {'name': 'Tunai di Tempat', 'icon': Icons.attach_money},
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final total = cart.totalPrice;

    return Scaffold(
      backgroundColor: const Color(0xFFFFDFD0),
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: const Color(0xFFFFAA4D),
        foregroundColor: Colors.white,
      ),
      body: paymentSuccess
          ? _buildSuccessScreen(context)
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(
                        Icons.event_available,
                        color: Color(0xFFFFAA4D),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text('${item.date} • ${item.time}'),
                      trailing: Text(
                        'Rp ${item.price}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFAA4D),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pilih Metode Pembayaran',
              style:
              TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...paymentMethods.map((method) {
              final isSelected = selectedMethod == method['name'];
              return GestureDetector(
                onTap: () {
                  setState(() => selectedMethod = method['name']);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFAA4D)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFFAA4D)
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        method['icon'],
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFFFFAA4D),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        method['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Pembayaran',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Rp $total',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFAA4D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8A2B),
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedMethod == null
                    ? null
                    : () async {
                  setState(() => paymentSuccess = true);
                  await Future.delayed(
                      const Duration(seconds: 2));
                  cart.clearCart();
                },
                child: const Text(
                  'Konfirmasi Pembayaran',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle,
              color: Colors.green, size: 100),
          const SizedBox(height: 20),
          const Text(
            'Pembayaran Berhasil!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Terima kasih telah melakukan reservasi.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFAA4D),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                  vertical: 14, horizontal: 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Kembali ke Beranda'),
          ),
        ],
      ),
    );
  }
}
