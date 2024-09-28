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
            _buildTextField(
              controller: _startXController,
              hintText: "출발X",
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _startYController,
              hintText: "출발Y",
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _endXController,
              hintText: "도착X",
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _endYController,
              hintText: "도착Y",
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTransportButton("지하철"),
                _buildTransportButton("버스"),
              ],
            ),
            SizedBox(height: 64,),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "127.126936754911";
                      _startYController.text = "37.5004198786564";
                      _endXController.text = "127.126936754911";
                      _endYController.text = "37.5004198786565";
                    });
                  },
                  child: Text("Error 11"),
                ),
                SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "127.126936754911";
                      _startYController.text = "37.5004198786564";
                      _endXController.text = "127.3766370000000";
                      _endYController.text = "35.7687940000000";
                    });
                  },
                  child: Text("Error 12"),
                ),
                SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "127.376637";
                      _startYController.text = "35.768794";
                      _endXController.text = "127.126936754911";
                      _endYController.text = "37.5004198786564";
                    });
                  },
                  child: Text("Error 13"),
                ),
                SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "126.978374";
                      _startYController.text = "37.566610";
                      _endXController.text = "129.0756416";
                      _endYController.text = "37.566610";
                    });
                  },
                  child: Text("Error 14"),
                ),
                SizedBox(height: 24,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "200";
                      _startYController.text = "400";
                      _endXController.text = "null";
                      _endYController.text = "null";
                    });
                  },
                  child: Text("Error 21"),
                ),
                SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "127.126936754911";
                      _startYController.text = "37.5004198786564";
                      _endXController.text = "null";
                      _endYController.text = "null";
                    });
                  },
                  child: Text("Error 22"),
                ),
                SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "127.126936754911";
                      _startYController.text = "37.5004198786564";
                      _endXController.text = "-74.0060";
                      _endYController.text = "40.7128";
                    });
                  },
                  child: Text("Error 23"),
                ),
                SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "126.8526012";
                      _startYController.text = "35.1595454";
                      _endXController.text = "127.3845475";
                      _endYController.text = "36.3504119";
                    });
                  },
                  child: Text("Error 24"),
                ),
                SizedBox(height: 24,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "127.126936754911";
                      _startYController.text = "37.5004198786564";
                      _endXController.text = "null";
                      _endYController.text = "null";
                    });
                  },
                  child: Text("Error 31"),
                ),
                SizedBox(height: 31,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "127.126936754911";
                      _startYController.text = "37.5004198786564";
                      _endXController.text = "null";
                      _endYController.text = "null";
                    });
                  },
                  child: Text("Error 32"),
                ),
                SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "127.126936754911";
                      _startYController.text = "37.5004198786564";
                      _endXController.text = "126.978374";
                      _endYController.text = "37.566610";
                    });
                  },
                  child: Text("정상 케이스 1"),
                ),
                SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startXController.text = "127.126936754911";
                      _startYController.text = "37.5004198786564";
                      _endXController.text = "129.0756416";
                      _endYController.text = "35.1795543";
                    });
                  },
                  child: Text("정상 케이스 2"),
                ),
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

                  // 출발지와 도착지 좌표 (예시로 사용한 좌표)
                  String startX = _startXController.text;
                  String startY = _startYController.text;
                  String endX = _endXController.text;
                  String endY = _endYController.text;


                  // // 1. 출발지와 도착지가 동일하거나 매우 가까운 경우 11번 에러 처리
                  // double distance = calculateDistance(depY, depX, arrY, arrX);
                  // if (depX == arrX && depY == arrY || distance < 0.5) {
                  //   handleError(context, 11); // 11번 에러 처리 (거리가 매우 가까움)
                  //   return;
                  // }

                  try {
                    // 2. Tmap API를 호출하여 출발지와 도착지가 매핑되지 않는지 확인
                    List<String> routeSummaries = await _fetchTmapRoutes(startX, startY, endX, endY);

                    // Tmap API 결과에 따라 출발지/도착지 매핑 에러 처리
                    if (routeSummaries.contains('출발지 매핑 실패')) {
                      handleError(context, 12);  // 출발지 매핑 실패
                      return;
                    } else if (routeSummaries.contains('도착지 매핑 실패')) {
                      handleError(context, 13);  // 도착지 매핑 실패
                      return;
                    }

                    // 성공적으로 데이터를 받았을 경우에만 다음 화면으로 이동
                    if (routeSummaries.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteSummaryScreen(
                            routeSummaries: routeSummaries,
                            routeCount: routeSummaries.length, // 필수 파라미터 routeCount 추가
                          ),
                        ),
                      );
                    } else {
                      // 경로를 찾지 못한 경우 에러 처리
                      handleError(context, 21);  // 필수 입력 값 형식 및 범위 오류
                    }
                  } catch (error) {
                    // API 호출 실패 시 처리
                    print('API 호출 실패: $error');
                    handleError(context, 32);  // 기타 네트워크 오류 처리
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

// Tmap API를 호출하는 함수
  Future<List<String>> _fetchTmapRoutes(String startX, String startY, String endX, String endY) async {
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

      print(response);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // 1. 에러 필드 확인
        if (data.containsKey('error')) {
          String errorMessage = data['error']['message'];
          if (errorMessage.contains('출발지 매핑 실패')) {
            handleError(context, 12);  // 출발지 매핑 실패
            return [];
          } else if (errorMessage.contains('도착지 매핑 실패')) {
            handleError(context, 13);  // 도착지 매핑 실패
            return [];
          } else {
            handleError(context, 14);  // 기타 에러
            return [];
          }
        }

        // 2. metaData와 plan 필드 확인
        if (data.containsKey('metaData')) {
          if (data['metaData'].containsKey('plan')) {
            List<String> routeSummaries = [];
            for (var feature in data['metaData']['plan']['itineraries']) {
              routeSummaries.add(feature['totalTime'].toString());
            }
            return routeSummaries;
          } else {
            // plan 필드가 없을 때
            handleError(context, 21);  // 필수 입력 값 형식 및 범위 오류
            return [];
          }
        } else {
          // metaData 필드가 없을 때
          handleError(context, 21);  // 필수 입력 값 형식 및 범위 오류
          return [];
        }

      } else {
        // HTTP 상태 코드 처리 (400, 500 등)
        handleError(context, response.statusCode);
        return [];
      }
    } catch (e) {
      // 네트워크 오류 또는 API 호출 실패 시 오류 처리
      print('ClientException: $e');
      handleError(context, 32);  // 기타 네트워크 오류 처리
      return [];
    }
  }

  //경고창을 표시하는 함수
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
        message = "기타 오류";
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
