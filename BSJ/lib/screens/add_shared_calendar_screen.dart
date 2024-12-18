import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AddSharedCalendarScreen extends StatefulWidget {
  const AddSharedCalendarScreen({Key? key}) : super(key: key);

  @override
  State<AddSharedCalendarScreen> createState() => _AddSharedCalendarScreenState();
}

class _AddSharedCalendarScreenState extends State<AddSharedCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;
  TextEditingController _calendarNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('공유 캘린더 생성'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _calendarNameController,
            decoration: const InputDecoration(
              labelText: '캘린더 이름',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return isSameDay(_startDate, day) || isSameDay(_endDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                if (_startDate == null || (_startDate != null && _endDate != null)) {
                  _startDate = selectedDay;
                  _endDate = null;
                } else {
                  if (selectedDay.isAfter(_startDate!)) {
                    _endDate = selectedDay;
                  } else {
                    _startDate = selectedDay;
                    _endDate = null;
                  }
                }
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '공유 범위 설정: ',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  _startDate != null && _endDate != null
                      ? '${_startDate!.toLocal().toString().split(' ')[0]} ~ ${_endDate!.toLocal().toString().split(' ')[0]}'
                      : '날짜 선택 필요',
                  style: const TextStyle(fontSize: 16.0, color: Colors.blue),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: (_startDate != null && _endDate != null && _calendarNameController.text.isNotEmpty)
                  ? () {
                final newCalendar = {
                  'name': _calendarNameController.text,
                  'start': _startDate,
                  'end': _endDate,
                };
                Navigator.pop(context, newCalendar);  // 캘린더 이름과 날짜를 반환
              }
                  : null,
              child: const Text('생성'),
            ),
          ),
        ],
      ),
    );
  }
}