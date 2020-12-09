import 'package:sqflite/sqflite.dart';
import 'event_db_utils.dart';
import 'package:travel_app/trip_manager/trip_components/event.dart';

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

  //Add Events
  Future<int> insertEvent(Event event) async {
    final db = await DBUtils().init();
    return db.insert(
      'event_items', 
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Update Event
  Future<void> updateEvent(Event event) async {
    final db = await DBUtils().init();
    await db.update(
      'event_items', 
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  //Delete Event
  Future<void> deleteEvent(int id) async {
    final db = await DBUtils().init();
    await db.delete(
      'event_items', 
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}