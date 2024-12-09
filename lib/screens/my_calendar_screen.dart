import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'add_schedule_screen.dart';
import 'edit_schedule_screen.dart';

class MyCalendarScreen extends StatefulWidget {
  @override
  _MyCalendarScreenState createState() => _MyCalendarScreenState();
}

class _MyCalendarScreenState extends State<MyCalendarScreen> {
  late Map<DateTime, List<Map<String, String>>> _events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedDay = _focusedDay;
  }

  void _addSchedule() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddScheduleScreen()),
    );

    if (result != null) {
      final startDate = DateTime(
        result['startDate'].year,
        result['startDate'].month,
        result['startDate'].day,
      );
      final endDate = DateTime(
        result['endDate'].year,
        result['endDate'].month,
        result['endDate'].day,
      );

      setState(() {
        DateTime currentDate = startDate;

        while (!currentDate.isAfter(endDate)) {
          if (_events[currentDate] == null) {
            _events[currentDate] = [];
          }
          _events[currentDate]!.add({
            'content': result['content'],
            'startDate': result['startDate'].toString(),
            'endDate': result['endDate'].toString(),
          });
          currentDate = currentDate.add(Duration(days: 1));
        }
      });
    }
  }

  void _editSchedule(DateTime oldDay, Map<String, String> oldEvent) async {
    final updatedEvent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScheduleScreen(
          selectedDate: oldDay,
          event: oldEvent,
        ),
      ),
    );

    if (updatedEvent != null) {
      setState(() {
        _events[oldDay]?.remove(oldEvent);
        if (_events[oldDay]?.isEmpty ?? true) {
          _events.remove(oldDay);
        }

        DateTime newDate = updatedEvent['startDate'];
        if (_events[newDate] == null) {
          _events[newDate] = [];
        }
        _events[newDate]!.add({
          'content': updatedEvent['content'],
        });
      });
    }
  }

    void _showEditDeleteDialog(DateTime day, Map<String, String> event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제, 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('수정'),
                onTap: () {
                  Navigator.pop(context);
                  _editSchedule(day, event);
                },
              ),
              ListTile(
                title: Text('삭제'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteSchedule(day, event);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteSchedule(DateTime day, Map<String, String> event) {
    setState(() {
      _events[day]?.remove(event);
      if (_events[day]?.isEmpty ?? true) {
        _events.remove(day);
      }
    });
  }

  List<Map<String, String>> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 캘린더'),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay!)
                  .map((event) => ListTile(
                        title: Text(event['content']!),
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () => _showEditDeleteDialog(_selectedDay!, event),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSchedule,
        tooltip: '일정 추가',
        child: Icon(Icons.add),
      ),
    );
  }
}
