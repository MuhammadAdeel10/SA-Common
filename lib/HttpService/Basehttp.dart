import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppExceptions.dart';

class BaseClient {
  static const int TIME_OUT_DURATION = 1;

  //GET
  Future<dynamic> get(String api) async {
    String token = "";
    if (api != ApiEndPoint.logIn) {
      var pref = await SharedPreferences.getInstance();
      token = pref.get(LocalStorageKey.token) as String;
    }
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "X-APP-Id": "68414BC4-41D6-45E0-A71F-048D2DBD4CD0",
      "Authorization": "Bearer " + token
    };
    var uri = Uri.parse(ApiEndPoint.baseUrl + api);
    try {
      var response = await http
          .get(uri, headers: userHeader)
          .timeout(Duration(minutes: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      Logger.ErrorLog('data: $uri + ${uri.toString()}');
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      Logger.ErrorLog('data: $uri + ${uri.toString()}');
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //POST
  Future<dynamic> post(String api, dynamic userBody) async {
    String token = "";
    if (api != ApiEndPoint.logIn) {
      var pref = await SharedPreferences.getInstance();
      token = pref.get(LocalStorageKey.token) as String;
    }
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "X-APP-Id": "68414BC4-41D6-45E0-A71F-048D2DBD4CD0",
      "Authorization": "Bearer " + token
    };

    var uri = Uri.parse(ApiEndPoint.baseUrl + api);
    var jsonEncode = json.encode(userBody);
    try {
      var response = await http
          .post(uri, body: jsonEncode, headers: userHeader)
          .timeout(Duration(minutes: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (Ex) {
      Logger.ErrorLog('data: $uri + $Ex');
    }
  }

  Future<dynamic> put(String api, dynamic userBody) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.get(LocalStorageKey.token) as String;

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "X-APP-Id": "68414BC4-41D6-45E0-A71F-048D2DBD4CD0",
      "Authorization": "Bearer " + token
    };

    var uri = Uri.parse(ApiEndPoint.baseUrl + api);
    var jsonEncode = json.encode(userBody);

    try {
      var response = await http
          .put(uri, body: jsonEncode, headers: userHeader)
          .timeout(Duration(minutes: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (Ex) {
      Logger.ErrorLog('data: $uri + $Ex');
    }
  }

  Future<dynamic> postFile(String url, List<PlatformFile> selectedFiles) async {
    var uri = Uri.parse(ApiEndPoint.baseUrl + url);
    var pref = await SharedPreferences.getInstance();
    String token = pref.get(LocalStorageKey.token) as String;

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "X-APP-Id": "68414BC4-41D6-45E0-A71F-048D2DBD4CD0",
      "Authorization": "Bearer " + token
    };
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(userHeader);
    for (var filePath in selectedFiles) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'files',
          filePath.path!,
        ),
      );
    }
    try {
      var response = await request.send();
      var result = await http.Response.fromStream(response);

      return _processResponse(result);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (Ex) {
      Logger.ErrorLog('data: $uri + $Ex');
    }
    // Send the request and await the response:
  }

  Future<dynamic> delete(String api) async {
    var pref = await SharedPreferences.getInstance();
    String token = pref.get(LocalStorageKey.token) as String;

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "X-APP-Id": "68414BC4-41D6-45E0-A71F-048D2DBD4CD0",
      "Authorization": "Bearer " + token
    };

    var uri = Uri.parse(ApiEndPoint.baseUrl + api);
    try {
      var response = await http
          .delete(uri, headers: userHeader)
          .timeout(Duration(minutes: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    } catch (Ex) {
      Logger.ErrorLog('data: $uri + $Ex');
    }
  }

  dynamic _processResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        Logger.InfoLog('Server statusCode: ${response.statusCode} ' +
            'Url: ${response.request}');
        return response;

      case 400:
        Logger.ErrorLog("${response.request} " +
            'Server Exception with statusCode: ${response.statusCode}' +
            " data:" +
            response.body);
        var uri = ApiEndPoint.baseUrl + ApiEndPoint.logIn;
        dynamic loginError;
        if (response.request?.url.toString() == uri) {
          var loginJson = json.decode(response.body);
          loginError = loginJson["errors"][0];
        }
        var jsonDecode = json.decode(utf8.decode(response.bodyBytes));
        throw BadRequestException(
          loginError != null ? loginError : jsonDecode,
          response.request!.url.toString(),
        );
      case 401:
        Logger.ErrorLog("${response.request} " +
            'Server Exception with statusCode: ${response.statusCode}' +
            " data:" +
            response.body);
        throw UnAuthorizedException(
            response.reasonPhrase, response.request!.url.toString());

      case 403:
        Logger.ErrorLog("${response.request} " +
            'Server Exception with statusCode: ${response.statusCode}' +
            " data:" +
            response.body);
        throw ForbiddenException(
            response.reasonPhrase, response.request!.url.toString());
      case 422:
        Logger.ErrorLog("${response.request} " +
            'Server Exception with statusCode: ${response.statusCode}' +
            " data:" +
            response.body);
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 415:
        Logger.ErrorLog("${response.request} " +
            'Server Exception with statusCode: ${response.statusCode}' +
            " data:" +
            response.body);
        throw UnsupportedError(
            'UnSupported Media type : ${response.statusCode}');
      case 423:
        {
          Logger.ErrorLog("${response.request} " +
              'Server Exception statusCode: ${response.statusCode}' +
              " :data:" +
              response.body);
          throw LockException("You are already logged in another session",
              response.request!.url.toString());
        }
      case 404:
        Logger.ErrorLog("${response.request} " +
            'Server Exception statusCode: ${response.statusCode}' +
            " :data:" +
            "${response.reasonPhrase}");
        throw BadRequestException(
            response.body.isEmpty ? response.reasonPhrase : response.body,
            response.request!.url.toString());

      case 417:
        {
          Logger.ErrorLog("${response.request} " +
              'Server Exception statusCode: ${response.statusCode}' +
              " :data:" +
              "${response.reasonPhrase}");
          throw ExpectationFailed(
              response.body.isEmpty ? response.reasonPhrase : response.body,
              response.request!.url.toString());
        }
      case 500:
      default:
        Logger.ErrorLog("${response.request} " +
            'Server Exception statusCode: ${response.statusCode},' +
            " data:" +
            response.body);
        throw FetchDataException();
    }
  }
}
