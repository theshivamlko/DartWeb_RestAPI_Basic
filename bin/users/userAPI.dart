import 'dart:convert' as convert;
import 'dart:io';

import 'package:mysql1/mysql1.dart';

import '../database/UserData.dart';

List userList = List();

Map dataResponse = Map();

Future main() async {
  HttpServer server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    4041,
  );

  server.listen((request) {
    request.response.headers.add("Access-Control-Allow-Origin", "*");
    request.response.headers
        .add("Access-Control-Allow-Methods", "POST,GET,DELETE,PUT,OPTIONS");
    request.response.headers.add('Access-Control-Allow-Headers',
        'Origin, X-Requested-With, Content-Type, Accept,application/x-www-form-urlencoded');

    handleRequest(request);
  });
}

void handleRequest(HttpRequest request) {
  dataResponse = {"status": false, "message": "Something gone wrong"};

  String route =
      request.uri.pathSegments.isEmpty ? '/' : request.uri.pathSegments.first;

  try {
    if (request.method == "OPTIONS") {
      setResponse("Wrong method");
      sendResponse(request);
    } else if (request.method == 'GET') {
      switch (route) {
        case 'getUsers':
          getUsers(request);
          break;

        default:
          sendResponse(request);
      }
    }
    if (request.method == 'POST') {
      switch (route) {
        case 'addUser':
          addUser(request);
          break;

        default:
          sendResponse(request);
      }
    }
  } catch (e) {
    print('Exception in handleRequest: $e');
  }
}

Future<Null> addUser(HttpRequest request) async {
  String content = await request.transform(convert.utf8.decoder).join();

  Map queryParams = Uri(query: content).queryParameters;

  UserData userData = UserData(request);
  if (queryParams['name'] != null &&
      queryParams['city'] != null &&
      queryParams['name'].toString().trim().isNotEmpty &&
      queryParams['city'].toString().trim().isNotEmpty) {
    await userData.addNewUser(queryParams['name'], queryParams['city']);
    setResponse("Success", status: true);
    sendResponse(request);
  } else {
    setResponse("Please send all details");
    sendResponse(request);
  }
}

Future<Null> getUsers(HttpRequest request) async {
  UserData userData = UserData(request);
  Results result = await userData.getAllUser();

  List<Map<String, dynamic>> list = List();
  result.forEach((row) {
    print(row.fields);
    Map<String, dynamic> data = Map();
    data['id'] = row.fields['id'];
    data['name'] = row.fields['name'];
    data['city'] = row.fields['city'];
    data['add_date'] = row.fields['add_date'].toString();
    list.add(data);
  });

  setResponse("Success", result: list, status: true);
  sendResponse(request);
}

void sendResponse(HttpRequest request) {
  print(dataResponse);
  request.response
    ..headers.contentType = ContentType.json
    ..writeln(convert.jsonEncode(dataResponse))
    ..close();
}

void setResponse(String message, {dynamic result, bool status}) {
  dataResponse['status'] = status ?? false;
  dataResponse['data'] = result ?? [];
  dataResponse['message'] = message;
}
