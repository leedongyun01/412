import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static const String _fileName = 'schedules.json';

  // 로컬 경로
  Future<File> _getLocalFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print('로컬 디렉토리 경로: ${directory.path}');
      return File('${directory.path}/$_fileName');
    } catch (e) {
      print('경로 받아오기 실패: $e');
      rethrow;
    }
  }

  // JSON 읽기
  Future<List<Map<String, dynamic>>> readSchedules() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final jsonData = json.decode(contents);
        return List<Map<String, dynamic>>.from(jsonData['schedules'] ?? []);
      } else {
        return [];
      }
    } catch (e) {
      print('읽기 실패: $e');
      return [];
    }
  }

  // JSON 저장
  Future<void> saveSchedules(List<Map<String, dynamic>> schedules) async {
    try {
      final file = await _getLocalFile();
      final Map<String, dynamic> jsonData = {
        'schedules': schedules,
      };
      final String jsonString = json.encode(jsonData);
      await file.writeAsString(jsonString);
      print('저장 성공');
    } catch (e) {
      print('저장 실패: $e');
    }
  }

  // 일정 추가
  Future<void> addSchedule(Map<String, dynamic> newSchedule) async {
    try {
      List<Map<String, dynamic>> schedules = await readSchedules();
      schedules.add(newSchedule);
      await saveSchedules(schedules);
    } catch (e) {
      print("저장 실패: $e");
    }
  }
}
