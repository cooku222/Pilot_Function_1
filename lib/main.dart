import 'package:flutter/material.dart';
import 'package:route/screens/route_summary_screen.dart';

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
      backgroundColor: Colors.white, // 전체 배경을 흰색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 출발 칸
            _buildTextField(
              controller: _departureController,
              hintText: "출발",
            ),
            SizedBox(height: 20),
            // 도착 칸
            _buildTextField(
              controller: _arrivalController,
              hintText: "도착",
            ),
            SizedBox(height: 40),
            // 지하철과 버스 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTransportButton("지하철"),
                _buildTransportButton("버스"),
              ],
            ),
            Spacer(),
            // 경로 찾기 버튼
            SizedBox(
              width: 304,
              height: 64,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE75531), // 주황색
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(39),
                  ),
                ),
                onPressed: () {
                  // Tmap API를 통해 얻은 경로 데이터를 사용하여 화면 이동
                  List<String> mockRouteSummaries = [
                    "지하철 30분, 버스 15분",
                    "버스 40분, 도보 10분"
                  ]; // 경로 요약 데이터 (예시)

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RouteSummaryScreen(
                        routeCount: mockRouteSummaries.length,
                        routeSummaries: mockRouteSummaries,
                      ),
                    ),
                  );
                },
                child: Text(
                  "경로 찾기",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600, // 세미 볼드
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

  // 텍스트 필드 빌더 (출발/도착 칸)
  Widget _buildTextField({required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: 30, // 글씨 크기를 30으로 설정
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(39),
          borderSide: BorderSide(
            color: Color(0xFFE75531), // 테두리 주황색
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(39),
          borderSide: BorderSide(
            color: Color(0xFFE75531),
            width: 2,
          ),
        ),
      ),
    );
  }

  // 지하철/버스 버튼 빌더
  Widget _buildTransportButton(String label) {
    return SizedBox(
      width: 140,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE75531), // 버튼 주황색
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        onPressed: () {
          // 버튼 클릭 시 동작
        },
        child: Text(
          label,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
