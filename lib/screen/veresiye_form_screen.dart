import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/veresiye_model.dart';

class VeresiyeFormScreen extends StatefulWidget {
  const VeresiyeFormScreen({super.key});

  @override
  State<VeresiyeFormScreen> createState() => _VeresiyeFormScreenState();
}

class _VeresiyeFormScreenState extends State<VeresiyeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _musteriCtrl = TextEditingController();
  final _borcCtrl = TextEditingController();
  final _notCtrl = TextEditingController();
  bool _odendiMi = false;
  DateTime _secilenTarih = DateTime.now();

  void _tarihSec() async {
    final secilen = await showDatePicker(
      context: context,
      initialDate: _secilenTarih,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (secilen != null) {
      setState(() {
        _secilenTarih = secilen;
      });
    }
  }

  void _kaydet() async {
    if (_formKey.currentState!.validate()) {
      final yeniKayit = VeresiyeModel(
        _musteriCtrl.text.trim(),
        double.parse(_borcCtrl.text.trim()),
        _secilenTarih,
        _odendiMi,
        _notCtrl.text.trim(),
      );

      final box = Hive.box<VeresiyeModel>('veresiye');
      await box.add(yeniKayit);

      Navigator.pop(context); // VeresiyeScreen'e geri dön
    }
  }

  @override
  void dispose() {
    _musteriCtrl.dispose();
    _borcCtrl.dispose();
    _notCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yeni Veresiye Kaydı")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _musteriCtrl,
                decoration: const InputDecoration(labelText: 'Müşteri Adı'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Bu alan zorunlu' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _borcCtrl,
                decoration: const InputDecoration(labelText: 'Borç Tutarı'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Bu alan zorunlu';
                  if (double.tryParse(value) == null) return 'Geçerli sayı girin';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notCtrl,
                decoration: const InputDecoration(labelText: 'Açıklama (İsteğe bağlı)'),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text("Tarih: ${DateFormat('dd.MM.yyyy').format(_secilenTarih)}"),
                trailing: const Icon(Icons.calendar_month),
                onTap: _tarihSec,
              ),
              SwitchListTile(
                title: const Text("Ödendi mi?"),
                value: _odendiMi,
                onChanged: (value) {
                  setState(() => _odendiMi = value);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Kaydet"),
                onPressed: _kaydet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
