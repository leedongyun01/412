import 'package:flutter/material.dart';
import 'shared_calendar_screen.dart';

class SharedCalendarListScreen extends StatelessWidget {
  const SharedCalendarListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공유 캘린더 목록'),
      ),
      body: ListView(
        children: List.generate(10, (index) {
          return ListTile(
            title: Text('공유 캘린더 $index'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SharedCalendarScreen(),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
