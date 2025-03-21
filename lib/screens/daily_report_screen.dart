import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../models/product.dart';

class DailyReportScreen extends StatefulWidget {
  const DailyReportScreen({Key? key}) : super(key: key);

  @override
  _DailyReportScreenState createState() => _DailyReportScreenState();
}

class _DailyReportScreenState extends State<DailyReportScreen> {
  List<Map<String, dynamic>> _sales = [];
  double _totalSales = 0.0;
  double _totalProfit = 0.0;
  double _exchangeRate = 18.0; // Basitlik açısından burada sabit bırakıyoruz

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  Future<void> _loadSales() async {
    final allSales = await DatabaseHelper.instance.queryAllSales();
    final allProducts = await DatabaseHelper.instance.queryAllProducts();

    DateTime today = DateTime.now();
    List<Map<String, dynamic>> todaySales = allSales.where((sale) {
      DateTime saleDate = DateTime.parse(sale['saleDate']);
      return saleDate.year == today.year &&
          saleDate.month == today.month &&
          saleDate.day == today.day;
    }).toList();

    double totalSales = 0.0;
    double totalCost = 0.0;

    for (var sale in todaySales) {
      int quantity = sale['quantity'];
      double salePrice = sale['salePrice'];
      totalSales += salePrice * quantity;

      final productMap = allProducts.firstWhere(
            (p) => p['name'] == sale['productName'],
        orElse: () => <String, dynamic>{},
      );
      if (productMap.isNotEmpty) {
        final product = Product.fromMap(productMap);
        totalCost += product.totalCost * quantity;
      }
    }

    setState(() {
      _sales = todaySales;
      _totalSales = totalSales;
      _totalProfit = totalSales - totalCost;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profitText = _totalProfit >= 0
        ? "Toplam Kar: +${_totalProfit.toStringAsFixed(2)} TL"
        : "Toplam Zarar: ${_totalProfit.toStringAsFixed(2)} TL";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Günlük Raporlar"),
        centerTitle: true,
      ),
      body: _sales.isEmpty
          ? const Center(child: Text("Bugün hiç satış kaydı yok.", style: TextStyle(fontSize: 18)))
          : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            profitText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _totalProfit >= 0 ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          ..._sales.map((sale) => Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(sale['productName']),
              subtitle: Text("Adet: ${sale['quantity']} - Fiyat: ${sale['salePrice']} TL"),
              trailing: Text(sale['saleDate'], style: const TextStyle(fontSize: 12)),
            ),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadSales,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
