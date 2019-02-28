import 'dart:async';

import 'package:flutter/services.dart';
import 'package:project_flutter/scenes/base_bloc.dart';
import 'package:project_flutter/util/shared_preference.dart';
import 'package:rxdart/rxdart.dart';

class SynchronizeBloc extends BaseBloc {
  SharedPreference _preference = SharedPreference();

  static const String LOADING = "synchronize:loading";
  static const String NEED_LOGIN = "synchronize:login";
  static const String HAS_LOGIN = "synchronize:hasLogin";
  static const String NEED_LOGIN_AGAIN = "synchronize:loginAgain";
  static const String LOGOUT_ERROR = "synchronize:logoutError";
  static const String LOGIN_ERROR = "synchronize:loginError";
  static const String LOGOUT_SUCCESS = "synchronize:loginSuccess";
  static const String LOGIN_CANCEL = "synchronize:loginCancel";

  static const String simpleTimeAccount = "simpleTime:Account";
  static const String simpleTimeToken = "simpleTime:Token";
  static const String simpleTimeError = "simpleTime:Error";

  static const _jumpPlugin =
      const MethodChannel('com.jwj.project_flutter/jump');

  var _synchronizeController = BehaviorSubject<String>();

  Observable<String> get synchronizeStream => _synchronizeController.stream;

  StreamSink get synchronizeSink => _synchronizeController.sink;

  var _synchronizeErrorController = BehaviorSubject<String>();

  Observable<String> get errorStream => _synchronizeErrorController.stream;

  @override
  void depose() {
    oneDriveRequest.close();
    _synchronizeController.close();
    _synchronizeErrorController.close();
  }

  void nativeLogin([bool forceRefreshLogin = false]) async {
    String result;
    _synchronizeController.add(LOADING);

    if (forceRefreshLogin) {
      await _preference.putData(SharedPreference.FIRST_LAUNCH, "true");
    }

    if (_preference.getData(SharedPreference.FIRST_LAUNCH) == "true") {
      result = await _jumpPlugin.invokeMethod('connect');
    } else {
      result = await _jumpPlugin.invokeMethod('connectSlient');
    }
    print(result);

    if (result.contains(simpleTimeError)) {
      _handleErrorResult(result);
    } else {
      _handleSuccessResult(result);
    }
  }

  void _handleErrorResult(String result) {
    var error = result.replaceAll(simpleTimeError, "");
    switch (error) {
      case "failed inside":
      case "failed in config":
      case "retry":
        _synchronizeErrorController.add(LOGIN_ERROR);
        break;
      case "cancel":
        _synchronizeErrorController.add(LOGIN_CANCEL);
        _synchronizeController.add(NEED_LOGIN);
        break;
    }
  }

  void _handleSuccessResult(String result) {
    var account = result.split(simpleTimeAccount)[1];
    var token = result.split(simpleTimeToken)[1];
    if (account == "" || token == "") {
      for (var i in result.split(simpleTimeAccount)) {
        print(i + '\n');
      }
      for (var ii in result.split(simpleTimeToken)) {
        print(ii + '\n');
      }
      throw "弄错了啊！！！";
    }

    if (_preference.getData(SharedPreference.FIRST_LAUNCH) == "true") {
      _preference.putData(SharedPreference.FIRST_LAUNCH, "false");
    }
    _preference.putData(SharedPreference.ACCOUNT, account);
    _preference.putData(SharedPreference.TOKEN_KEY, token);
    _synchronizeController.add(HAS_LOGIN);
  }

  void nativeLogout() async {
    String result = await _jumpPlugin.invokeMethod('logout');

    if (result.contains("success")) {
      _preference.putData(SharedPreference.ACCOUNT, "");
      _preference.putData(SharedPreference.TOKEN_KEY, "");
      _synchronizeErrorController.add(LOGOUT_SUCCESS);
      _synchronizeController.add(NEED_LOGIN);
    } else {
      _synchronizeController.add(LOGOUT_ERROR);
    }
  }

  String getAccount() {
    return _preference.getData(SharedPreference.ACCOUNT);
  }

  void createFile() {
    oneDriveRequest.createFile2OneDrive();
  }

  void uploadData(Function onUploadSuccess, Function onUploadError) {
    oneDriveRequest.uploadFile2OneDrive(onUploadSuccess, onUploadError, [1]);
  }

  void downloadData(Function onDownloadSuccess, Function onDownloadError) {
    oneDriveRequest.downloadDataFromOneDrive(
        onDownloadSuccess, onDownloadError);
  }
}

enum NativeResult { insideFailed, configFailed, retry, success }
