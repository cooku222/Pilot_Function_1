import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RouteListScreen extends StatefulWidget {
  @override
  _RouteListScreenState createState() => _RouteListScreenState();
}

class _RouteListScreenState extends State<RouteListScreen> {
  ApiService apiService = ApiService();
  late Future<List<dynamic>> _routeData; // API 데이터를 저장할 변수

  @override
  void initState() {
    super.initState();
    _routeData = fetchRoutes(); // API 호출
  }

  Future<List<dynamic>> fetchRoutes() async {
    try {
      var routeData = await apiService.fetchRoute(); // API 호출
      return routeData; // 데이터 반환
    } catch (e) {
      showErrorMessage(e.toString()); // 에러 메시지 표시
      return []; // 오류 발생 시 빈 리스트 반환
    }
  }

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)), // 에러 메시지를 화면에 표시
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('경로 목록')),
      body: FutureBuilder<List<dynamic>>(
        future: _routeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // 로딩 중일 때
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}')); // 에러 발생 시
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('경로 ${index + 1}: ${snapshot.data![index]['summary']}'),
                  onTap: () {
                    // 경로 클릭 시 상세 정보로 이동
                  },
                );
              },
            );
          } else {
            return Center(child: Text('경로를 찾을 수 없습니다.')); // 데이터가 없을 때
          }
        },
      ),
    );
  }
}
