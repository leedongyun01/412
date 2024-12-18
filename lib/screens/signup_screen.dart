import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedGender = "1";
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleSignup() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String name = _nameController.text.trim();
    final String nickname = _nicknameController.text.trim();
    final String password = _passwordController.text.trim();
    final String age = _ageController.text.trim();
    final String phone = _phoneController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('http://121.174.224.9:61314/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': name,
          'password': password,
          'userNickname': nickname,
          'userAge': age,
          'userSex': _selectedGender,
          'userPhone': phone,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = '입력 정보 확인';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '오류 발생';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: '닉네임'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: '나이'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: const [
                DropdownMenuItem(value: "1", child: Text("남성")),
                DropdownMenuItem(value: "2", child: Text("여성")),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value ?? "1";
                });
              },
              decoration: const InputDecoration(labelText: '성별'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: '전화번호'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _handleSignup,
              child: const Text('가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}