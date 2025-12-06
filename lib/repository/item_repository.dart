import "package:sqflite/sqflite.dart";
import "../database/app_database.dart";
import "../data/items.dart"; // for Item class

class ItemRepository {
  Future<List<Item>> getAllItems() async {
    final db = await AppDatabase.instance();

    final maps = await db.query("items");

    return maps.map((m) => Item.fromMap(m)).toList();
  }

  Future<Item?> getItemById(int id) async {
    final db = await AppDatabase.instance();

    final maps = await db.query(
      "items",
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return Item.fromMap(maps.first);
  }

  Future<List<Item>> search(String query) async {
    final db = await AppDatabase.instance();

    final maps = await db.query(
      "items",
      where: "name LIKE ?",
      whereArgs: ["%$query%"],
    );

    return maps.map((m) => Item.fromMap(m)).toList();
  }
}
