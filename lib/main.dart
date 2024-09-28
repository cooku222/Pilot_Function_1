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
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _departureController,
              hintText: "출발",
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _arrivalController,
              hintText: "도착",
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTransportButton("지하철"),
                _buildTransportButton("버스"),
              ],
            ),
            Spacer(),
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
                  String departure = _departureController.text;
                  String arrival = _arrivalController.text;

                  try {
                    // 경로 데이터를 API에서 가져오기
                    List<dynamic> routeSummaries = await _fetchTmapRoutes(departure, arrival);

                    // 새 페이지로 데이터를 넘기며 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RouteListScreen(routeSummaries: routeSummaries),
                      ),
                    );
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
          ],
        ),
      ),
    );
  }

  // API 호출을 통한 경로 데이터 가져오기
  Future<List<dynamic>> _fetchTmapRoutes(String departure, String arrival) async {
    const String tmapUrl = 'https://apis.openapi.sk.com/transit/routes';

    final response = await http.post(
      Uri.parse(tmapUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'appKey': 'EhDYONMDB86WyuLiJIzIo4kVcx8Ptd6c7g6SyONR',
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
        'startX': '126.8526012',
        'startY': '35.1595454',
        'endX': '127.3845475',
        'endY':  '36.3504119',
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
