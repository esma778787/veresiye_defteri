import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/veresiye_model.dart';
import 'veresiye_form_screen.dart';
import 'veresiye_detail_screen.dart';

class VeresiyeScreen extends StatefulWidget {
  const VeresiyeScreen({super.key});

  @override
  State<VeresiyeScreen> createState() => _VeresiyeScreenState();
}

class _VeresiyeScreenState extends State<VeresiyeScreen> {
  late Box<VeresiyeModel> _veresiyeBox;
  String _aramaKelimesi = '';
  double _toplamBorc = 0.0;

  @override
  void initState() {
    super.initState();
    _veresiyeBox = Hive.box<VeresiyeModel>('veresiye');
    _hesaplaToplamBorc();
  }

  void _hesaplaToplamBorc() {
    double toplam = 0.0;
    for (var item in _veresiyeBox.values) {
      if (_aramaKelimesi.trim().isNotEmpty &&
          !item.musteriAdi.toLowerCase().contains(_aramaKelimesi.toLowerCase())) continue;
      if (item.odenenTutar < item.borcTutari) {
        toplam += (item.borcTutari - item.odenenTutar);
      }
    }
    setState(() => _toplamBorc = toplam);
  }

  void _yeniKayitEkle() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VeresiyeFormScreen()),
    );
    _hesaplaToplamBorc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Veresiye Defteri')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Müşteri Ara',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _aramaKelimesi = value;
                  _hesaplaToplamBorc();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Toplam Kalan Borç: ₺${_toplamBorc.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _veresiyeBox.listenable(),
              builder: (context, Box<VeresiyeModel> box, _) {
                final veriler = box.values.toList();

                final Map<String, List<VeresiyeModel>> gruplar = {};

                for (var item in veriler) {
                  if (_aramaKelimesi.isNotEmpty &&
                      !item.musteriAdi.toLowerCase().contains(_aramaKelimesi.toLowerCase())) {
                    continue;
                  }
                  gruplar.putIfAbsent(item.musteriAdi, () => []).add(item);
                }

                if (gruplar.isEmpty) {
                  return const Center(child: Text('Kayıt bulunamadı'));
                }

                final musteriListesi = gruplar.keys.toList();

                return ListView.builder(
                  itemCount: musteriListesi.length,
                  itemBuilder: (context, index) {
                    final musteriAdi = musteriListesi[index];
                    final kayitlar = gruplar[musteriAdi]!;

                    final toplamKalan = kayitlar.fold(
                      0.0,
                      (sum, e) => sum + (e.borcTutari - e.odenenTutar),
                    );

                    return ListTile(
                      title: Text(musteriAdi),
                      subtitle: Text(
                        'Kalan Borç: ₺${toplamKalan.toStringAsFixed(2)} (${kayitlar.length} kayıt)',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VeresiyeDetailScreen(
                              index: -1,
                              veri: kayitlar.first,
                              tumKayitlar: kayitlar,
                            ),
                          ),
                        ).then((_) => _hesaplaToplamBorc());
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _yeniKayitEkle,
        child: const Icon(Icons.add),
      ),
    );
  }
}
