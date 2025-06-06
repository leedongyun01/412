import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar/services/local_storage_service.dart';
import 'package:calendar/screens/add_schedule_screen.dart';


class MyCalendarScreen extends StatefulWidget {
  const MyCalendarScreen({Key? key}) : super(key: key);

  @override
  State<MyCalendarScreen> createState() => _MyCalendarScreenState();
}

class _MyCalendarScreenState extends State<MyCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _events = [];
  final LocalStorageService _storageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    final fetchedEvents = await _storageService.readSchedules();
    setState(() {
      _events = fetchedEvents;
    });
    print(fetchedEvents);
  }

  Future<void> _saveSchedules() async {
    await _storageService.saveSchedules(_events);
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      DateTime startDate = DateTime.parse(event['startDate']);
      DateTime endDate = DateTime.parse(event['endDate']);
      return day.isAfter(startDate.subtract(Duration(days: 1))) &&
          day.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
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
        ],
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
                    'content': event['content'],
                    'startDate': event['startDate'],
                    'endDate': event['endDate'],
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
