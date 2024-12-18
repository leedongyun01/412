import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:calendar/services/login_data.dart';

class AddSharedCalendarScreen extends StatefulWidget {
  @override
  _AddSharedCalendarScreenState createState() =>
      _AddSharedCalendarScreenState();
}

class _AddSharedCalendarScreenState extends State<AddSharedCalendarScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _calendarNameController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _calendarNameController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
  }

  @override
  void dispose() {
    _calendarNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final calendarResponse = await http.post(
          Uri.parse('http://121.174.224.9:61314/calender/create'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'adminUserId': LoginData.userId,
            'calenderName': _calendarNameController.text,
            'startDate': _startDateController.text,
            'endDate': _endDateController.text
          }),
        );
        print('Response status: ${calendarResponse.statusCode}');
        print('Response body: ${calendarResponse.body}');
        print(LoginData.userId);

        if (calendarResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('공유 캘린더 생성 완료')),
          );
          Navigator.pop(context);
        } else {
          throw Exception('생성 실패');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('에러 발생: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공유 캘린더 생성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _calendarNameController,
                decoration: const InputDecoration(labelText: '캘린더 이름'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '캘린더 이름을 입력하세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(
                  labelText: '시작일',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, _startDateController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '시작일을 선택하세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _endDateController,
                decoration: const InputDecoration(
                  labelText: '종료일',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, _endDateController),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '종료일을 선택하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('캘린더 생성'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
