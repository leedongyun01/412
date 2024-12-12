import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static const String _fileName = 'schedules.json';

  // 로컬 경로
  Future<File> _getLocalFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      print('로컬 디렉토리 경로: ${directory.path}');  // 디렉토리 경로 출력
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
      print('읽을 파일 경로: ${file.path}');  // 파일 경로 출력

      if (await file.exists()) {
        print('파일 존재: ${file.path}');  // 파일 존재 확인
        final contents = await file.readAsString();
        print('파일 내용: $contents');  // 파일 내용 출력
        final jsonData = json.decode(contents);
        return List<Map<String, dynamic>>.from(jsonData['schedules'] ?? []);
      } else {
        print('파일 없음');  // 파일이 없을 경우
        await _createEmptyFile();
        return [];
      }
    } catch (e) {
      print('읽기 실패: $e');
      return [];
    }
  }

  // 파일이 없으면 빈 파일을 생성
  Future<void> _createEmptyFile() async {
    final file = await _getLocalFile();
    final emptyData = {'schedules': []}; // 빈 스케줄 리스트
    await file.writeAsString(json.encode(emptyData));
    print('빈 파일 생성 완료');
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
      print('저장 성공');  // 저장 성공 시 출력
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
