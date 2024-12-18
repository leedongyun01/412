import 'package:flutter/material.dart';
import 'shared_calendar_screen.dart';
import 'add_shared_calendar_screen.dart';

class SharedCalendarListScreen extends StatefulWidget {
  const SharedCalendarListScreen({Key? key}) : super(key: key);

  @override
  State<SharedCalendarListScreen> createState() => _SharedCalendarListScreenState();
}

class _SharedCalendarListScreenState extends State<SharedCalendarListScreen> {
  final List<Map<String, dynamic>> _sharedCalendars = [];  // 캘린더 이름과 날짜를 저장하는 리스트

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공유 캘린더 목록'),
      ),
      body: _sharedCalendars.isEmpty
          ? const Center(
        child: Text(
          '아직 생성된 공유 캘린더가 없습니다.',
          style: TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: _sharedCalendars.length,
        itemBuilder: (context, index) {
          final calendar = _sharedCalendars[index];
          return ListTile(
            title: Text('${calendar['name']} (${calendar['start'].toLocal().toString().split(' ')[0]} ~ ${calendar['end'].toLocal().toString().split(' ')[0]})'),
            onTap: () {
              // 선택된 캘린더 화면으로 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SharedCalendarScreen(
                    startDate: calendar['start'],
                    endDate: calendar['end'],
                    sharedCalendarName: calendar['name'],  // 공유 캘린더 이름 전달
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCalendar = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSharedCalendarScreen(),
            ),
          );

          if (newCalendar != null) {
            setState(() {
              _sharedCalendars.add(newCalendar);  // 새로운 캘린더 추가
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}