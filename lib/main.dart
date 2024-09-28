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
                    showErrorDialog(context, "Error", error.toString());
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
      //11 ERR
      // body: jsonEncode({
      //   'startX': '126.926493082645',
      //   'startY': '37.6134436427887',
      //   'endX': '126.926493082645',
      //   'endY':  '37.6134436427887',
      //   'lang': 0,
      //   'format': 'json',
      //   'count': 10,
      // }),

      //23 ERR
      // body: jsonEncode({
      //   'startX': '200',
      //   'startY': '400',
      //   'endX': '-126.926493082645',
      //   'endY':  '37.6134436427887',
      //   'lang': 0,
      //   'format': 'json',
      //   'count': 10,
      // }),
      //23 ERR

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

      // 'result' 필드가 null이 아니고, 메시지가 있을 때만 예외 처리
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
  void showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 307.56,
            height: 217,
            color: Color(0xFFD9D9D9), // 회색 배경
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black, // 글씨체 색상 #000000
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.black, // 글씨체 색상 #000000
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // 버튼 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '확인',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
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
  Widget _buildTransportButton(String label) {
    return SizedBox(
      width: 140,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE75531),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        onPressed: () {
          print('$label 버튼 클릭됨');
        },
        child: Text(
          label,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}

class RouteListScreen extends StatelessWidget {
  final List<dynamic> routeSummaries;  // 이전 화면에서 받은 경로 데이터

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

            // 필요한 정보를 추출하여 summary에 추가
            int pathType = route['pathType'] ?? 0;
            int totalTime = route['totalTime'] ?? 0;
            int totalWalkTime = route['totalWalkTime'] ?? 0;
            int transferCount = route['transferCount'] ?? 0;
            int totalFare = route['fare']['regular']['totalFare'] ?? 0;

            // summary 문자열 생성
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
          }
      ),
    );
  }
}
class RouteDetailScreen extends StatelessWidget {
  final dynamic route;  // 클릭된 경로의 전체 데이터

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
          jsonEncode(route),  // 경로 전체 데이터를 출력
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
