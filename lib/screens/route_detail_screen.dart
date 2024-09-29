import 'package:flutter/material.dart';
import 'package:route/services/api_service.dart'; // API 호출을 위해 가져오기

class RouteDetailScreen extends StatefulWidget {
  final int routeIndex; // 경로 인덱스 전달
  final String startX; // 좌표 값 전달
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
  ApiService apiService = ApiService(); // API 서비스 인스턴스 생성
  String routeDetail = ""; // 경로 상세 정보 저장
  List<String> routeSteps = []; // 세부 경로 정보
  bool isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    fetchRouteDetail(); // 경로 상세 정보 호출
  }

  // API 호출하여 경로 상세 정보 가져오기
  Future<void> fetchRouteDetail() async {
    try {
      var routeData = await apiService.fetchRoute(
        startX: widget.startX, // 전달받은 좌표 값 사용
        startY: widget.startY,
        endX: widget.endX,
        endY: widget.endY,
      ); // API 호출

      setState(() {
        routeDetail = routeData[widget.routeIndex]['detail']; // 상세 정보 업데이트
        routeSteps = List<String>.from(routeData[widget.routeIndex]['steps']); // 세부 경로 정보
        isLoading = false; // 로딩 완료
      });
    } catch (e) {
      setState(() {
        isLoading = false; // 로딩 완료
      });
      showErrorMessage(e.toString()); // 에러 처리
    }
  }

  // 에러 메시지 표시 함수
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 인디케이터 표시
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "경로(${widget.routeIndex + 1}) 상세 정보",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSans',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "경로(${widget.routeIndex + 1}) 상세 정보",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSans',
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: routeSteps.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      routeSteps[index], // 세부 경로 정보를 표시
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSans',
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Center(
              child: SizedBox(
                width: 304,
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE75531),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(39),
                    ),
                  ),
                  onPressed: () {
                    // 경로 안내 로직
                  },
                  child: Text(
                    "경로 안내하기",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
