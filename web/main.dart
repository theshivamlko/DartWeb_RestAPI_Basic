import 'dart:convert' as convert;
import 'dart:html';

import 'package:http/http.dart' as http;

void main() {
  querySelector('#output').text = 'Your Dart app is running.';

  querySelector('#addBtn').onClick.capture((event) async {
    InputElement name = querySelector('#name');
    InputElement city = querySelector('#city');

    Map<String, dynamic> params = Map();
    params['name'] = name.value;
    params['city'] = city.value;

    var url = "http://127.0.0.1:4041/addUser";

    Map<String, String> headers = new Map();

    headers['Content-Type'] = 'application/x-www-form-urlencoded';

    await http.post(url, headers: headers, body: params).then((response) {
      Map data = convert.jsonDecode(response.body);

      if (data['status']) {
        window.alert(data['message']);
      } else {
        window.alert(data['message']);
      }
    }).catchError((e) {
      print(e.toString());
    });
  });

  querySelector('#getBtn').onClick.capture((event) async {
    OListElement olList = querySelector('#userList');

    var url = "http://127.0.0.1:4041/getUsers";

    Map<String, String> headers = new Map();

    headers['Content-Type'] = 'application/x-www-form-urlencoded';

    await http
        .get(
      url,
      headers: headers,
    )
        .then((response) {
      Map data = convert.jsonDecode(response.body);

      if (data['status']) {
        List list = data['data'];

        olList.text='';
        list.forEach((d) {
          LIElement liElement = new LIElement();

          liElement.appendText(d['name'] + " " + d['city']);
          olList.append(liElement);
        });
      } else {
        window.alert(data['message']);
      }
    }).catchError((e) {
      print(e.toString());
    });
  });
}
