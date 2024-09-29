import 'dart:convert';  // JSON 변환을 위해 필요한 패키지
import 'package:flutter/material.dart';
import 'package:route/services/api_service.dart';


class RouteDetailScreen extends StatefulWidget {
  final int routeIndex;
  final String startX;
  final String startY;
  final String endX;
  final String endY;

  RouteDetailScreen({
    required this.routeIndex,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });

  @override
  _RouteDetailScreenState createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  ApiService apiService = ApiService();
  Map<String, dynamic>? routeDetail;
  List<Map<String, dynamic>> routeSteps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRouteDetail();
  }


// ...

  Future<void> fetchRouteDetail() async {
    try {
      // API로부터 데이터를 수신 (여기서는 JSON 형식으로 수신할 것이라 가정)
      var routeData = await apiService.fetchRoute(
        startX: widget.startX,
        startY: widget.startY,
        endX: widget.endX,
        endY: widget.endY,
      );

      // 응답 데이터를 확인
      print('Route Data: $routeData');

      // 응답에서 경로 정보 가져오기
      var itineraries = routeData['metaData']['plan']['itineraries'] as List<dynamic>;

      setState(() {
        routeDetail = Map<String, dynamic>.from(itineraries[widget.routeIndex]);
        routeSteps = [];

        // 각 경로의 legs와 steps를 가져옴
        for (var leg in routeDetail!['legs']) {
          if (leg['steps'] != null) {
            for (var step in leg['steps']) {
              routeSteps.add(Map<String, dynamic>.from(step));
            }
          }
        }
        isLoading = false; // 로딩 완료
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorMessage("경로 정보를 가져오는 중 에러가 발생했습니다.");
    }
  }



  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // 세부 경로 정보 표시
  Widget buildStepDetail(Map<String, dynamic> step) {
    String mode = step['mode'] ?? 'UNKNOWN';
    String description = '';

    switch (mode) {
      case 'BUS':
        description = '버스: ${step['route']} (${step['start']['name']} -> ${step['end']['name']})';
        break;
      case 'WALK':
        description = '도보: ${step['distance']}m 이동 (${step['start']['name']} -> ${step['end']['name']})';
        break;
      default:
        description = '기타 이동 수단';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          "경로 상세 정보",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "경로 (${widget.routeIndex + 1}) 상세 정보",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (routeDetail != null) ...[
              Text(
                "총 시간: ${routeDetail!['totalTime'] ~/ 60}시간 ${routeDetail!['totalTime'] % 60}분",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(
                "환승 횟수: ${routeDetail!['transferCount']}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
            SizedBox(height: 20),
            Text(
              "세부 경로",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: routeSteps.length,
                itemBuilder: (context, index) {
                  return buildStepDetail(routeSteps[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
