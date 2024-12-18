import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ___________________________________________
  final String _baseUrl = 'http://~~~';
  // ___________________________________________

  Future<bool> login(String userNickname, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userNickname': userNickname,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('로그인 오류: $e');
      return false;
    }
  }
}
