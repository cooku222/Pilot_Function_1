import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Finder',
      home: RouteFinderScreen(),
    );
  }
}

class RouteFinderScreen extends StatefulWidget {
  @override
  _RouteFinderScreenState createState() => _RouteFinderScreenState();
}

class _RouteFinderScreenState extends State<RouteFinderScreen> {
  final TextEditingController _startXController = TextEditingController();
  final TextEditingController _startYController = TextEditingController();
  final TextEditingController _endXController = TextEditingController();
  final TextEditingController _endYController = TextEditingController();

  bool _isLoading = false; // API 호출 상태 표시
  String? routeSummary; // 경로 요약을 저장할 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 출발 경도 입력 필드
            _buildTextField(
              controller: _startXController,
              hintText: "출발 경도 (startX)",
            ),
            SizedBox(height: 20),
            // 출발 위도 입력 필드
            _buildTextField(
              controller: _startYController,
              hintText: "출발 위도 (startY)",
            ),
            SizedBox(height: 20),
            // 도착 경도 입력 필드
            _buildTextField(
              controller: _endXController,
              hintText: "도착 경도 (endX)",
            ),
            SizedBox(height: 20),
            // 도착 위도 입력 필드
            _buildTextField(
              controller: _endYController,
              hintText: "도착 위도 (endY)",
            ),
            SizedBox(height: 40),
            _isLoading
                ? CircularProgressIndicator() // API 호출 중일 때 로딩 표시
                : SizedBox(
              width: 304,
              height: 64,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE75531),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(39),
                  ),
                ),
                onPressed: () async {
                  String startX = _startXController.text;
                  String startY = _startYController.text;
                  String endX = _endXController.text;
                  String endY = _endYController.text;

                  // 입력값 검증
                  if (startX.isEmpty || startY.isEmpty || endX.isEmpty || endY.isEmpty) {
                    _showErrorDialog(context, "입력 오류", "모든 입력값을 채워주세요.");
                    return;
                  }

                  setState(() {
                    _isLoading = true; // API 호출 시작
                  });

                  try {
                    // Tmap API 호출
                    String summary = await _fetchTmapRoutes(startX, startY, endX, endY);
                    setState(() {
                      _isLoading = false; // API 호출 완료
                      routeSummary = summary; // 경로 요약을 저장
                    });
                  } catch (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    _showErrorDialog(context, "API 호출 실패", error.toString());
                  }
                },
                child: Text(
                  "경로 찾기",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            routeSummary != null
                ? Text(
              routeSummary!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ) // 경로 요약이 있으면 출력
                : Container(),
          ],
        ),
      ),
    );
  }

  // Tmap API 호출 함수
  Future<String> _fetchTmapRoutes(String startX, String startY, String endX, String endY) async {
    const String tmapUrl = 'https://apis.openapi.sk.com/transit/routes';

    final response = await http.post(
      Uri.parse(tmapUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'appKey': 'EhDYONMDB86WyuLiJIzIo4kVcx8Ptd6c7g6SyONR', // 실제 API Key로 변경
      },
      body: jsonEncode({
        'startX': startX,
        'startY': startY,
        'endX': endX,
        'endY': endY,
        'lang': 0,
        'format': 'json',
        'count': 10,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('metaData') && data['metaData'].containsKey('plan')) {
        // 정상적으로 API 호출에 성공한 경우
        var itinerary = data['metaData']['plan']['itineraries'][0];
        String summary = "총 시간: ${itinerary['totalTime']}분, 환승: ${itinerary['transferCount']}번";
        return summary; // 경로 요약을 반환
      } else {
        throw Exception('경로를 찾지 못했습니다.');
      }
    } else {
      throw Exception('Tmap API 호출 실패: ${response.statusCode}');
    }
  }

  // 입력 필드 위젯 생성
  Widget _buildTextField({required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(39),
          borderSide: BorderSide(color: Color(0xFFE75531), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(39),
          borderSide: BorderSide(color: Color(0xFFE75531), width: 2),
        ),
      ),
    );
  }

  // 오류 메시지 표시
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
