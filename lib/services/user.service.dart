import 'package:caruviuserapp/config/static.dart';
import 'package:caruviuserapp/model/Profile.dart';
import 'package:caruviuserapp/services/sharedPrefs.service.dart';
import 'package:http/http.dart' as http;

Future getMyProfile() async {
  var token = await LocalStoredData().getStringKey('token');
  var url = Uri.parse(serverADD + '/users/me');
  return http.get(
    url,
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    },
  );
}

Future updateMyProfile(Profile userProfile, String cityId) async {
  var token = await LocalStoredData().getStringKey('token');
  var url = Uri.parse(serverADD + '/users/me');
  return http.patch(url, headers: {
    'Authorization': 'Bearer $token'
  }, body: {
    "fullName": userProfile.fullName,
    "profilePicture": userProfile.profilePicture,
    "emailAddress": userProfile.emailAddress,
    "phoneNumber": userProfile.phoneNumber,
    "businessName": userProfile.businessName,
    "city": cityId,
    "address": userProfile.address,
  });
}

Future updateMyToken(String Apptoken) async {
  var token = await LocalStoredData().getStringKey('token');
  var userId = await LocalStoredData().getIntKey('id');
  var url = Uri.parse(serverADD + '/users/$userId/membertoken');
  return http.patch(url, headers: {
    'Authorization': 'Bearer $token',
  }, body: {
    "token": Apptoken,
  });
}
