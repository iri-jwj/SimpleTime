import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:project_flutter/model/annual_plan_model.dart';
import 'package:project_flutter/model/base_model.dart';
import 'package:project_flutter/model/personal_schedule_model.dart';
import 'package:project_flutter/model/to_do_model.dart';
import 'package:project_flutter/sql/basic_database.dart';
import 'package:project_flutter/sql/database_observer.dart';
import 'package:project_flutter/sql/sql_helper.dart';
import 'package:project_flutter/util/database_read_write.dart';
import 'package:project_flutter/util/onedrive_request.dart';
import 'package:project_flutter/util/project_xml_helper.dart';
import 'package:project_flutter/util/shared_preference.dart';

abstract class BaseBloc {
  void depose();

  DatabaseObserver observer = DatabaseObserver();
  OneDriveRequest oneDriveRequest =
      OneDriveRequest(SharedPreference.instance, ProjectClient(Client()));
  DatabaseRW _databaseRW = DatabaseRW(BasicDatabase.instance);
  BasicSqlHelper helper = BasicSqlHelper(BasicDatabase.instance);

  Function onUploadSuccess;
  Function onUploadError;

  BaseBloc() {
    observer.onUpdateCallback = () {
      List<int> xmlBytes = _databaseRW.mapToXmlString(dataRepository);
      oneDriveRequest.uploadFile2OneDrive(
          onUploadSuccess, onUploadError, xmlBytes);
    };
    helper.attachToObserver(observer);
  }

  static Map<XmlTag, List<BaseModel>> _dataRepository = {
    XmlTag.annualPlan: List<AnnualPlanModel>(),
    XmlTag.todo: List<ToDoModel>(),
    XmlTag.personalSchedule: List<PersonalScheduleModel>(),
  };

  Map<XmlTag, List<BaseModel>> get dataRepository {
    var tempMap = Map<XmlTag, List<BaseModel>>();
    tempMap.addAll(_dataRepository);
    return tempMap;
  }

  void updateData(XmlTag tag, List<BaseModel> list) {
    _dataRepository[tag] = list;
  }
}

Type _typeOf<T>() => T;

class BlocProvider<T extends BaseBloc> extends StatefulWidget {
  BlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final Widget child;
  final T bloc;

  @override
  _BlocProviderState<T> createState() => _BlocProviderState<T>();

  static T of<T extends BaseBloc>(BuildContext context) {
    final type = _typeOf<_BlocProviderInherited<T>>();
    _BlocProviderInherited<T> provider =
        context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;
    return provider?.bloc;
  }
}

class _BlocProviderState<T extends BaseBloc> extends State<BlocProvider<T>> {
  @override
  void dispose() {
    widget.bloc?.depose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new _BlocProviderInherited<T>(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited oldWidget) => false;
}
