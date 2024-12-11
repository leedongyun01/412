import 'package:flutter/material.dart';

class FindAccountScreen extends StatelessWidget {
  const FindAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이디/비밀번호 찾기'),
      ),
      body: Center(
        child: const Text(
          '아이디/비밀번호를 찾는 기능은 아직 구현되지 않았습니다.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
