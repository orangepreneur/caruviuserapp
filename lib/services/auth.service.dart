import 'dart:convert';

import 'package:caruviuserapp/config/static.dart';
import 'package:caruviuserapp/services/sharedPrefs.service.dart';
import 'package:http/http.dart' as http;

Future authenticateuser({String phoneNumber = "", String password = ""}) async {
  if (phoneNumber == '') print('Enter Valid Details');
  var url = Uri.parse(serverADD + '/login');
  var response = await http
      .post(url, body: {'phoneNumber': phoneNumber, 'password': password});
  if (response.statusCode == 201) saveDetailsLocally(response);
  if (response.statusCode == 201) return true;
  return false;
}

saveDetailsLocally(dynamic data) {
  var decodedResponse = jsonDecode(utf8.decode(data.bodyBytes)) as Map;
  if (decodedResponse['access_token'] != '' &&
      decodedResponse['access_token'] != null) {
    LocalStoredData().setStringKey('token', decodedResponse['access_token']);
    LocalStoredData().setBoolKey('isloggedin', true);
  }
}

logoutUser() {
  LocalStoredData().deleteKey('token');
  LocalStoredData().deleteKey('isloggedin');
}