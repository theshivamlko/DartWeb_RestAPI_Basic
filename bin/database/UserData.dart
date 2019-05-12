import 'dart:async';
import 'dart:io';

import 'package:mysql1/mysql1.dart';

import '../database/Connection.dart';

class UserData {
  HttpRequest request;
  Connection connection;

  UserData(this.request) {
    connection = Connection();
  }

  Future<Map<dynamic, dynamic>> addNewUser(String name, String city) async {
    Map<dynamic, dynamic> data = Map();
    data["name"] = name;
    data["city"] = city;

    await connection.connect();

    var result = await connection.conn
        .query('insert into users (name, city) values (?, ?)', [name, city]);

    return data;
  }

  Future<Results> getAllUser() async {
    await connection.connect();

    Results result = await connection.conn
        .query('''select * from users''');

      return result;
  }
}
