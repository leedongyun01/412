import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar/services/local_storage_service.dart';
import 'package:calendar/screens/add_schedule_screen.dart';

class MyCalendarScreen extends StatefulWidget {
  const MyCalendarScreen({Key? key}) : super(key: key);

  @override
  State<MyCalendarScreen> createState() => _MyCalendarScreenState();//MyCalendarScreen에 연결된 상태 클래스(_로 시작)를 생성한다
}

class _MyCalendarScreenState extends State<MyCalendarScreen> {
  DateTime _focusedDay = DateTime.now();//포커스된 날짜
  DateTime? _selectedDay;//선택한 날짜
  List<Map<String, dynamic>> _events = [];//일정 데이터 저장하는 리스트
  final LocalStorageService _storageService = LocalStorageService();//로컬 저장소에서 데이터 읽고 쓰기 위한 서비스 객체

  @override
  void initState() {
    super.initState();
    _loadSchedules();//캘린더 화면 로드될 때 저장된 일정 가져옴
  }

  Future<void> _loadSchedules() async {
    final fetchedEvents = await _storageService.readSchedules();
    setState(() {
      _events = fetchedEvents;//일정 데이터를 읽어와서 리스트에 저장하고, UI 업데이트
    });
  }

  Future<void> _saveSchedules() async {
    await _storageService.saveSchedules(_events);//현재 일정이 저장된 리스트를 로컬 저장소에 저장
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      DateTime startDate = DateTime.parse(event['startDate']);
      DateTime endDate = DateTime.parse(event['endDate']);
      // 선택된 날짜가 시작일과 종료일 사이에 있는 이벤트만 필터링
      return day.isAfter(startDate.subtract(Duration(days: 1))) &&
          day.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  // 일정 추가 버튼 클릭 시 화면 이동
  void _addEvent(DateTime startDate, DateTime endDate, String eventContent) async {
    List<DateTime> eventDates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) || isSameDay(currentDate, endDate)) {
      eventDates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    for (var date in eventDates) {
      final newEvent = {
        'schedule_id': DateTime.now().toIso8601String(),
        'startDate': date.toIso8601String(),
        'endDate': date.toIso8601String(),
        'content': eventContent,
      };

      setState(() {
        _events.add(newEvent);
      });
    }
    await _saveSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 캘린더'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
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
          const SizedBox(height: 8.0),
          Expanded(
            child: _selectedDay == null || _getEventsForDay(_selectedDay!).isEmpty
                ? const Center(
              child: Text('선택한 날짜에 일정이 없습니다.'),
            )
                : ListView(
              children: _getEventsForDay(_selectedDay!).map((eventData) {
                return ListTile(
                  title: Text(eventData['content']),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => _buildBottomSheet(eventData),
                    );
                  },
                );
              }).toList(),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newSchedule = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScheduleScreen()),
          );

          if (newSchedule != null) {
            setState(() {
              _events.add(newSchedule);
            });
            await _saveSchedules();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBottomSheet(Map<String, dynamic> event) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          title: const Text('일정 수정'),
          onTap: () async {
            Navigator.pop(context);
            final editedEvent = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddScheduleScreen(
                  initialData: {
                    'startDate': event['startDate'],
                    'endDate': event['endDate'],
                    'content': event['content'],
                  },
                ),
              ),
            );
            if (editedEvent != null) {
              setState(() {
                final index = _events.indexOf(event);
                _events[index] = editedEvent;
              });
              await _saveSchedules();
            }
          },
        ),
        ListTile(
          title: const Text('일정 삭제'),
          onTap: () {
            setState(() {
              _events.remove(event);
            });
            _saveSchedules();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}



