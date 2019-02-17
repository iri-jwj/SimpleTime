import 'dart:convert';

import 'package:http/http.dart';
import 'package:project_flutter/util/shared_preference.dart';

class OneDriveRequest {
  final SharedPreference _sharedPreference;
  String _token;
  final ProjectClient _client;

  static const String BASE_URL =
      "https://graph.microsoft.com/v1.0/me/drive/special/approot";

  static const String PARENT_PATH = "/SimpleTime";

  static const String FILE_NAME = "SimpleTime.xml";

  final bool isNewIsolate;

  OneDriveRequest(this._sharedPreference, this._client, this.isNewIsolate) {
    _token = _sharedPreference.getData(SharedPreference.TOKEN_KEY);
    _client.setBaseUrl = BASE_URL;
    _client.setDefaultHeaders = <String, String>{
      "Authorization": "bearer $_token",
    };

    if (isNewIsolate == false) {
      //todo 关闭另一个Isolate
    }
  }

  void createFile2OneDrive() {
    var jsonString = json.encode(<String, Object>{
      "name": "SimpleTime",
      "folder": {},
      "@microsoft.graph.conflictBehavior": "rename"
    });
    _client
        .post("/children",
            body: jsonString,
            headers: <String, String>{
              "Content-Type": "application/json; charset=utf-8"
            },
            encoding: Encoding.getByName("utf-8"))
        .then((response) {
      print(response.statusCode);
      print(response.body);
    });
  }

  void uploadFile2OneDrive(Function onUploadSuccess, Function onUploadError,
      List<int> content) async {
    var url = ":$PARENT_PATH/$FILE_NAME:/content";

    _client
        .put(url, body: content, encoding: Encoding.getByName("utf-8"))
        .then((Response response) {
      print(response.statusCode);
      print(response.body);
    });
  }

  void downloadDataFromOneDrive(
      Function onDownloadSuccess, Function onDownloadError) {
    var path = ":$PARENT_PATH/$FILE_NAME:/content";

    _client.get(path).then((response) {
      if (response.statusCode == 200) {
        String result = response.body;
        onDownloadSuccess(result);
      } else {
        onDownloadError();
      }
    });
  }

  void close(){
    _client.close();
  }
}

class ProjectClient extends BaseClient {
  final Client _client;
  String _baseUrl;
  Map<String, String> _defaultHeaders;

  ProjectClient(this._client);

  set setBaseUrl(String baseUrl) => _baseUrl = baseUrl;

  set setDefaultHeaders(Map<String, String> headers) =>
      _defaultHeaders = headers;

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    request.headers.addAll(_defaultHeaders);
    return _client.send(request);
  }

  @override
  Future<Response> patch(path,
      {Map<String, String> headers, body, Encoding encoding}) {
    if (_baseUrl != null) {
      return super.patch("$_baseUrl$path",
          headers: headers, body: body, encoding: encoding);
    } else {
      return super
          .patch(path, headers: headers, body: body, encoding: encoding);
    }
  }

  @override
  Future<Response> put(path,
      {Map<String, String> headers, body, Encoding encoding}) {
    if (_baseUrl != null) {
      print("$_baseUrl$path");
      return super.put("$_baseUrl$path",
          headers: headers, body: body, encoding: encoding);
    } else {
      return super.put(path, headers: headers, body: body, encoding: encoding);
    }
  }

  @override
  Future<Response> post(path,
      {Map<String, String> headers, body, Encoding encoding}) {
    if (_baseUrl != null) {
      return super.post("$_baseUrl$path",
          headers: headers, body: body, encoding: encoding);
    } else {
      return super.post(path, headers: headers, body: body, encoding: encoding);
    }
  }

  @override
  Future<Response> get(path, {Map<String, String> headers}) {
    if (_baseUrl != null) {
      return super.get("$_baseUrl$path", headers: headers);
    } else {
      return super.patch(path, headers: headers);
    }
  }

  @override
  void close() {
    _client.close();
    super.close();
  }
}
