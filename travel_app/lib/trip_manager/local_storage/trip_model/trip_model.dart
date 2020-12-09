import 'package:sqflite/sqflite.dart';
import 'trip_db_utils.dart';
import 'package:travel_app/trip_manager/trip_components/trip.dart';

class TripModel{
  //get all Trips
  Future<List<Trip>> getAllTrips() async {
    final db = await DBUtils().init();
    final List<Map<String, dynamic>> maps = await db.query('trip_items');
    List<Trip> trips = [];

    for (int i = 0; i < maps.length; i++){
      trips.add(Trip.fromMap(maps[i]));
    }
    return trips;
  }

  //add Trip
  Future<int> insertTrip(Trip trip) async {
    final db = await DBUtils().init();
    return db.insert(
      'trip_items', 
      trip.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

    //Update Event
  Future<void> updateTrip(Trip trip) async {
    final db = await DBUtils().init();
    await db.update(
      'trip_items', 
      trip.toMap(),
      where: 'id = ?',
      whereArgs: [trip.id],
    );
  }

  //Delete Event
  Future<void> deleteTrip(int id) async {
    final db = await DBUtils().init();
    await db.delete(
      'trip_items', 
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}