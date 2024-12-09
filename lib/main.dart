import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/find_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/my_calendar_screen.dart';
import 'screens/shared_calendar_list_screen.dart';
import 'screens/create_shared_calendar_screen.dart';
import 'screens/shared_calendar_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '공유 캘린더',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/findPassword': (context) => FindPasswordScreen(),
        '/home': (context) => HomeScreen(),
        '/myCalendar': (context) => MyCalendarScreen(),
        '/sharedCalendarList': (context) => SharedCalendarListScreen(),
        '/createSharedCalendar': (context) => CreateSharedCalendarScreen(),
        '/sharedCalendar': (context) => SharedCalendarScreen(calendarName: '',),
      },
    );
  }
}