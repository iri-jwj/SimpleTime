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

  static const String simpleTimeAccount = "simpleTime:Account";
  static const String simpleTimeToken = "simpleTime:Token";
  static const String simpleTimeError = "simpleTime:Error";

  static const _jumpPlugin =
      const MethodChannel('com.jwj.project_flutter/jump');

  var _synchronizeController = BehaviorSubject<String>();

  Observable<String> get synchronizeStream => _synchronizeController.stream;

  StreamSink get synchronizeSink => _synchronizeController.sink;

  @override
  void depose() {
    oneDriveRequest.close();
    _synchronizeController.close();
  }

  void nativeLogin() async {
    String result;
    _synchronizeController.add(LOADING);
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
      _synchronizeController.add(LOGIN_ERROR);
      break;
    }
  }

  void _handleSuccessResult(String result) {
    var account = result.split(simpleTimeAccount)[0];
    var token = result.split(simpleTimeToken).last;
    if (account == "" || token == "") {
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

    if(result.contains("success")){
      _synchronizeController.add(NEED_LOGIN);
      _preference.putData(SharedPreference.ACCOUNT, "");
      _preference.putData(SharedPreference.TOKEN_KEY, "");
    }else{
      _synchronizeController.add(NEED_LOGIN);
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
