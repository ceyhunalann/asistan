import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_helper.dart';

class AddProductScreen extends StatefulWidget {
  final Function(Product) addProduct;
  final double exchangeRate;

  const AddProductScreen({Key? key, required this.addProduct, required this.exchangeRate}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _shippingController = TextEditingController();
  final TextEditingController _extraCostController = TextEditingController();

  double _commission = 0;
  bool _isDollar = false;
  bool _calculated = false;
  double _profitOrLoss = 0.0;

  void _calculate() {
    double costInput = double.tryParse(_costController.text) ?? 0.0;
    double salePriceInput = double.tryParse(_salePriceController.text) ?? 0.0;
    double shipping = double.tryParse(_shippingController.text) ?? 0.0;
    double extra = double.tryParse(_extraCostController.text) ?? 0.0;

    double finalCost = _isDollar ? costInput * widget.exchangeRate : costInput;
    double baseCost = finalCost + shipping + extra;
    double commissionCost = salePriceInput * (_commission / 100);
    double totalCost = baseCost + commissionCost;
    double profit = salePriceInput - totalCost;

    setState(() {
      _profitOrLoss = profit;
      _calculated = true;
    });
  }

  Future<void> _saveProduct() async {
    _calculate();
    String name = _nameController.text;
    double costInput = double.tryParse(_costController.text) ?? 0.0;
    double salePriceInput = double.tryParse(_salePriceController.text) ?? 0.0;
    double shipping = double.tryParse(_shippingController.text) ?? 0.0;
    double extra = double.tryParse(_extraCostController.text) ?? 0.0;

    Product product = Product(
      name: name,
      cost: costInput,
      salePrice: salePriceInput,
      commission: _commission,
      shippingCost: shipping,
      extraCost: extra,
      isDollar: _isDollar,
      exchangeRate: widget.exchangeRate,
    );

    await DatabaseHelper.instance.insertProduct(product.toMap());
    widget.addProduct(product);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ürün kaydedildi.")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürün Ekle & Hesapla"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Ürün Adı"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Geliş Fiyatı (KDV Dahil):", style: TextStyle(fontSize: 16)),
                const Spacer(),
                const Text("TL"),
                Radio<bool>(
                  value: false,
                  groupValue: _isDollar,
                  onChanged: (value) {
                    setState(() {
                      _isDollar = value ?? false;
                    });
                  },
                ),
                const Text("Dolar"),
                Radio<bool>(
                  value: true,
                  groupValue: _isDollar,
                  onChanged: (value) {
                    setState(() {
                      _isDollar = value ?? true;
                    });
                  },
                ),
              ],
            ),
            TextField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: "Geliş Fiyatı"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _salePriceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Satış Fiyatı (TL)"),
            ),
            const SizedBox(height: 20),
            Text("Mağaza Komisyonu: ${_commission.toStringAsFixed(0)}%", style: const TextStyle(fontSize: 16)),
            Slider(
              value: _commission,
              min: 0,
              max: 50,
              divisions: 50,
              label: "${_commission.toStringAsFixed(0)}%",
              onChanged: (value) {
                setState(() {
                  _commission = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _shippingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Kargo Maliyeti (TL)"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _extraCostController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Ekstra Giderler (TL)"),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _calculate,
                  child: const Text("Hesapla"),
                ),
                ElevatedButton(
                  onPressed: _saveProduct,
                  child: const Text("Ürünü Kaydet"),
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
