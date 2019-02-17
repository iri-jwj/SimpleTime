class AnnualPlanSqlEntity {
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
}

class ToDoSqlEntity {
  static const String TABLE_NAME = "to_dos";
  static const String COLUMN_id = "id";
  static const String COLUMN_TITLE = "title";
  static const String COLUMN_importance = "importance";
  static const String COLUMN_remindTime = "remindTime";
  static const String COLUMN_content = "content";

  static const String CREATE_ANNUAL_PLAN_TABLE = '''
create table $TABLE_NAME ( 
  $COLUMN_id text primary key, 
  $COLUMN_TITLE text not null,
  $COLUMN_importance int not null,
  $COLUMN_remindTime text,
  $COLUMN_content text)
''';
}

class ScheduleSqlEntity {
  static const String TABLE_NAME = "personal_schedule";
  static const String COLUMN_id = "id";
  static const String COLUMN_TITLE = "title";
  static const String COLUMN_isAllDay = "isAllDay";
  static const String COLUMN_startTime = "startTime";
  static const String COLUMN_remark = "remark";

  static const String CREATE_ANNUAL_PLAN_TABLE = '''
create table $TABLE_NAME ( 
  $COLUMN_id text primary key, 
  $COLUMN_TITLE text not null,
  $COLUMN_isAllDay int not null,
  $COLUMN_startTime text,
  $COLUMN_remark text)
''';
}

class UpdatedDataEntity {
  static const String TABLE_NAME = "updatedData";
  static const String COLUMN_id = "id";
  static const String COLUMN_method = "method";
  static const String COLUMN_tableName = "tableName";
  static const String COLUMN_isUpToDate = "isUpToDate";

  static const String CREATE_ANNUAL_PLAN_TABLE = '''
create table $TABLE_NAME ( 
  $COLUMN_id text primary key, 
  $TABLE_NAME text not null,
  $COLUMN_method text not null,
  $COLUMN_isUpToDate int not null)
''';
}
