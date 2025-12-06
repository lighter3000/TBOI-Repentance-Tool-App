import "dart:io";
import "package:flutter/services.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";

class DatabaseLoader {
  static Future<String> loadDatabase() async {
    // App documents directory
    final documentsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDir.path, "items.db");

    // If the DB already exists, return the path
    if (File(dbPath).existsSync()) {
      return dbPath;
    }

    // Copy DB from assets to device
    final data = await rootBundle.load("assets/db/items.db");
    final bytes = data.buffer.asUint8List();

    await File(dbPath).writeAsBytes(bytes, flush: true);

    return dbPath;
  }
}
