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
            // 버튼: 경로 찾기
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
                  String startX = _startXController.text;
                  String startY = _startYController.text;
                  String endX = _endXController.text;
                  String endY = _endYController.text;

                  // 입력값 검증
                  if (startX.isEmpty || startY.isEmpty || endX.isEmpty || endY.isEmpty) {
                    _showErrorDialog(context, "입력 오류", "모든 입력값을 채워주세요.");
                    return;
                  }

                  try {
                    // Tmap API 호출
                    List<dynamic> routeSummaries = await _fetchTmapRoutes(startX, startY, endX, endY);

                    // 새 페이지로 데이터를 넘기며 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RouteListScreen(routeSummaries: routeSummaries),
                      ),
                    );
                  } catch (error) {
                    _showErrorDialog(context, "Error", error.toString());
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
          ],
        ),
      ),
    );
  }

  // API 호출을 통한 경로 데이터 가져오기
  Future<List<dynamic>> _fetchTmapRoutes(String startX, String startY, String endX, String endY) async {
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
      // response.bodyBytes를 사용하여 UTF-8로 디코딩
      final data = json.decode(utf8.decode(response.bodyBytes));

      if (data['result'] != null && data['result']['message'] != null) {
        throw Exception('${data['result']['message']}');
      }

      List<dynamic> routeSummaries = [];
      for (var feature in data['metaData']['plan']['itineraries']) {
        routeSummaries.add(feature);
      }
      return routeSummaries;
    } else {
      // 오류 처리 (response.bodyBytes를 사용하여 UTF-8로 디코딩)
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('Tmap API 호출 실패: ${errorData['result']['message']}');
    }
  }

  // 경고창을 표시하는 함수
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

class RouteListScreen extends StatelessWidget {
  final List<dynamic> routeSummaries;

  RouteListScreen({required this.routeSummaries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("경로 목록"),
      ),
      body: ListView.builder(
        itemCount: routeSummaries.length,
        itemBuilder: (context, index) {
          var route = routeSummaries[index];

          int pathType = route['pathType'] ?? 0;
          int totalTime = route['totalTime'] ?? 0;
          int totalWalkTime = route['totalWalkTime'] ?? 0;
          int transferCount = route['transferCount'] ?? 0;
          int totalFare = route['fare']['regular']['totalFare'] ?? 0;

          String summary = "경로 유형: $pathType | "
              "총 시간: ${totalTime / 60} 분 | "
              "총 도보 시간: $totalWalkTime 분 | "
              "환승 횟수: $transferCount | "
              "총 요금: $totalFare 원";

          return ListTile(
            title: Text(summary),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RouteDetailScreen(route: route),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RouteDetailScreen extends StatelessWidget {
  final dynamic route;

  RouteDetailScreen({required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("경로 상세 정보"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          jsonEncode(route),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
