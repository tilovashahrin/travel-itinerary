import 'package:sqflite/sqflite.dart';
import 'event_db_utils.dart';
import 'package:travel_app/trip_manager/trip.dart';

class EventModel{
  //get all Events
  Future<List<Event>> getAllEvents() async {
    final db = await DBUtils().init();
    final List<Map<String, dynamic>> maps = await db.query('event_items');
    List<Event> event = [];

    for (int i = 0; i < maps.length; i++){
      event.add(Event.fromMap(maps[i]));
    }
    return event;
  }

  //add Events
  Future<int> insertEvent(Event trip) async {
    final db = await DBUtils().init();
    return db.insert(
      'event_items', 
      trip.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}