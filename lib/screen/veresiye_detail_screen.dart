import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/veresiye_model.dart';

class VeresiyeDetailScreen extends StatefulWidget {
  final int index; // kullanılmasa bile gerekiyor
  final VeresiyeModel veri;
  final List<VeresiyeModel> tumKayitlar; // müşteri bazlı tüm kayıtlar

  const VeresiyeDetailScreen({
    super.key,
    required this.index,
    required this.veri,
    required this.tumKayitlar,
  });

  @override
  State<VeresiyeDetailScreen> createState() => _VeresiyeDetailScreenState();
}

class _VeresiyeDetailScreenState extends State<VeresiyeDetailScreen> {
  late Box<VeresiyeModel> _box;

  @override
  void initState() {
    super.initState();
    _box = Hive.box<VeresiyeModel>('veresiye');
  }

  void _kaydiSil(int index) async {
    final sil = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kaydı Sil"),
        content: const Text("Bu kaydı silmek istediğinize emin misiniz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("İptal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Sil")),
        ],
      ),
    );

    if (sil == true) {
      await _box.deleteAt(index);
      setState(() {});
    }
  }

  void _odemeEkle(int index, VeresiyeModel kayit) async {
    final controller = TextEditingController();

    final onaylandi = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ödeme Yap"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Ödenen Tutar"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("İptal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Onayla")),
        ],
      ),
    );

    if (onaylandi == true) {
      final odenen = double.tryParse(controller.text.trim()) ?? 0.0;
      final toplamOdenen = kayit.odenenTutar + odenen;

      final yeniKayit = VeresiyeModel(
        kayit.musteriAdi,
        kayit.borcTutari,
        kayit.tarih,
        toplamOdenen >= kayit.borcTutari,
        kayit.not,
        toplamOdenen,
      );

      await _box.putAt(index, yeniKayit);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final kayitlar = widget.tumKayitlar;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.veri.musteriAdi} - Kayıtları')),
      body: ListView.builder(
        itemCount: kayitlar.length,
        itemBuilder: (context, i) {
          final kayit = kayitlar[i];
          final indexInBox = _box.values.toList().indexOf(kayit);
          final kalan = kayit.borcTutari - kayit.odenenTutar;

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text("📅 ${kayit.tarih.toLocal().toString().split(' ')[0]}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📝 ${kayit.not}"),
                  Text("💰 Borç: ₺${kayit.borcTutari.toStringAsFixed(2)}"),
                  Text("✔️ Ödenen: ₺${kayit.odenenTutar.toStringAsFixed(2)}"),
                  Text("❗ Kalan: ₺${kalan.toStringAsFixed(2)}"),
                ],
              ),
              trailing: Wrap(
                spacing: 8,
                children: [
                  IconButton(
                    icon: const Icon(Icons.payment, color: Colors.blue),
                    onPressed: () => _odemeEkle(indexInBox, kayit),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _kaydiSil(indexInBox),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}
