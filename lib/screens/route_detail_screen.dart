import 'package:flutter/material.dart';
import 'package:route/services/api_service.dart';

class RouteDetailScreen extends StatefulWidget {
  final int routeIndex;
  final String startX;
  final String startY;
  final String endX;
  final String endY;
  final double totalMinutes;  // 총 시간을 전달받음
  final int routeType;  // 경로 유형을 전달받음

  RouteDetailScreen({
    required this.routeIndex,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.totalMinutes,  // 총 시간을 전달받음
    required this.routeType,  // 경로 유형을 전달받음
  });

  @override
  _RouteDetailScreenState createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  ApiService apiService = ApiService();
  Map<String, dynamic>? routeDetail;
  List<Map<String, dynamic>> routeLegs = [];  // 각 경로 구간 (Leg) 저장
  bool isLoading = true;

  // 경로 유형 번호를 한국어로 매핑하는 함수
  final Map<int, String> routeTypeMap = {
    1: "도보",
    2: "버스",
    3: "지하철",
    4: "고속/시외버스",
    5: "기차",
    6: "항공",
    7: "해운"
  };

  @override
  void initState() {
    super.initState();
    fetchRouteDetail();
  }

  // 경로 정보를 API로부터 받아오는 함수
  Future<void> fetchRouteDetail() async {
    try {
      var routeData = await apiService.fetchRoute(
        startX: widget.startX,
        startY: widget.startY,
        endX: widget.endX,
        endY: widget.endY,
      );

      // 응답에서 경로 정보 가져오기
      var itineraries = routeData['metaData']['plan']['itineraries'] as List<dynamic>;

      setState(() {
        routeDetail = Map<String, dynamic>.from(itineraries[widget.routeIndex]);
        routeLegs = [];

        // 각 경로의 legs 정보를 추가
        for (var leg in routeDetail!['legs']) {
          routeLegs.add(Map<String, dynamic>.from(leg));
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

  // 오류 메시지를 출력하는 함수
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // 각 Leg의 세부 정보를 표시하는 함수
  Widget buildLegDetail(Map<String, dynamic> leg) {
    String mode = leg['mode'] ?? 'UNKNOWN';  // 이동수단 구분
    String description = '';

    // 이동수단에 따른 설명을 구성
    switch (mode) {
      case 'BUS':
        description = '버스: ${leg['route']} (${leg['start']['name']} -> ${leg['end']['name']})';
        break;
      case 'SUBWAY':
        description = '지하철: ${leg['route']} (${leg['start']['name']} -> ${leg['end']['name']})';
        break;
      case 'EXPRESSBUS':
        description = '고속버스: ${leg['route']} (${leg['start']['name']} -> ${leg['end']['name']})';
        break;
      case 'WALK':
        description = '도보: ${leg['distance']}m 이동 (${leg['start']['name']} -> ${leg['end']['name']})';
        break;
      default:
        description = '기타 이동수단 정보 없음';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '세부 경로:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (leg.containsKey('steps') && leg['steps'] != null && leg['steps'].isNotEmpty) ...[
            for (var step in leg['steps']) buildStepDetail(step),
          ] else if (mode == 'WALK' && (leg['steps'] == null || leg['steps'].isEmpty)) ...[
            Text('도보 경로의 세부 경로가 없습니다.', style: TextStyle(fontSize: 16, color: Colors.black54)),
          ] else if (mode == 'BUS' && leg['passStopList'] != null) ...[
            for (var station in leg['passStopList']['stationList']) buildStationDetail(station),
          ] else if (mode == 'EXPRESSBUS' && leg['passStopList'] != null) ...[
            for (var station in leg['passStopList']['stationList']) buildStationDetail(station),
          ] else if (mode == 'SUBWAY' && leg['passStopList'] != null) ...[
            for (var station in leg['passStopList']['stationList']) buildStationDetail(station),
          ] else ...[
            Text('세부 경로 정보 없음', style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ],
      ),
    );
  }

  // 각 Step의 세부 정보를 표시하는 함수 (description을 포함)
  Widget buildStepDetail(Map<String, dynamic> step) {
    String streetName = step['streetName'] ?? '알 수 없는 도로';
    String description = step['description'] ?? '설명 없음';  // description 출력
    int distance = step['distance'] ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$streetName: $description ($distance m)',  // description과 거리 출력
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // 정류장 세부 정보를 표시하는 함수
  Widget buildStationDetail(Map<String, dynamic> station) {
    int stationIndex = station['index'] ?? 0;
    String stationName = station['stationName'] ?? '알 수 없는 정류장';
    double lat = double.parse(station['lat'] ?? '0.0');
    double lon = double.parse(station['lon'] ?? '0.0');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        '$stationIndex: $stationName (위도: $lat, 경도: $lon)',
        style: TextStyle(fontSize: 14, color: Colors.black87),
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
              "경로 상세 정보",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // 전달받은 총 시간을 사용하여 동일한 형식으로 출력
            Text(
              "총 시간: ${formatTime(widget.totalMinutes)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 10),
            // 경로 유형 출력
            Text(
              "경로 유형: ${routeTypeMap[widget.routeType] ?? '알 수 없는 유형'}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 10),
            // 구간 정보 출력
            Expanded(
              child: ListView.builder(
                itemCount: routeLegs.length,
                itemBuilder: (context, index) {
                  return buildLegDetail(routeLegs[index]); // 각 구간 정보 표시
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 분 값을 받아서 시간과 분까지만 표시하는 함수 (초 단위는 반올림 제거)
  String formatTime(double totalMinutes) {
    int hours = (totalMinutes / 60).floor();  // 시간을 계산
    int minutes = (totalMinutes % 60).round();  // 분을 계산하고 반올림

    return "${hours > 0 ? "$hours시간 " : ""}${minutes}분";  // 시간과 분까지만 반환
  }
}
