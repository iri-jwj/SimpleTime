import 'package:path/path.dart';
import 'package:project_flutter/sql/sql_entity.dart';
import 'package:sqflite/sqflite.dart';

class BasicDatabase {
  static BasicDatabase _instance;

  factory BasicDatabase() => _getInstance();

  static BasicDatabase get instance => _getInstance();

  static BasicDatabase _getInstance() {
    if (_instance == null) {
      _instance = new BasicDatabase._internalConstructor();
    }
    return _instance;
  }

  BasicDatabase._internalConstructor();

  Database _database;

  initDatabase() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "simpleTime.db");
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      db.execute(AnnualPlanSqlEntity.CREATE_ANNUAL_PLAN_TABLE);
      db.execute(ScheduleSqlEntity.CREATE_ANNUAL_PLAN_TABLE);
      db.execute(UpdatedDataEntity.CREATE_ANNUAL_PLAN_TABLE);
      db.execute(ToDoSqlEntity.CREATE_ANNUAL_PLAN_TABLE);
    });
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    int result = await _database.insert(table, values);
    return result;
  }

  Future<int> delete(String table, {String where, List<dynamic> args}) async {
    int result = await _database.delete(table, where: where, whereArgs: args);
    return result;
  }

  Future<int> update(String table, Map<String, dynamic> values,
      {String where,
      List<dynamic> whereArgs,
      ConflictAlgorithm conflictAlgorithm}) async {
    int result = await _database.update(table, values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm);
    return result;
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {bool distinct,
      List<String> columns,
      String where,
      List<dynamic> whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) async {
    List<Map<String, dynamic>> result = await _database.query(table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        offset: offset);
    return result;
  }
}
