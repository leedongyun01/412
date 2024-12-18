import 'package:flutter/material.dart';
import 'shared_calendar_screen.dart';
import 'add_shared_calendar_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:calendar/models/login_data.dart';
import 'package:calendar/models/shared_calendar.dart';

class SharedCalendarListScreen extends StatefulWidget {
  const SharedCalendarListScreen({Key? key}) : super(key: key);

  @override
  State<SharedCalendarListScreen> createState() => _SharedCalendarListScreenState();
}

class _SharedCalendarListScreenState extends State<SharedCalendarListScreen> {
  List<Map<String, dynamic>> _sharedCalendars = [];

  @override
  void initState() {
    super.initState();
    _loadSharedCalendars();
  }

  Future<void> _loadSharedCalendars() async {
    final userId = LoginData.userId;
    final response = await http.get(
      Uri.parse('http://121.174.224.9:61314/user/$userId/cal-list'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _sharedCalendars = data.map((calendar) {
          return {
            'id': calendar['id'],
            'adminUserId': calendar['adminUserId'],
            'calenderName': calendar['calenderName'],
            'startDate': calendar['startDate'],
            'endDate': calendar['endDate'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load calendars');
    }
  }

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
            title: Text(
              '${calendar['calenderName']} (${calendar['startDate']} ~ ${calendar['endDate']})',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SharedCalendarScreen(
                    startDate: calendar['startDate'],
                    endDate: calendar['endDate'],
                    sharedCalendarName: calendar['calenderName'],
                    sharedCalendarId: calendar['id'].toString(),  // 수정된 부분
                    userNickname: LoginData.userNickname,
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
              builder: (context) => AddSharedCalendarScreen(),
            ),
          );

          if (newCalendar != null) {
            setState(() {
              _sharedCalendars.add(newCalendar);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
