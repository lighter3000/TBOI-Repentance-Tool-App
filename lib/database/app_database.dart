import "package:sqflite/sqflite.dart";
import "database_loader.dart";

class AppDatabase {
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;

    final path = await DatabaseLoader.loadDatabase();

    _db = await openDatabase(path);
    return _db!;
  }
}
