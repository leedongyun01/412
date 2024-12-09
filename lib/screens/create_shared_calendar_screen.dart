import 'package:flutter/material.dart';

class CreateSharedCalendarScreen extends StatefulWidget {
  @override
  _CreateSharedCalendarScreenState createState() =>
      _CreateSharedCalendarScreenState();
}

class _CreateSharedCalendarScreenState extends State<CreateSharedCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController _calendarNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공유 캘린더 생성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _calendarNameController,
              decoration: InputDecoration(labelText: '캘린더 이름:'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectDate,
              child: Text('날짜 선택'),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createCalendar,
              child: Text('캘린더 생성'),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate)
      setState(() {
        _selectedDate = pickedDate;
      });
  }

  _createCalendar() {
    if (_calendarNameController.text.isNotEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('공유 캘린더 생성 완료')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('123')),
      );
    }
  }
}