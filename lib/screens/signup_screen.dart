import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

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
              decoration: const InputDecoration(labelText: '이름'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: '닉네임'),
            ),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            TextField(
              decoration: const InputDecoration(labelText: '나이'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: const InputDecoration(labelText: '전화번호'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('가입하기'),
            ),
          ],
        ),
      ),
    );
  }
}
