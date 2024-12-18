import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static const String _fileName = 'schedules.json';

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<List<Map<String, dynamic>>> readSchedules() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final contents = await file.readAsString();
      final jsonData = json.decode(contents);
      return List<Map<String, dynamic>>.from(jsonData['schedules'] ?? []);
    }
    await _createEmptyFile();
    return [];
  }

  Future<void> _createEmptyFile() async {
    final file = await _getLocalFile();
    await file.writeAsString(json.encode({'schedules': []}));
  }

  Future<void> saveSchedules(List<Map<String, dynamic>> schedules) async {
    final file = await _getLocalFile();
    await file.writeAsString(json.encode({'schedules': schedules}));
  }

  Future<void> addSchedule(Map<String, dynamic> newSchedule) async {
    final schedules = await readSchedules();
    schedules.add(newSchedule);
    await saveSchedules(schedules);
  }
}
