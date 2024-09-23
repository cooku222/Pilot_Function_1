import 'package:flutter/material.dart';
import '../services/tmap_api_service.dart';

class RouteTestScreen extends StatefulWidget {
  @override
  _RouteTestScreenState createState() => _RouteTestScreenState();
}

class _RouteTestScreenState extends State<RouteTestScreen> {
  final TmapApiService _tmapApiService = TmapApiService();
  Map<String, dynamic>? routeData;
  bool isLoading = false;

  // 경로 데이터를 가져오는 함수
  Future<void> _fetchRoute() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    try {
      // 출발지와 목적지의 위도/경도를 설정
      final data = await _tmapApiService.getRoute(
        startLat: 37.5665,  // 서울 위도
        startLng: 126.9780, // 서울 경도
        endLat: 37.4515,    // 수원 위도
        endLng: 126.7012,   // 수원 경도
      );

      setState(() {
        routeData = data; // 데이터 저장
      });
    } catch (error) {
      print('Error fetching route: $error');
    } finally {
      setState(() {
        isLoading = false; // 로딩 종료
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('경로 데이터 확인'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())  // 로딩 중
          : routeData == null
          ? Center(
        child: ElevatedButton(
          onPressed: _fetchRoute,  // 버튼 클릭 시 경로 가져오기
          child: Text('경로 데이터 가져오기'),
        ),
      )
          : ListView(
        children: [
          Text('경로 데이터:'),
          Text(routeData.toString()),  // 받아온 경로 데이터 텍스트로 출력
        ],
      ),
    );
  }
}
