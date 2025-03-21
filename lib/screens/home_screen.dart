import 'dart:async'; // Timer için gerekli
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_helper.dart';
import '../services/exchange_rate_service.dart';
import 'add_product_screen.dart';
import 'daily_report_screen.dart';
import 'product_detail_screen.dart';
import 'about_screen.dart'; // Hakkımızda ekranını import ediyoruz

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  double _exchangeRate = 18.0;
  String _searchQuery = "";
  Timer? _exchangeRateTimer;

  @override
  void initState() {
    super.initState();
    _loadExchangeRate();
    _loadProducts();
    // Her 30 saniyede bir döviz kuru verisini güncelle
    _exchangeRateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadExchangeRate();
    });
  }

  @override
  void dispose() {
    // Timer'ı iptal et, bellekte sızıntı olmaması için
    _exchangeRateTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadExchangeRate() async {
    double rate = await ExchangeRateService().fetchExchangeRate();
    setState(() {
      _exchangeRate = rate;
    });
  }

  Future<void> _loadProducts() async {
    final dataList = await DatabaseHelper.instance.queryAllProducts();
    List<Product> dbProducts = dataList.map((json) => Product.fromMap(json)).toList();
    setState(() {
      _products = dbProducts;
    });
  }

  void _addProduct(Product product) {
    setState(() {
      _products.add(product);
    });
  }

  Future<void> _deleteProduct(Product product) async {
    if (product.id != null) {
      await DatabaseHelper.instance.deleteProduct(product.id!);
      setState(() {
        _products.remove(product);
      });
    }
  }

  void _openDailyReport() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DailyReportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = _products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kar-Zarar Hesaplama"),
        centerTitle: true,
        actions: [
          // Günlük Raporlar butonunu daha belirgin hale getirmek için
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Ink(
              decoration: const ShapeDecoration(
                color: Colors.yellow,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.assessment, color: Colors.black),
                onPressed: _openDailyReport,
                tooltip: "Günlük Raporlar",
              ),
            ),
          ),
          // Hakkımızda butonu (değişiklik yapılmadı)
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
            tooltip: "Hakkımızda",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Güncel Dolar/TL Kur: ${_exchangeRate.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Ürün Ara",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductScreen(
                      addProduct: _addProduct,
                      exchangeRate: _exchangeRate,
                    ),
                  ),
                ).then((_) => _loadProducts());
              },
              icon: const Icon(Icons.add),
              label: const Text("Ürün Ekle"),
            ),
            const SizedBox(height: 20),
            const Text("Ürünlerim", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                      "Geliş Fiyatı: ${product.finalCost.toStringAsFixed(2)} TL",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteProduct(product);
                          },
                        ),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
