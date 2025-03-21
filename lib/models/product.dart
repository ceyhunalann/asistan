class Product {
  int? id;
  String name;
  double cost;         // Geliş Fiyatı
  double salePrice;    // Satış Fiyatı (TL)
  double commission;   // Mağaza Komisyonu (%)
  double shippingCost; // Kargo Maliyeti (TL)
  double extraCost;    // Ekstra Giderler (TL)
  bool isDollar;       // Geliş fiyatı dolar mı?
  double exchangeRate; // Döviz kuru

  Product({
    this.id,
    required this.name,
    required this.cost,
    required this.salePrice,
    required this.commission,
    required this.shippingCost,
    required this.extraCost,
    required this.isDollar,
    required this.exchangeRate,
  });

  double get finalCost => isDollar ? cost * exchangeRate : cost;

  double get totalCost {
    double baseCost = finalCost + extraCost + shippingCost;
    double commissionCost = salePrice * (commission / 100);
    return baseCost + commissionCost;
  }

  double calculateProfitOrLoss() {
    return salePrice - totalCost;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'salePrice': salePrice,
      'commission': commission,
      'shippingCost': shippingCost,
      'extraCost': extraCost,
      'isDollar': isDollar ? 1 : 0,
      'exchangeRate': exchangeRate,
    };
  }

  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      salePrice: json['salePrice'],
      commission: json['commission'],
      shippingCost: json['shippingCost'],
      extraCost: json['extraCost'],
      isDollar: json['isDollar'] == 1,
      exchangeRate: json['exchangeRate'],
    );
  }
}
