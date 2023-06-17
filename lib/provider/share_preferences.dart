import 'package:http/http.dart' as http;
import 'package:devide_manager/object/TeacherInformationObject.dart';
import 'package:devide_manager/provider/api_Teacher_Information.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<void> saveLoggedInStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  static Future<bool> getLoggedInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> saveCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  static Future<Map<String, String>> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    return {'email': email ?? '', 'password': password ?? ''};
  }

//Kiểm tra người dùng hiện tại
  static Future<TeacherInformationObject?> getCurrentUser() async {
  List<TeacherInformationObject> userList = await TeacherInformationProvider.fetchTeacherInformation(http.Client()); // Thay thế phần này bằng hàm lấy danh sách người dùng từ nguồn dữ liệu của bạn
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? loggedInUsername = prefs.getString('email');
  String? loggedInPassword = prefs.getString('password');

  // Kiểm tra xem có thông tin đăng nhập hay không
  if (loggedInUsername != null && loggedInPassword != null) {
    // Tìm người dùng hiện tại dựa trên thông tin đăng nhập
    TeacherInformationObject? currentUser = userList.firstWhere(
      (user) => user.userName == loggedInUsername && user.password == loggedInPassword,

    );

    return currentUser;
  }

  return null; // Trả về null nếu không có người dùng hiện tại
}

}
