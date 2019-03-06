import 'package:project_flutter/model/base_model.dart';
import 'package:project_flutter/model/personal_schedule_model.dart';
import 'package:project_flutter/model/to_do_model.dart';
import 'package:project_flutter/scenes/base_bloc.dart';
import 'package:project_flutter/sql/sql_entity.dart';
import 'package:rxdart/rxdart.dart';

class PersonalScheduleBloc extends BaseBloc {
  List<ToDoModel> _tempToDo;
  List<PersonalScheduleModel> _tempSchedule;

  var _toDoListToShow = List<ToDoModel>();
  var _scheduleListToShow = List<PersonalScheduleModel>();

  var _toDoController = BehaviorSubject<List<ToDoModel>>();
  var _scheduleController = BehaviorSubject<List<PersonalScheduleModel>>();

  Observable<List<ToDoModel>> get toDoStream => _toDoController.stream;

  Observable<List<PersonalScheduleModel>> get scheduleStream =>
      _scheduleController.stream;

  @override
  void depose() {
    _toDoController.close();
    _scheduleController.close();
  }

  void loadAllData() async {
    var tempToDoMap = await helper.query(ToDoSqlEntity.TABLE_NAME);
    tempToDoMap.forEach((entity) {
      _tempToDo.add(ToDoModel.fromJson(entity));
    });

    var tempScheduleMap = await helper.query(ScheduleSqlEntity.TABLE_NAME);
    tempScheduleMap.forEach((schedule) {
      _tempSchedule.add(PersonalScheduleModel.fromJson(schedule));
    });
  }

  void loadDataByDate(int year, int month, int day) {
    _toDoListToShow.clear();
    _scheduleListToShow.clear();
    DateTime early = DateTime(year, month, day);
    DateTime later = DateTime(year, month, day, 23, 59, 59, 999, 999);
    _tempToDo.forEach((todo) {
      if (todo.remindTime.isAfter(early) && todo.remindTime.isBefore(later)) {
        _toDoListToShow.add(todo);
      }
    });
    _tempSchedule.forEach((schedule) {
      if (schedule.startTime.isAfter(early) &&
          schedule.startTime.isBefore(later)) {
        _scheduleListToShow.add(schedule);
      }
    });

    _toDoListToShow = _sortToDo(_toDoListToShow);

    _toDoController.add(_toDoListToShow);
    _scheduleController.add(_scheduleListToShow);
  }

  List<ToDoModel> _sortToDo(List<ToDoModel> todos) {
    todos.sort(
        (former, latter) => former.importance.compareTo(latter.importance));

    todos.sort(
        (former, latter) => former.isFinished.compareTo(latter.isFinished));
    return todos;
  }

  void addToDo(ToDoModel todo) async {
    int result = await helper.insert(ToDoSqlEntity.TABLE_NAME, todo.toJson());
    if (result < 0) {
      throw "插入todo异常";
    }
    _tempToDo.add(todo);
    _toDoListToShow.add(todo);
    _toDoListToShow = _sortToDo(_toDoListToShow);
    _toDoController.add(_toDoListToShow);
  }

  void addSchedule(PersonalScheduleModel schedule) async {
    int result =
        await helper.insert(ScheduleSqlEntity.TABLE_NAME, schedule.toJson());
    if (result < 0) {
      throw "插入schedule异常";
    }
    _tempSchedule.add(schedule);
    _scheduleListToShow.add(schedule);
    _scheduleController.add(_scheduleListToShow);
  }

  void editToDo(ToDoModel editedTodo) async {
    var result = await helper.update(
        ToDoSqlEntity.TABLE_NAME, editedTodo.toJson(),
        where: "id", whereArgs: [editedTodo.id]);
    if (result < 0) {
      throw "更新todo异常";
    }
    _tempToDo = updateItem(_tempToDo, editedTodo);

    _toDoListToShow = updateItem(_toDoListToShow, editedTodo);
    _toDoListToShow = _sortToDo(_toDoListToShow);

    _toDoController.add(_toDoListToShow);
  }

  void editSchedule(PersonalScheduleModel editedSchedule) async {
    var result = await helper.update(
        ScheduleSqlEntity.TABLE_NAME, editedSchedule.toJson(),
        where: "id", whereArgs: [editedSchedule.id]);

    if (result < 0) {
      throw "更新schedule异常";
    }

    _tempSchedule = updateItem(_tempSchedule, editedSchedule);

    _scheduleListToShow = updateItem(_scheduleListToShow, editedSchedule);
    _scheduleController.add(_scheduleListToShow);
  }

  List<BaseModel> updateItem(List<BaseModel> listToUpdate, BaseModel editItem) {
    for (var item in listToUpdate) {
      if (item.id == editItem.id) {
        listToUpdate.remove(item);
        listToUpdate.add(editItem);
        return listToUpdate;
      }
    }
    return listToUpdate;
  }

  void deleteToDo(String id) async {
    var result =
        await helper.delete(ToDoSqlEntity.TABLE_NAME, where: "id", args: [id]);
    if (result < 0) {
      throw "删除todo异常";
    }

    _tempToDo = deleteItem(_tempToDo, id);
    _toDoListToShow = deleteItem(_toDoListToShow, id);
    _toDoController.add(_toDoListToShow);
  }

  List<BaseModel> deleteItem(List<BaseModel> listToDelete, String id) {
    for (var item in listToDelete) {
      if (item.id == id) {
        listToDelete.remove(item);
        return listToDelete;
      }
    }
    return listToDelete;
  }

  void deleteSchedule(String id) async {
    var result = await helper
        .delete(ScheduleSqlEntity.TABLE_NAME, where: "id", args: [id]);
    if (result < 0) {
      throw "删除schedule异常";
    }

    _tempSchedule = deleteItem(_tempSchedule, id);
    _scheduleListToShow = deleteItem(_tempSchedule, id);
    _scheduleController.add(_scheduleListToShow);
  }

  void finishToDo(String id) async {
    var result = await helper.update(
        ToDoSqlEntity.TABLE_NAME, {ToDoSqlEntity.COLUMN_isFinished: 1},
        where: ToDoSqlEntity.COLUMN_id, whereArgs: [id]);

    if (result < 0) {
      throw "更新todo为完成出错";
    }

    for (var todo in _tempToDo) {
      if (todo.id == id) {
        Map temp = todo.toJson();
        temp[ToDoSqlEntity.COLUMN_id] = 1;
        var newTodo = ToDoModel.fromJson(temp);
        _tempToDo.remove(todo);
        _tempToDo.add(newTodo);

        _toDoListToShow.remove(todo);
        _toDoListToShow.add(newTodo);
        _toDoListToShow = _sortToDo(_toDoListToShow);
      } else {
        throw "数据出错";
      }
    }

    _toDoController.add(_toDoListToShow);
  }
}
