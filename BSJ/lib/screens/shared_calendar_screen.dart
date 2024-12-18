import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'add_shared_schedule_screen.dart';  // 일정 추가 화면 import

class SharedCalendarScreen extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String? sharedCalendarName;

  const SharedCalendarScreen({
    Key? key,
    this.startDate,
    this.endDate,
    this.sharedCalendarName,
  }) : super(key: key);

  @override
  State<SharedCalendarScreen> createState() => _SharedCalendarScreenState();
}

class _SharedCalendarScreenState extends State<SharedCalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  DateTime? _selectedDay;  // 선택된 날짜

  @override
  void initState() {
    super.initState();
    _firstDay = widget.startDate ?? DateTime.now();
    _lastDay = widget.endDate ?? DateTime.now().add(const Duration(days: 7));
    _focusedDay = _firstDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sharedCalendarName ?? '공유 캘린더'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '참여자 목록',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '아무도 없음',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Expanded(
            child: TableCalendar(
              focusedDay: _focusedDay,
              firstDay: _firstDay,
              lastDay: _lastDay,
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                // 선택된 날짜가 오늘 날짜랑 같으면 true를 반환
                return _selectedDay != null && isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;  // 선택된 날짜 저장
                  _focusedDay = focusedDay;  // 포커스된 날짜 업데이트
                });
              },
              headerVisible: false,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                // 선택된 날짜의 스타일을 강하게 지정
                selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // 초대 링크 생성 기능 추가 예정
              },
              child: const Text('초대 링크 생성'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 일정 추가 화면으로 이동
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSharedScheduleScreen(
                calendarName: widget.sharedCalendarName ?? '기본 캘린더 이름',
                startDate: widget.startDate,
                endDate: widget.endDate,
              ),
            ),
          );

          // 일정을 추가하고 돌아왔을 때 처리할 로직
          if (result != null) {
            // 여기에 일정을 추가한 후 처리할 코드 작성
            print('추가된 일정: $result');
          }
        },
        child: const Icon(Icons.add),
        tooltip: '일정 추가',
      ),
    );
  }
}