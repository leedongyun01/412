import 'package:flutter/material.dart';

class SharedCalendarScreen extends StatelessWidget {
  final String calendarName;

  SharedCalendarScreen({required this.calendarName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(calendarName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('일정 1'),
                    subtitle: Text('2024-12-10 10:00 ~ 12:00'),
                    onTap: () {
                    },
                  ),
                  ListTile(
                    title: Text('일정 2'),
                    subtitle: Text('2024-12-12 14:00 ~ 16:00'),
                    onTap: () {
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEventScreen()),
                );
              },
              child: Text('일정 추가'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('초대 링크'),
                    content: Text('https://example.com/invite'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('닫기'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('초대 링크'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController eventTitleController = TextEditingController();
    DateTime _selectedDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: Text('일정 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: eventTitleController,
              decoration: InputDecoration(labelText: '일정 내용'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null && pickedDate != _selectedDate) {
                  _selectedDate = pickedDate;
                }
              },
              child: Text('날짜 선택'),
            ),
            Text('날짜: ${_selectedDate.toLocal()}'.split(' ')[0]),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('일정 저장 완료')),
                );
                Navigator.pop(context);
              },
              child: Text('일정 저장'),
            ),
          ],
        ),
      ),
    );
  }
}