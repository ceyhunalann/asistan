import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_helper.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final TextEditingController _quantityController = TextEditingController();
  bool _calculated = false;
  double _profitOrLoss = 0.0;

  void _calculate() {
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    double totalSales = widget.product.salePrice * quantity;
    double totalCost = widget.product.totalCost * quantity;
    setState(() {
      _profitOrLoss = totalSales - totalCost;
      _calculated = true;
    });
  }

  Future<void> _saveSale() async {
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    String saleDate = DateTime.now().toIso8601String();
    Map<String, dynamic> saleData = {
      'productName': widget.product.name,
      'quantity': quantity,
      'salePrice': widget.product.salePrice,
      'saleDate': saleDate,
    };
    await DatabaseHelper.instance.insertSale(saleData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Satış kaydedildi.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ürün Adı: ${widget.product.name}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text("Geliş Fiyatı (TL): ${widget.product.finalCost.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text("Satış Fiyatı (TL): ${widget.product.salePrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Satılan Adet", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _calculate,
                  child: const Text("Hesapla"),
                ),
                ElevatedButton(
                  onPressed: _saveSale,
                  child: const Text("Satışı Kaydet"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_calculated)
              Text(
                _profitOrLoss >= 0
                    ? "Kar: ${_profitOrLoss.toStringAsFixed(2)} TL"
                    : "Zarar: ${_profitOrLoss.toStringAsFixed(2)} TL",
                style: TextStyle(
                  fontSize: 18,
                  color: _profitOrLoss >= 0 ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
