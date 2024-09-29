import 'package:flutter/material.dart';
import 'package:route/screens/route_summary_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(controller: _startXController, hintText: "출발 경도 (startX)"),
            SizedBox(height: 20),
            _buildTextField(controller: _startYController, hintText: "출발 위도 (startY)"),
            SizedBox(height: 20),
            _buildTextField(controller: _endXController, hintText: "도착 경도 (endX)"),
            SizedBox(height: 20),
            _buildTextField(controller: _endYController, hintText: "도착 위도 (endY)"),
            SizedBox(height: 40),
            SizedBox(
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
                  // 입력값 검증
                  if (_startXController.text.isEmpty ||
                      _startYController.text.isEmpty ||
                      _endXController.text.isEmpty ||
                      _endYController.text.isEmpty) {
                    _showErrorDialog(context, "모든 필드를 입력해주세요.");
                    return;
                  }

                  try {
                    // Tmap API 호출
                    List<String> routeSummaries = await _fetchTmapRoutes(
                      _startXController.text,
                      _startYController.text,
                      _endXController.text,
                      _endYController.text,
                    );
                    int routeCount = routeSummaries.length;

                    // RouteSummaryScreen으로 화면 전환
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RouteSummaryScreen(
                          routeCount: routeCount,
                          routeSummaries: routeSummaries,
                          startX: _startXController.text, // startX 전달
                          startY: _startYController.text, // startY 전달
                          endX: _endXController.text, // endX 전달
                          endY: _endYController.text, // endY 전달
                        ),
                      ),
                    );
                  } catch (error) {
                    _showErrorDialog(context, error.toString());
                  }
                },
                child: Text(
                  "경로 찾기",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> _fetchTmapRoutes(String startX, String startY, String endX, String endY) async {
    const String tmapUrl = 'https://apis.openapi.sk.com/transit/routes';
    const String apiKey = 'EhDYONMDB86WyuLiJIzIo4kVcx8Ptd6c7g6SyONR'; // 실제 Tmap API Key로 대체

    final response = await http.post(
      Uri.parse(tmapUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'appKey': apiKey,
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
      final data = json.decode(utf8.decode(response.bodyBytes));

      // 오류 메시지 처리
      if (data['result'] != null && data['result']['message'] != null) {
        throw Exception('${data['result']['message']}');
      }

      // 경로 요약 데이터를 가공하여 리스트로 반환
      List<String> routeSummaries = [];
      for (var route in data['metaData']['plan']['itineraries']) {
        int pathType = route['pathType'] ?? 0;
        int totalTime = route['totalTime'] ?? 0;
        int transferCount = route['transferCount'] ?? 0;
        routeSummaries.add("경로 유형: $pathType, 총 시간: ${totalTime / 60}분, 환승 횟수: $transferCount");
      }
      return routeSummaries;
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('Tmap API 호출 실패: ${errorData['result']['message']}');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
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
}
