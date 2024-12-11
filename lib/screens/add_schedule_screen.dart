import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddScheduleScreen extends StatefulWidget {
  final Map<String, String>? initialData;

  const AddScheduleScreen({Key? key, this.initialData}) : super(key: key);

  @override
  _AddScheduleScreenState createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _startDateController = TextEditingController(
        text: widget.initialData?['startDate'] ?? '');
    _endDateController = TextEditingController(
        text: widget.initialData?['endDate'] ?? '');
    _contentController = TextEditingController(
        text: widget.initialData?['content'] ?? '');
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _contentController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialData != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '일정 수정' : '일정 추가'),
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
                onTap: () => _selectDate(context, _startDateController),
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
                onTap: () => _selectDate(context, _endDateController),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedSchedule = {
                      'startDate': _startDateController.text,
                      'endDate': _endDateController.text,
                      'content': _contentController.text,
                    };

                    Navigator.pop(context, updatedSchedule);
                  }
                },
                child: Text(isEditing ? '일정 수정' : '일정 추가'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
