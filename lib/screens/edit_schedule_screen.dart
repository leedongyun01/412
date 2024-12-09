import 'package:flutter/material.dart';

class EditScheduleScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, String> event;

  EditScheduleScreen({required this.selectedDate, required this.event});

  @override
  _EditScheduleScreenState createState() => _EditScheduleScreenState();
}

class _EditScheduleScreenState extends State<EditScheduleScreen> {
  late TextEditingController _contentController;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.event['content']);
    _startDate = widget.selectedDate;
    _endDate = DateTime.parse(widget.event['endDate']!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('일정 수정')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '일정 내용'),
            ),
            ListTile(
              title: Text("시작일: ${_startDate.toLocal()}"),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _startDate)
                  setState(() {
                    _startDate = pickedDate;
                  });
              },
            ),
            ListTile(
              title: Text("종료일: ${_endDate.toLocal()}"),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _endDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != _endDate)
                  setState(() {
                    _endDate = pickedDate;
                  });
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'content': _contentController.text,
                  'startDate': _startDate,
                  'endDate': _endDate,
                });
              },
              child: Text('수정 내용 저장'),
            ),
          ],
        ),
      ),
    );
  }
}
