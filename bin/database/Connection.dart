import 'package:mysql1/mysql1.dart';

class Connection {
  var conn;
  var settings;

  Connection() {
    settings = new ConnectionSettings(
        host: '127.0.0.1', port: 3306, user: 'root', db: 'darttest');
  }

  void connect() async {
    conn = await MySqlConnection.connect(settings);
  }
}
