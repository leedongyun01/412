import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'signup_screen.dart';
import 'find_account_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleLogin() async {//상태 초기화
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String nickname = _nicknameController.text.trim();//앞뒤공백제거
    final String password = _passwordController.text.trim();

    try {
      final response = await http.post(//서버에 데이터 전송
        // ___________________________________________________
        Uri.parse('http://~~~'),//실제API로 대체될 예정
        // ___________________________________________________
        headers: {'Content-Type': 'application/json'},//JSON데이터 형심ㄱ임을 명시
        body: jsonEncode({//입력값을 JSON 형식 변환하여 body에 포함
          'userNickname': nickname,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {//성공 시, 다른 화면으로 이동하는 모습
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        setState(() {
          _errorMessage = '로그인 실패. 닉네임/비밀번호 확인';
        });
      }
    } catch (e) {//네트워크 문제 또는 기타 예외 발생 시
      setState(() {
        _errorMessage = '오류 발생';
      });
      Navigator.pushReplacement(//개발 위해 임시로 설정
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } finally {//성공 여부 상관 없이 요청 종료 후, 로딩 상태 비활성화
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(//기본적인 화면 레이아웃 구조 제공
      appBar: AppBar(//화면 상단 앱 제목
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: '닉네임'),
            ),//입력란에 라벨(투명글자) 설정
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,//입력 내용 가려짐
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            const SizedBox(height: 20),//자식 위젯 간에 공백 추가
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('로그인'),
            ),
            TextButton(
              onPressed: () {//버튼 누를 때 실행할 함수
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                );
              },
              child: const Text('회원가입'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FindAccountScreen()),
                );
              },
              child: const Text('아이디/비밀번호 찾기'),
            ),
          ],
        ),
      ),
    );
  }
}
