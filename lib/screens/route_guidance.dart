import 'package:flutter/material.dart';

// 경로 안내 화면
class RouteGuidanceScreen extends StatelessWidget {
  final String destination;

  RouteGuidanceScreen({required this.destination});

  // 주황색 코드 정의
  final Color orangeColor = Color(0xFFE75531);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 수직 중앙 정렬
          children: [
            // 주황색 막대와 "내 위치" 및 목적지
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "내 위치" 텍스트 (볼드체, 크기 44)
                Text(
                  '내 위치',
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10), // 막대와 텍스트 간격
                // 주황색 막대
                Container(
                  width: 40,
                  height: 2,
                  color: orangeColor,
                ),
                SizedBox(width: 10), // 막대와 텍스트 간격
                // "아들집" 텍스트 (볼드체, 크기 44)
                Text(
                  destination,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // "경로를\n안내할까요?" 텍스트 (엔터로 구분, 크기 44)
            Text(
              '경로를\n안내할까요?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 44,
              ),
            ),
            SizedBox(height: 40), // 텍스트와 버튼 사이 간격
            // '경로 찾기' 버튼
            Center(
              child: SizedBox(
                width: 304,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    // 경로 찾기 로직 추가
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor, // 주황색 버튼 배경색
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36), // 둥근 모서리
                    ),
                  ),
                  child: Text(
                    '경로 찾기',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
