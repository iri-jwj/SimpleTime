import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:project_flutter/scenes/base_bloc.dart';
import 'package:project_flutter/util/onedrive_request.dart';
import 'package:project_flutter/util/shared_preference.dart';

class SynchronizeBloc extends BaseBloc {
  SharedPreference _preference = SharedPreference();
  OneDriveRequest _oneDriveRequest = OneDriveRequest(
      SharedPreference(), ProjectClient(Client()), () {}, () {});

  static const _jumpPlugin =
      const MethodChannel('com.jwj.project_flutter/jump');

  @override
  void depose() {}

  Future<NativeResult> jumpToNative() async {
    String result;
    if (_preference.getData(SharedPreference.FIRST_LAUNCH) == "true") {
      result = await _jumpPlugin.invokeMethod('connect');
      _preference.putData(SharedPreference.FIRST_LAUNCH, "false");
    } else {
      result = await _jumpPlugin.invokeMethod("connectSlient");
    }
    print(result);
    switch (result) {
      case "failed inside":
        return NativeResult.insideFailed;
      case "failed in config":
        return NativeResult.configFailed;
      case "retry":
        return NativeResult.retry;
      default:
        {
          _preference.putData(SharedPreference.TOKEN_KEY, result);
          return NativeResult.success;
        }
    }
  }

  void createFile() {
    _oneDriveRequest.createFile2OneDrive();
  }

  void uploadData(Function onUploadSuccess, Function onUploadError) {
    _oneDriveRequest.uploadFile2OneDrive(onUploadSuccess, onUploadError);
  }

  void downloadData(Function onDownloadSuccess, Function onDownloadError){

  }
}

enum NativeResult { insideFailed, configFailed, retry, success }
