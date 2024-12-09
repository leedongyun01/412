import 'package:flutter/material.dart';
import 'shared_calendar_screen.dart';

class SharedCalendarListScreen extends StatelessWidget {
  final List<String> sharedCalendars = ['업무', '가족'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('공유 캘린더 목록')),
      body: ListView.builder(
        itemCount: sharedCalendars.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(sharedCalendars[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SharedCalendarScreen(
                    calendarName: sharedCalendars[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}