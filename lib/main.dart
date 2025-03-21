import 'package:flutter/material.dart';
import 'screens/home_screen.dart';  // HomeScreen tanımınızın olduğu dosya

void main() {
  runApp(const KarZararHesaplamaApp());
}

class KarZararHesaplamaApp extends StatelessWidget {
  const KarZararHesaplamaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kar-Zarar Hesaplama',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(color: Color(0xFF1D1D1D)),
        primaryColor: Colors.blue,
      ),
      home: HomeScreen(),  // const ifadesini kaldırdık; çünkü HomeScreen içinde mutable alanlar varsa
    );
  }
}
