import 'dart:convert'; // JSON 처리
import 'dart:io'; // 파일 작업
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // 로컬 경로 접근
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'add_shared_schedule_screen.dart';

class SharedCalendarScreen extends StatefulWidget {
  final String? startDate;
  final String? endDate;
  final String? sharedCalendarName;
  final String sharedCalendarId; // 공유 캘린더 ID 추가
  final String userNickname; // 유저 닉네임 추가

  const SharedCalendarScreen({
    Key? key,
    this.startDate,
    this.endDate,
    this.sharedCalendarName,
    required this.sharedCalendarId, // 필수 파라미터로 설정
    required this.userNickname,     // 필수 파라미터로 설정
  }) : super(key: key);

  @override
  State<SharedCalendarScreen> createState() => _SharedCalendarScreenState();
}

class _SharedCalendarScreenState extends State<SharedCalendarScreen> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();

    _firstDay = widget.startDate != null
        ? DateTime.parse(widget.startDate!)
        : DateTime.now();
    _lastDay = widget.endDate != null
        ? DateTime.parse(widget.endDate!)
        : DateTime.now().add(const Duration(days: 7));
    _focusedDay = _firstDay;
  }

  /// JSON 파일 경로 가져오기
  Future<String> _getLocalFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/schedules.json';
  }

  /// 로컬 JSON 파일에서 일정 데이터 읽기
  Future<void> syncCalendar() async {
    final url = Uri.parse('http://121.174.224.9:61314/event/sync');

    try {
      // 로컬에서 일정 데이터 읽기
      final scheduleInfo = await _readLocalSchedule();

      // 서버에 보낼 데이터 형식 확인
      final requestData = {
        "sharedCalenderId": widget.sharedCalendarId,
        "userNickname": widget.userNickname,
        "scheduleInfo": scheduleInfo.map((event) {
          return {
            "startDate": event["startDate"],
            "endDate": event["endDate"],
            "content": event["content"],
          };
        }).toList(),
      };

      // 서버로 보내기 전에 requestData 출력 (JSON 형식 확인)
      String jsonString = json.encode(requestData);
      print('전송할 데이터 (JSON): $jsonString'); // 여기서 출력된 JSON 확인

      // API 호출
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonString,  // JSON 데이터를 직접 보내기
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('동기화 성공: $responseData');
      } else {
        print('동기화 실패: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('동기화에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    } catch (e) {
      print('동기화 오류: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('동기화 중 오류가 발생했습니다.')),
      );
    }
  }




  Future<List<Map<String, dynamic>>> _readLocalSchedule() async {
    try {
      final filePath = await _getLocalFilePath();
      final file = File(filePath);

      // 파일이 존재하지 않을 경우 빈 리스트 반환
      if (!await file.exists()) {
        print('JSON 파일이 존재하지 않습니다.');
        return [];
      }

      // JSON 파일 읽기
      final jsonString = await file.readAsString();
      print('파일 내용: $jsonString');  // 파일 내용 출력

      final jsonData = json.decode(jsonString);

      // JSON 데이터에서 'schedules' 키가 List인지 확인
      if (jsonData is Map && jsonData.containsKey('schedules') && jsonData['schedules'] is List) {
        return List<Map<String, dynamic>>.from(jsonData['schedules']);
      } else {
        print('JSON 형식이 올바르지 않습니다. schedules가 List가 아닙니다.');
        return [];
      }
    } catch (e) {
      print('JSON 파일 읽기 오류: $e');
      return [];
    }
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
                return _selectedDay != null && isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
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
                selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('초대 링크 생성'),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: syncCalendar, // 동기화 버튼 클릭 시 호출
            child: const Icon(Icons.sync),
            tooltip: '동기화',
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSharedScheduleScreen(
                    calendarName: widget.sharedCalendarName ?? '기본 캘린더 이름',
                    startDate: _firstDay,
                    endDate: _lastDay,
                  ),
                ),
              );

              if (result != null) {
                print('추가된 일정: $result');
              }
            },
            child: const Icon(Icons.add),
            tooltip: '일정 추가',
          ),
        ],
      ),
    );
  }
}
