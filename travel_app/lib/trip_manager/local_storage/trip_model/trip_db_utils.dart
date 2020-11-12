import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  Future<Database> init() async {
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'trip_manager.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE trip_items(id INTEGER PRIMARY KEY, name TEXT, location TEXT, description TEXT, startDate TEXT, endDate TEXT)"
          );
      },
      version: 1,
    );
    return database;
  }
}