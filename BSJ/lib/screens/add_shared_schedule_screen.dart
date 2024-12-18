import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSharedScheduleScreen extends StatefulWidget {
  final String calendarName;
  final DateTime? startDate;  // 공유 캘린더의 시작일
  final DateTime? endDate;    // 공유 캘린더의 종료일

  const AddSharedScheduleScreen({
    Key? key,
    required this.calendarName,
    this.startDate,
    this.endDate,
  }) : super(key: key);

  @override
  _AddSharedScheduleScreenState createState() => _AddSharedScheduleScreenState();
}

class _AddSharedScheduleScreenState extends State<AddSharedScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _contentController;
  bool _isButtonDisabled = true;  // 버튼 비활성화 상태

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, DateTime? startDate, DateTime? endDate) async {
    // 달력 표시 시 초기 날짜, 시작 날짜, 종료 날짜를 설정
    DateTime initialDate = startDate ?? DateTime.now();
    DateTime firstDate = startDate ?? DateTime(2000);
    DateTime lastDate = endDate ?? DateTime(2100);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,  // 초기 날짜는 startDate로 설정
      firstDate: firstDate,      // 첫 번째 선택 가능한 날짜는 startDate 이후
      lastDate: lastDate,        // 마지막 날짜는 endDate로 설정
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
        // 선택한 날짜가 범위 내에 있으면 버튼 활성화
        if (picked.isAfter(startDate!.subtract(Duration(days: 1))) && picked.isBefore(endDate!.add(Duration(days: 1)))) {
          _isButtonDisabled = false;
        } else {
          _isButtonDisabled = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일정 추가 - ${widget.calendarName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _startDateController,
                decoration: const InputDecoration(
                  labelText: '시작일',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context, _startDateController, widget.startDate, widget.endDate),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '시작일을 입력하세요.';
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
                onTap: () => _selectDate(context, _endDateController, widget.startDate, widget.endDate),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '종료일을 입력하세요.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: '내용'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonDisabled ? null : () {
                  if (_formKey.currentState!.validate()) {
                    final updatedSchedule = {
                      'startDate': _startDateController.text,
                      'endDate': _endDateController.text,
                      'content': _contentController.text,
                    };

                    Navigator.pop(context, updatedSchedule); // 일정 추가 후 화면 돌아가기
                  }
                },
                child: const Text('일정 추가'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}