import 'package:project_flutter/sql/sql_entity.dart';
import 'package:project_flutter/sql/sql_helper.dart';

class DatabaseObserver {
  BasicSqlHelper _basicSqlHelper;

  Function _onUpdateCallback;

  DatabaseObserver();

  void onTableUpdate(String targetTable, String id, DatabaseMethod method) {
    if (targetTable != UpdatedDataEntity.TABLE_NAME) {
      if (_onUpdateCallback != null) {
        _onUpdateCallback();
      }
      _basicSqlHelper.insert(UpdatedDataEntity.TABLE_NAME, <String, dynamic>{
        UpdatedDataEntity.COLUMN_id: id,
        UpdatedDataEntity.COLUMN_tableName: targetTable,
        UpdatedDataEntity.COLUMN_isUpToDate: 0,
        UpdatedDataEntity.COLUMN_method: method.toString()
      });
    }
  }

  set attachSqlHelper(BasicSqlHelper helper) => _basicSqlHelper = helper;

  set onUpdateCallback(Function callback) => _onUpdateCallback = callback;

  void removeCallback() {
    _onUpdateCallback = null;
  }
}

enum DatabaseMethod { update, insert, delete }
