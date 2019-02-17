import 'package:project_flutter/sql/sql_entity.dart';
import 'package:project_flutter/sql/sql_helper.dart';

class DatabaseObserver {
  BasicSqlHelper _basicSqlHelper;

  Function _onUpdateCallback;

  DatabaseObserver(this._basicSqlHelper);

  void onTableUpdate(String targetTable, String id, DatabaseMethod method) {
    if (targetTable != UpdatedDataEntity.TABLE_NAME) {
      int methodType = 0;
      switch (method) {
        case DatabaseMethod.update:
          methodType = 0;
          break;
        case DatabaseMethod.insert:
          methodType = 1;
          break;
        case DatabaseMethod.delete:
          methodType = 2;
          break;
      }
      if (_onUpdateCallback != null) {
        _onUpdateCallback();
      }
      _basicSqlHelper.insert(UpdatedDataEntity.TABLE_NAME, <String, dynamic>{
        UpdatedDataEntity.COLUMN_id: id,
        UpdatedDataEntity.COLUMN_tableName: targetTable,
        UpdatedDataEntity.COLUMN_isUpToDate: 0,
        UpdatedDataEntity.COLUMN_method: methodType
      });
    }
  }

  set onUpdateCallback(Function callback) => _onUpdateCallback = callback;

  void removeCallback() {
    _onUpdateCallback = null;
  }
}

enum DatabaseMethod { update, insert, delete }
