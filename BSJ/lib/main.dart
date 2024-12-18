import 'package:flutter/material.dart';//UI, 스타일링 클래스 제공
import 'screens/login_screen.dart';//앱에서 사용할 파일 가져옴

void main() {
  WidgetsFlutterBinding.ensureInitialized();//앱 시작 시, 초기화
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {//상태 변경X 위젯
  const MyApp({Key? key}) : super(key: key);//생성자

  @override
  Widget build(BuildContext context) {//UI구성 핵심 메서드
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '공유 캘린더 앱',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),//앱의 홈화면 설정
    );
  }
}
