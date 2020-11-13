import 'package:sqflite/sqflite.dart';
import 'day_db_utils.dart';
import 'package:travel_app/trip_manager/trip.dart';

class DayModel{
  //get all Trips
  Future<List<Day>> getAllDays() async {
    final db = await DBUtils().init();
    final List<Map<String, dynamic>> maps = await db.query('day_items');
    List<Day> days = [];

    for (int i = 0; i < maps.length; i++){
      days.add(Day.fromMap(maps[i]));
    }
    return days;
  }

  //add Trip
  Future<int> insertDay(Day day) async {
    final db = await DBUtils().init();
    return db.insert(
      'day_items', 
      day.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}