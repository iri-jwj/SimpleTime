import 'package:project_flutter/sql/basic_database.dart';
import 'package:project_flutter/sql/database_observer.dart';
import 'package:sqflite/sqflite.dart';

class BasicSqlHelper {
  BasicSqlHelper(this._basicDatabase);

  final BasicDatabase _basicDatabase;

  DatabaseObserver _observer;

  void attachToObserver(DatabaseObserver observer) {
    _observer = observer;
    _observer.attachSqlHelper = this;
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    int result = await _basicDatabase.insert(table, values);
    _observer?.onTableUpdate(table, values["id"], DatabaseMethod.insert);
    return result;
  }

  Future<int> delete(String table, {String where, List<dynamic> args}) async {
    if (where.contains("id")) {
      _observer?.onTableUpdate(table, args[0], DatabaseMethod.delete);
    }
    int result = await _basicDatabase.delete(table, where: where, args: args);
    return result;
  }

  Future<int> update(String table, Map<String, dynamic> values,
      {String where,
      List<dynamic> whereArgs,
      ConflictAlgorithm conflictAlgorithm}) async {
    if (where.contains("id")) {
      _observer?.onTableUpdate(table, whereArgs[0], DatabaseMethod.update);
    }

    int result = await _basicDatabase.update(table, values,
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
    List<Map<String, dynamic>> result = await _basicDatabase.query(table,
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
