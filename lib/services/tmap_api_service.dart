import 'package:flutter/material.dart';
import 'screen/route_guidance.dart'; // 경로 안내 화면을 screen 디렉터리에서 import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMap Route Finder',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: RouteSelectionScreen(),
    );
  }
}

class RouteSelectionScreen extends StatelessWidget {
  // 미리 설정된 경로 (출발지/목적지 좌표)
  final List<Map<String, dynamic>> routes = [
    {'name': '복지관', 'start': [37.2960, 127.1155], 'end': [37.5665, 126.9778]},
    {'name': '아들집', 'start': [37.1234, 127.5678], 'end': [37.4567, 126.7890]},
    {'name': '시장', 'start': [37.2345, 127.4567], 'end': [37.5678, 126.9876]},
    {'name': '기차역', 'start': [37.3456, 127.1234], 'end': [37.6789, 126.8765]},
    {'name': '내 집', 'start': [37.4567, 127.2345], 'end': [37.7890, 126.7654]},
  ];

  // 주황색 코드 정의
  final Color orangeColor = Color(0xFFE75531);

  // TMap API를 사용해 경로 탐색
  void _navigateToRoute(BuildContext context, Map<String, dynamic> route) {
    final String routeName = route['name'];

    // '아들집'을 눌렀을 때 경로 안내 화면으로 이동
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteGuidanceScreen(destination: routeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null, // 상단 바 제거
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            // "어디로 가시나요?" 텍스트
            Text(
              '어디로\n가시나요?',
              textAlign: TextAlign.left, // 왼쪽 정렬
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold, // 볼드체
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40), // 텍스트와 버튼 사이 간격
            // 두 개씩 버튼 배열 (Row와 Column 조합)
            _buildRow(context, routes[0], routes[1]),
            SizedBox(height: 16),
            _buildRow(context, routes[2], routes[3]),
            SizedBox(height: 16),
            // 마지막 줄에는 하나만 배치
            _buildSingleButton(context, routes[4]),
            Spacer(), // 버튼과 아래 버튼 사이 공간 확보
          ],
        ),
      ),
    );
  }

  // 두 개의 버튼을 한 줄에 배치하는 메서드
  Widget _buildRow(BuildContext context, Map<String, dynamic> route1, Map<String, dynamic> route2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildButton(context, route1),
        _buildButton(context, route2),
      ],
    );
  }

  // 버튼 하나를 생성하는 메서드
  Widget _buildButton(BuildContext context, Map<String, dynamic> route) {
    return GestureDetector(
      onTap: () => _navigateToRoute(context, route),
      child: Container(
        width: 144,
        height: 78,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE75531), width: 2), // 주황색 테두리
          borderRadius: BorderRadius.circular(36), // 둥근 모서리
        ),
        alignment: Alignment.center,
        child: Text(
          route['name'],
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  // 마지막 줄에 하나의 버튼을 배치하는 메서드
  Widget _buildSingleButton(BuildContext context, Map<String, dynamic> route) {
    return Center(
      child: _buildButton(context, route),
    );
  }
}
