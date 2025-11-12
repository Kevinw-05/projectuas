import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime? selectedDate;
  String? selectedTime;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? selectedBranch;
  String therapistGender = 'Terserah';
  bool includeHerbalPackage = false;
  bool whatsappReminder = true;

  final List<String> availableTimes = [
    '09:00',
    '10:00',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
  ];

  final List<String> branches = [
    'Cabang Utama',
    'Cabang Timur',
    'Cabang Barat',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDFD0),
      appBar: AppBar(
        title: const Text('Reservasi'),
        backgroundColor: const Color(0xFFFFAA4D),
        foregroundColor: Colors.white,
      ),
      // 👇 INI YANG PENTING: SingleChildScrollView + Padding
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------- DATA PELANGGAN --------------------
            const Text(
              'Data Pelanggan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor HP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // -------------------- PILIH TANGGAL --------------------
            const Text(
              'Pilih Tanggal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color(0xFFFFAA4D),
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  selectedDate != null
                      ? DateFormat('EEEE, dd MMM yyyy', 'id_ID')
                      .format(selectedDate!)
                      : 'Pilih tanggal reservasi',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // -------------------- PILIH JAM --------------------
            const Text(
              'Pilih Jam',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableTimes.map((time) {
                final isSelected = time == selectedTime;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedTime = time);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 18),
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
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // -------------------- PILIH CABANG --------------------
            const Text(
              'Pilih Cabang',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedBranch,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Pilih cabang salon',
              ),
              items: branches
                  .map(
                    (b) => DropdownMenuItem(
                  value: b,
                  child: Text(b),
                ),
              )
                  .toList(),
              onChanged: (val) {
                setState(() => selectedBranch = val);
              },
            ),
            const SizedBox(height: 16),

            // -------------------- PREFERENSI TERAPIS --------------------
            const Text(
              'Preferensi Terapis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('Pria'),
                    value: 'Pria',
                    groupValue: therapistGender,
                    onChanged: (val) {
                      setState(() => therapistGender = val as String);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('Wanita'),
                    value: 'Wanita',
                    groupValue: therapistGender,
                    onChanged: (val) {
                      setState(() => therapistGender = val as String);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('Terserah'),
                    value: 'Terserah',
                    groupValue: therapistGender,
                    onChanged: (val) {
                      setState(() => therapistGender = val as String);
                    },
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              title: const Text('Tambahkan paket minuman herbal'),
              value: includeHerbalPackage,
              onChanged: (val) {
                setState(() => includeHerbalPackage = val ?? false);
              },
            ),
            SwitchListTile(
              title: const Text('Kirim pengingat via WhatsApp'),
              value: whatsappReminder,
              onChanged: (val) {
                setState(() => whatsappReminder = val);
              },
            ),
            const SizedBox(height: 24),

            // -------------------- TOMBOL KONFIRMASI --------------------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAA4D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedDate != null &&
                    selectedTime != null &&
                    _nameController.text.isNotEmpty &&
                    selectedBranch != null
                    ? () {
                  // Ambil provider keranjang
                  final cart = Provider.of<CartProvider>(
                    context,
                    listen: false,
                  );

                  // Ambil nama layanan dari argument Navigator
                  final serviceName =
                      ModalRoute.of(context)!.settings.arguments
                      as String? ??
                          'Layanan';

                  // Tambahkan ke keranjang
                  cart.addItem(
                    serviceName,
                    selectedDate!,
                    selectedTime!,
                  );

                  final dateText =
                  DateFormat('dd MMM yyyy', 'id_ID')
                      .format(selectedDate!);

                  // Snackbar konfirmasi
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Reservasi untuk ${_nameController.text} di $selectedBranch\n'
                            '$dateText • $selectedTime\n'
                            'Terapis: $therapistGender | Herbal: ${includeHerbalPackage ? "Ya" : "Tidak"} | WA: ${whatsappReminder ? "Ya" : "Tidak"}',
                      ),
                    ),
                  );

                  // Kembali otomatis setelah delay singkat
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pop(context);
                  });
                }
                    : null,
                child: const Text(
                  'Konfirmasi Reservasi',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24), // extra padding bawah biar nggak ketutup nav bar
          ],
        ),
      ),
    );
  }
}
