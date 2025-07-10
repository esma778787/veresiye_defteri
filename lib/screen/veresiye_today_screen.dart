import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/veresiye_model.dart';

class VeresiyeTodayScreen extends StatefulWidget {
  const VeresiyeTodayScreen({super.key});

  @override
  State<VeresiyeTodayScreen> createState() => _VeresiyeTodayScreenState();
}

class _VeresiyeTodayScreenState extends State<VeresiyeTodayScreen> {
  late Box<VeresiyeModel> _veresiyeBox;
  double _bugunkuToplam = 0.0;

  @override
  void initState() {
    super.initState();
    _veresiyeBox = Hive.box<VeresiyeModel>('veresiye');
    _hesaplaBugunkuToplam();
  }

  void _hesaplaBugunkuToplam() {
    final bugun = DateTime.now();
    double toplam = 0.0;

    for (var item in _veresiyeBox.values) {
      final tarih = item.tarih;
      if (tarih.year == bugun.year &&
          tarih.month == bugun.month &&
          tarih.day == bugun.day &&
          !item.odendi) {
        toplam += item.borcTutari;
      }
    }

    setState(() => _bugunkuToplam = toplam);
  }

  bool _bugunMu(DateTime tarih) {
    final bugun = DateTime.now();
    return tarih.year == bugun.year &&
        tarih.month == bugun.month &&
        tarih.day == bugun.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bugünkü Kayıtlar")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Bugünkü Toplam Borç: ₺$_bugunkuToplam",
                style: const TextStyle(fontSize: 18)),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _veresiyeBox.listenable(),
              builder: (context, Box<VeresiyeModel> box, _) {
                final bugunkuKayitlar = box.values.where((item) => _bugunMu(item.tarih)).toList();

                if (bugunkuKayitlar.isEmpty) {
                  return const Center(child: Text("Bugün için kayıt yok"));
                }

                return ListView.builder(
                  itemCount: bugunkuKayitlar.length,
                  itemBuilder: (context, index) {
                    final item = bugunkuKayitlar[index];
                    return ListTile(
                      title: Text(item.musteriAdi),
                      subtitle: Text('${item.not} - ${item.tarih.hour}:${item.tarih.minute}'),
                      trailing: Text('${item.borcTutari}₺ - ${item.odendi ? "Ödendi" : "Ödenmedi"}'),
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
