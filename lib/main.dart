import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math'; // 거리를 계산하기 위해 사용
import 'config.dart';  // config.dart에서 API Key를 불러옴
import 'screens/route_summary_screen.dart'; // 정확한 경로로 import

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
            // 출발 경도
            _buildTextField(
              controller: _startXController,
              hintText: "출발 경도 (startX)",
            ),
            SizedBox(height: 20),
            // 출발 위도
            _buildTextField(
              controller: _startYController,
              hintText: "출발 위도 (startY)",
            ),
            SizedBox(height: 20),
            // 도착 경도
            _buildTextField(
              controller: _endXController,
              hintText: "도착 경도 (endX)",
            ),
            SizedBox(height: 20),
            // 도착 위도
            _buildTextField(
              controller: _endYController,
              hintText: "도착 위도 (endY)",
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
                  backgroundColor: Color(0xFFE75531), // E75531 색상 적용
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
                    handleError(context, 22); // 입력값 누락 오류
                    return;
                  }

                  // 좌표의 형식 및 유효성 확인 (21번 에러 처리)
                  try {
                    double startXVal = double.parse(startX);
                    double startYVal = double.parse(startY);
                    double endXVal = double.parse(endX);
                    double endYVal = double.parse(endY);

                    // 좌표 유효 범위 확인
                    if (!_isValidCoordinate(startXVal, startYVal) || !_isValidCoordinate(endXVal, endYVal)) {
                      handleError(context, 21); // 필수 입력 값 형식 및 범위 오류
                      return;
                    }

                    // 출발지와 도착지가 가까운 경우 (11번 에러 처리)
                    double distance = calculateDistance(startYVal, startXVal, endYVal, endXVal);
                    if (distance < 0.5) {
                      handleError(context, 11); // 출발지/도착지 간 거리가 너무 가까움
                      return;
                    }

                    // Tmap API 호출
                    await _fetchTmapRoutes(startX, startY, endX, endY);
                  } catch (e) {
                    handleError(context, 21); // 형식 오류로 인한 에러 처리
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

  // 좌표 유효 범위 확인 함수
  bool _isValidCoordinate(double lon, double lat) {
    return lon >= -180 && lon <= 180 && lat >= -90 && lat <= 90;
  }

  // 두 지점 사이의 거리를 계산하는 함수 (단위: km)
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // 지구 반지름, 단위는 km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  // Tmap API 호출 함수
  Future<void> _fetchTmapRoutes(String startX, String startY, String endX, String endY) async {
    const String tmapUrl = 'https://apis.openapi.sk.com/transit/routes';

    try {
      final response = await http.post(
        Uri.parse(tmapUrl),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'appKey': 'EhDYONMDB86WyuLiJIzIo4kVcx8Ptd6c7g6SyONR',  // 실제 API Key로 변경
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
          List<String> routeSummaries = [];
          for (var feature in data['metaData']['plan']['itineraries']) {
            routeSummaries.add(feature['totalTime'].toString());
          }
          showSuccessDialog(context, "경로를 성공적으로 찾았습니다.");
        } else {
          handleError(context, 21); // 필수 입력 값 형식 및 범위 오류
        }
      } else {
        handleError(context, response.statusCode); // HTTP 상태 코드 처리
      }
    } catch (e) {
      handleError(context, 32); // 네트워크 오류 또는 기타 에러
    }
  }

  // 에러 처리 함수
  void handleError(BuildContext context, int errorCode) {
    String message;
    switch (errorCode) {
      case 11:
        message = "출발지/도착지 간 거리가 너무 가까움.";
        break;
      case 12:
        message = "출발지 정류장 매핑 실패";
        break;
      case 13:
        message = "도착지 정류장 매핑 실패";
        break;
      case 14:
        message = "기타 오류 발생";
        break;
      case 21:
        message = "필수 입력 값 형식 및 범위 오류";
        break;
      case 22:
        message = "필수 입력 값 누락 오류";
        break;
      case 23:
        message = "서비스 지역 아님";
        break;
      case 24:
        message = "타임머신 시간 오류";
        break;
      case 31:
        message = "일정 시간 응답이 없는 경우";
        break;
      case 32:
        message = "네트워크 오류 또는 기타 에러";
        break;
      case 200:
        message = "경로를 성공적으로 찾았습니다.";
        break;
      case 400:
        message = "잘못된 요청입니다. 요청 파라미터를 확인해주세요.";
        break;
      case 500:
        message = "서버 내부 오류입니다. 나중에 다시 시도해주세요.";
        break;
      default:
        message = "알 수 없는 오류가 발생했습니다.";
    }

    showErrorDialog(context, '에러 코드 $errorCode', message);
  }

  // 성공 메시지 표시
  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('성공'),
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

  // 에러 메시지 표시
  void showErrorDialog(BuildContext context, String title, String message) {
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
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTransportButton(String label) {
    return SizedBox(
      width: 140,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE75531), // E75531 색상
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
