import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/veresiye_model.dart';
import 'screen/veresiye_screen.dart'; // DÜZGÜN YOL!

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive başlatılıyor
  await Hive.initFlutter();

  // Modeli Hive'a kaydediyoruz
  Hive.registerAdapter(VeresiyeModelAdapter());

  // Veresiye kutusu açılıyor
  await Hive.openBox<VeresiyeModel>('veresiye');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veresiye Defteri',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const VeresiyeScreen(),
    );
  }
}
