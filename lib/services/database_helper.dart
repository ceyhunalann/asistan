import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('karzarar.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE products (
        id $idType,
        name $textType,
        cost $doubleType,
        salePrice $doubleType,
        commission $doubleType,
        shippingCost $doubleType,
        extraCost $doubleType,
        isDollar $intType,
        exchangeRate $doubleType
      )
    ''');

    await db.execute('''
      CREATE TABLE sales (
        id $idType,
        productName $textType,
        quantity $intType,
        salePrice $doubleType,
        saleDate $textType
      )
    ''');
  }

  Future<int> insertProduct(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('products', row);
  }

  Future<List<Map<String, dynamic>>> queryAllProducts() async {
    final db = await instance.database;
    return await db.query('products');
  }

  Future<int> deleteProduct(int id) async {
    final db = await instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertSale(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('sales', row);
  }

  Future<List<Map<String, dynamic>>> queryAllSales() async {
    final db = await instance.database;
    return await db.query('sales');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
