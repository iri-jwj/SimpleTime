import 'package:project_flutter/sql/basic_database.dart';
import 'package:project_flutter/util/bool_int_converter.dart';
import 'package:sqflite/sqflite.dart';

class AnnualPlanSqlHelper {
  static const String TABLE_NAME = "annual_plan";
  static const String COLUMN_id = "id";
  static const String COLUMN_TITLE = "title";
  static const String COLUMN_isCyclePlan = "isCyclePlan";
  static const String COLUMN_cycle = "cycle";
  static const String COLUMN_remindDate = "remindDate";
  static const String COLUMN_remark = "remark";
  static const String COLUMN_remindOpportunity = "remindOpportunity";
  static const String COLUMN_isAutoDelay = "isAutoDelay";
  static const String COLUMN_lastDayRemind = "lastDayRemind";
  static const String COLUMN_whenToStart = "whenToStart";
  static const String COLUMN_isAllYearPlan = "isAllYearPlan";
  static const String COLUMN_lastTimes = "lastTimes";
  static const String COLUMN_progress = "progress";

  static const String CREATE_ANNUAL_PLAN_TABLE = '''
create table $TABLE_NAME ( 
  $COLUMN_id text primary key, 
  $COLUMN_TITLE text not null,
  $COLUMN_isCyclePlan int not null,
  $COLUMN_cycle text,
  $COLUMN_remindDate text,
  $COLUMN_remark text,
  $COLUMN_remindOpportunity text,
  $COLUMN_isAutoDelay int,
  $COLUMN_lastDayRemind int,
  $COLUMN_whenToStart text,
  $COLUMN_isAllYearPlan int,
  $COLUMN_lastTimes int,
  $COLUMN_progress num)
''';

  final BasicDatabase _basicDatabase;

  AnnualPlanSqlHelper(this._basicDatabase);

  Future<int> insert(String table, Map<String, dynamic> values) async {
    var convertedValue = BoolIntConverter.mapConvertBool2Int(values);
    int result = await _basicDatabase.insert(table, convertedValue);
    return result;
  }

  Future<int> delete(String table, {String where, List<dynamic> args}) async {
    var convertedArgs = BoolIntConverter.listConvertBool2Int(args);
    int result =
        await _basicDatabase.delete(table, where: where, args: convertedArgs);
    return result;
  }

  Future<int> update(String table, Map<String, dynamic> values,
      {String where,
      List<dynamic> whereArgs,
      ConflictAlgorithm conflictAlgorithm}) async {
    var convertedValue = BoolIntConverter.mapConvertBool2Int(values);
    var convertedArgs = BoolIntConverter.listConvertBool2Int(whereArgs);
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
