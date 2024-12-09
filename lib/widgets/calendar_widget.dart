import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final DateTime? selectedDay;
  final Map<DateTime, List<String>> events;

  const CalendarWidget({
    required this.focusedDay,
    required this.onDaySelected,
    this.selectedDay,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      eventLoader: (day) => events[day] ?? [],
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
      ),
    );
  }
}
