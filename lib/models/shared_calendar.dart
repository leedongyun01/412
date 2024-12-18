class SharedCalendar {
  final String id;
  final String adminUserId;
  final String calenderName;
  final String startDate;
  final String endDate;

  SharedCalendar({
    required this.id,
    required this.adminUserId,
    required this.calenderName,
    required this.startDate,
    required this.endDate,
  });

  // JSON 데이터를 받아서 SharedCalendar 객체로 변환
  factory SharedCalendar.fromJson(Map<String, dynamic> json) {
    return SharedCalendar(
      id: json['id'],
      adminUserId: json['adminUserId'],
      calenderName: json['calenderName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }
}
