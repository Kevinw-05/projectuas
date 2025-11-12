import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // kunci penyimpanan
  static const _kName = 'profile_name';
  static const _kEmail = 'profile_email';
  static const _kPhone = 'profile_phone';
  static const _kAddress = 'profile_address';

  // nilai default (dipakai saat pertama kali)
  String _name = 'Ali';
  String _email = 'ajo@example.com';
  String _phone = '+62 812-3456-7890';
  String _address = 'Jl. Melati No. 21, Banda Aceh';

  // controller untuk mode edit
  late final TextEditingController _nameC;
  late final TextEditingController _emailC;
  late final TextEditingController _phoneC;
  late final TextEditingController _addressC;

  bool _isEditing = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _nameC = TextEditingController(text: _name);
    _emailC = TextEditingController(text: _email);
    _phoneC = TextEditingController(text: _phone);
    _addressC = TextEditingController(text: _address);
    _loadProfile(); // baca dari SharedPreferences
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _addressC.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString(_kName) ?? _name;
      _email = prefs.getString(_kEmail) ?? _email;
      _phone = prefs.getString(_kPhone) ?? _phone;
      _address = prefs.getString(_kAddress) ?? _address;

      // sinkronkan ke controller (biar saat masuk edit form sudah terisi)
      _nameC.text = _name;
      _emailC.text = _email;
      _phoneC.text = _phone;
      _addressC.text = _address;

      _loading = false;
    });
  }

  void _enterEditMode() {
    setState(() {
      _nameC.text = _name;
      _emailC.text = _email;
      _phoneC.text = _phone;
      _addressC.text = _address;
      _isEditing = true;
    });
  }

  void _cancelEdit() {
    setState(() => _isEditing = false);
  }

  Future<void> _saveProfile() async {
    // ambil nilai dari form
    final updatedName = _nameC.text.trim();
    final updatedEmail = _emailC.text.trim();
    final updatedPhone = _phoneC.text.trim();
    final updatedAddress = _addressC.text.trim();

    // simpan ke storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, updatedName);
    await prefs.setString(_kEmail, updatedEmail);
    await prefs.setString(_kPhone, updatedPhone);
    await prefs.setString(_kAddress, updatedAddress);

    // update state tampilan
    setState(() {
      _name = updatedName;
      _email = updatedEmail;
      _phone = updatedPhone;
      _address = updatedAddress;
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDFD0),
      appBar: AppBar(
        title: const Text('Akun Saya'),
        backgroundColor: const Color(0xFFFFAA4D),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto profil
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: const Color(0xFFFFAA4D).withOpacity(0.2),
                backgroundImage:
                const AssetImage('assets/images/profile.png'),
              ),
            ),
            const SizedBox(height: 16),

            // Nama pengguna
            Text(
              _name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Member Sejak 2025',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // Kartu biodata (view / edit)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Biodata',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFAA4D),
                    ),
                  ),
                  const Divider(height: 20, thickness: 1),
                  const SizedBox(height: 8),

                  // ======= MODE TAMPIL =======
                  if (!_isEditing) ...[
                    _InfoRow(title: 'Nama Lengkap', value: _name),
                    _InfoRow(title: 'Email', value: _email),
                    _InfoRow(title: 'Nomor HP', value: _phone),
                    _InfoRow(title: 'Alamat', value: _address),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFAA4D),
                          foregroundColor: Colors.white,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _enterEditMode,
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          'Ubah Profil',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ]

                  // ======= MODE EDIT =======
                  else ...[
                    _TextFieldLined(
                      label: 'Nama Lengkap',
                      controller: _nameC,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 12),
                    _TextFieldLined(
                      label: 'Email',
                      controller: _emailC,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    _TextFieldLined(
                      label: 'Nomor HP',
                      controller: _phoneC,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    _TextFieldLined(
                      label: 'Alamat',
                      controller: _addressC,
                      keyboardType: TextInputType.streetAddress,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              side: const BorderSide(
                                  color: Color(0xFFFFAA4D), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              foregroundColor: const Color(0xFFFFAA4D),
                            ),
                            onPressed: _cancelEdit,
                            child: const Text('Batal'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFAA4D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _saveProfile,
                            child: const Text('Simpan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextFieldLined extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;

  const _TextFieldLined({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
