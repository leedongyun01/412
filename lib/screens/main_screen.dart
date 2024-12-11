import 'package:flutter/material.dart';
import 'my_calendar_screen.dart';
import 'shared_calendar_list_screen.dart';
import 'add_shared_calendar_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메인 화면'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCalendarScreen()),
                );
              },
              child: const Text('내 캘린더'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SharedCalendarListScreen()),
                );
              },
              child: const Text('공유 캘린더 목록'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddSharedCalendarScreen()),
                );
              },
              child: const Text('공유 캘린더 생성'),
            ),
          ],
        ),
      ),
    );
  }
}
