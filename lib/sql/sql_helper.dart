import 'package:project_flutter/sql/basic_database.dart';
import 'package:project_flutter/sql/database_observer.dart';
import 'package:project_flutter/util/bool_int_converter.dart';
import 'package:sqflite/sqflite.dart';

class BasicSqlHelper {
  BasicSqlHelper(this._basicDatabase);

  final BasicDatabase _basicDatabase;

  DatabaseObserver _observer;

  Function insertListener;
  Function updateListener;
  Function deleteListener;

  void attachToObserver(DatabaseObserver observer) {
    _observer = observer;
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    var convertedValue = BoolIntConverter.mapConvertBool2Int(values);
    int result = await _basicDatabase.insert(table, convertedValue);
    _observer?.onTableUpdate(table, values["id"], DatabaseMethod.insert);
    return result;
  }

  Future<int> delete(String table, {String where, List<dynamic> args}) async {
    var convertedArgs;
    if (args != null) {
      convertedArgs = BoolIntConverter.listConvertBool2Int(args);
    }

    if(where.contains("id")){
      _observer?.onTableUpdate(table, args[0], DatabaseMethod.delete);
    }

    int result =
        await _basicDatabase.delete(table, where: where, args: convertedArgs);
    return result;
  }

  Future<int> update(String table, Map<String, dynamic> values,
      {String where,
      List<dynamic> whereArgs,
      ConflictAlgorithm conflictAlgorithm}) async {
    var convertedValue;
    if (values != null) {
      convertedValue = BoolIntConverter.mapConvertBool2Int(values);
    }
    var convertedArgs;
    if (whereArgs != null) {
      convertedArgs = BoolIntConverter.listConvertBool2Int(whereArgs);
    }

    if(where.contains("id")){
      _observer?.onTableUpdate(table, whereArgs[0], DatabaseMethod.update);
    }

    int result = await _basicDatabase.update(table, convertedValue,
        where: where,
        whereArgs: convertedArgs,
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
    var convertedArgs;
    if (whereArgs != null) {
      convertedArgs = BoolIntConverter.listConvertBool2Int(whereArgs);
    }
    List<Map<String, dynamic>> result = await _basicDatabase.query(table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: convertedArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        offset: offset);
    return result;
  }
}
