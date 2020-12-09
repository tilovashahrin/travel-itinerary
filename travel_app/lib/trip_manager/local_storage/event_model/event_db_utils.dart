import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  Future<Database> init() async {
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'event_manager.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE event_items(id INTEGER PRIMARY KEY, name TEXT, location TEXT, description TEXT, startTime TEXT, endTime TEXT, dayId INTEGER, notificationId INTEGER)"
          );
      },
      version: 1,
    );
    return database;
  }
}