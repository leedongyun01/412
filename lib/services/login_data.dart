class LoginData {
  static Map<String, dynamic>? userData;

  static String userId = '';
  static String userName = '';
  static String password = '';
  static String userNickname = '';
  static int userAge = 0;
  static int userSex = 0;
  static String userPhone = '';

  static void setUserData(Map<String, dynamic> data) {
    userData = data;
    fromJson(data);
  }

  static void fromJson(Map<String, dynamic> json) {
    try {
      userId = json['id']?.toString() ?? '';
      userName = json['userName'] ?? '';
      password = json['password'] ?? '';
      userNickname = json['userNickname'] ?? '';
      userAge = json['userAge'] ?? 0;
      userSex = json['userSex'] ?? 0;
      userPhone = json['userPhone'] ?? '';
    } catch (e) {
      print('Error parsing JSON in fromJson: $e');
      clearData();
    }
  }

  static void clearData() {
    userId = '';
    userName = '';
    password = '';
    userNickname = '';
    userAge = 0;
    userSex = 0;
    userPhone = '';
  }

  static void printUserData() {
    print('User Data:');
    print('ID: $userId');
    print('Name: $userName');
    print('Password: $password');
    print('Nickname: $userNickname');
    print('Age: $userAge');
    print('Sex: $userSex');
    print('Phone: $userPhone');
  }
}
