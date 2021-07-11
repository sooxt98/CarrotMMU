import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../main.dart';

final endpoint = "https://carrot.sooxt98.space";
// final endpoint = "http://192.168.1.101:3000";
final box = GetStorage();
var token = Uri.encodeComponent(box.read('token'));

class API {
  static bool isSessionExpired = false;
  static bool isLogin() {
    if (box.read('token') != null) return true;
    return false;
  }

  static logout() {
    // isSessionExpired = true;
    box.remove('token');
    box.remove('uid');
  }

  static login(uid, pwd) async {
    try {
      Response response = await Dio().get("$endpoint/login?uid=$uid&pwd=$pwd");
      if (response.data['token'] != "") {
        token = Uri.encodeComponent(response.data['token']);
        box.write("token", response.data['token']);
        box.write("uid", uid);
        API.isSessionExpired = false;
        MyApp.observer.analytics.setUserId(uid);
        return true;
      }
    } catch (e) {
      // print(e);
    }

    return false;
  }

  static Future<List> attendance() async {
    try {
      Response response = await Dio().get("$endpoint/attendance?token=$token");
      // print(response);
      print("$endpoint/attendance?token=$token");
      print(json.decode('{"success":false}').runtimeType);
      // print(json.decode('{"success":false}')['success'].toString() + ' aaa');

      var res = json.decode(response.data);
      print(res.runtimeType);
      if (!(res is List) && res['success'] == false) {
        print('gg');
        isSessionExpired = true;
        return logout();
      }

      return res;
    } catch (e) {
      print(e);
    }
    return [];
  }

  static Future<List> attendanceDetail(classIndex) async {
    try {
      Response response =
          await Dio().get("$endpoint/attendance/$classIndex?token=$token");
      print("$endpoint/attendance/$classIndex?token=$token");
      print(response.data);
      return json.decode(response.data) ?? [];
    } catch (e) {
      // print(e);
    }
    return [];
  }

  static Future<Map> attendanceCheckIn(timetableId) async {
    try {
      Response response = await Dio()
          .get("$endpoint/attendance/checkin/$timetableId?token=$token");
      // print(response.data);
      return response.data;
    } catch (e) {
      // print(e);
    }
    return {};
  }

  static Future<List> announcement() async {
    try {
      Response response = await Dio().get("$endpoint/bulletin?token=$token");
      // print(response);
      return json.decode(response.data);
    } catch (e) {
      // print(e);
    }
    return [];
  }

  static Future<List> timetable() async {
    try {
      Response response = await Dio().get("$endpoint/timetable?token=$token");
      // print(response);
      return json.decode(response.data);
    } catch (e) {
      // print(e);
    }
    return [];
  }

  static Future<Map> profile() async {
    try {
      Response response = await Dio().get("$endpoint/profile?token=$token");
      // print(response);
      return json.decode(response.data);
    } catch (e) {
      // print(e);
    }
    return {};
  }

  static Future<List> pastyear(String code) async {
    try {
      Response response =
          await Dio().get("$endpoint/pastyear?code=${code}&token=$token");
      // print(response);
      return json.decode(response.data) ?? [];
    } catch (e) {
      // print(e);
    }
    return [];
  }

  static String pastyearView(String id) {
    return "$endpoint/pastyearview?id=${id}&token=$token";
  }
}
