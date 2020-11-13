import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  Future<Database> init() async {
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'day_manager.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE day_items(id INTEGER PRIMARY KEY, dayNum INTEGER, dayString TEXT, tripId INTEGER, date TEXT)"
          );
      },
      version: 1,
    );
    return database;
  }
}