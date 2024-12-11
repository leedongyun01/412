import 'package:flutter/material.dart';

class AddSharedCalendarScreen extends StatelessWidget {
  const AddSharedCalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공유 캘린더 생성'),
      ),
      body: const Center(
        child: Text('공유 캘린더 생성 화면'),
      ),
    );
  }
}
