import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:timetable_project/ScheduleFolder/Scheduleinfo.dart';

final String tableSchedule = 'schedule';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnTime = 'time';
final String columnAddress = 'address';
final String columnContent = 'content';
final String columnColors = 'colors';

class ScheduleHelper {
  static Database _database;
  static ScheduleHelper _scheduleHelper;

  ScheduleHelper._createInstance();
  factory ScheduleHelper() {
    if (_scheduleHelper == null) {
      _scheduleHelper = ScheduleHelper._createInstance();
    }
    return _scheduleHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "alarm.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $tableSchedule ( 
          $columnId integer primary key autoincrement, 
          $columnTime text not null,
          $columnTitle text not null,
          $columnAddress text,
          $columnContent text ,
          $columnColors integer)
        ''');
      },
    );
    return database;
  }

  void insertSchedule(ScheduleInfo scheduleInfo) async {
    var db = await this.database;
    var result = await db.insert(tableSchedule, scheduleInfo.toMap());
    print('result : $result');
  }

  Future<List<ScheduleInfo>> getSchedule() async {
    List<ScheduleInfo> _schedule = [];

    var db = await this.database;
    var result = await db.query(tableSchedule);
    result.forEach((element) {
      var scheduleInfo = ScheduleInfo.fromMap(element);
      _schedule.add(scheduleInfo);
    });

    return _schedule;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db
        .delete(tableSchedule, where: '$columnId = ?', whereArgs: [id]);
  }
}
