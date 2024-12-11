import 'package:flutter/material.dart';

class SharedCalendarScreen extends StatelessWidget {
  const SharedCalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공유 캘린더'),
      ),
      body: const Center(
        child: Text('공유 캘린더 화면'),
      ),
    );
  }
}
