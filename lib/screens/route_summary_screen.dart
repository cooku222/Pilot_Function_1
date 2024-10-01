import 'package:flutter/material.dart';
import 'package:route/screens/route_detail_screen.dart';

class RouteSummaryScreen extends StatefulWidget {
  final int routeCount;
  final List<Map<String, dynamic>> routeSummaries; // 수정된 부분: List<String> -> List<Map<String, dynamic>>
  final String startX; // 추가된 좌표 값
  final String startY;
  final String endX;
  final String endY;

  RouteSummaryScreen({
    required this.routeCount,
    required this.routeSummaries,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });

  @override
  _RouteSummaryScreenState createState() => _RouteSummaryScreenState();
}

class _RouteSummaryScreenState extends State<RouteSummaryScreen> {
  // 이동 수단 종류를 경로 유형 번호에 맞게 매칭하는 사전 (한국어만 표시)
  final Map<int, String> routeTypeMap = {
    1: "도보",
    2: "버스",
    3: "지하철",
    4: "고속/시외버스",
    5: "기차",
    6: "항공",
    7: "해운"
  };

  // 분 값을 받아서 시간과 분까지만 표시하는 함수 (초 단위는 반올림 제거)
  String formatTime(double totalMinutes) {
    int hours = (totalMinutes / 60).floor();  // 시간을 계산
    int minutes = (totalMinutes % 60).round();  // 분을 계산하고 반올림

    return "${hours > 0 ? "$hours시간 " : ""}${minutes}분";  // 시간과 분까지만 반환
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          '경로 요약',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.routeCount}개의 경로를 찾았어요",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoSans',
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.routeCount,
                itemBuilder: (context, index) {
                  // 경로 요약 데이터에서 값 추출
                  int routeType = widget.routeSummaries[index]["경로 유형"];
                  double totalMinutes = widget.routeSummaries[index]["총 시간"];
                  int transferCount = widget.routeSummaries[index]["환승 횟수"];

                  String transportModesText = routeTypeMap[routeType] ?? "알 수 없는 유형";

                  return GestureDetector(
                    onTap: () {
                      // RouteDetailScreen으로 전환 시 좌표 값도 전달하고 총 시간을 전달
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteDetailScreen(
                            routeIndex: index,
                            startX: widget.startX,
                            startY: widget.startY,
                            endX: widget.endX,
                            endY: widget.endY,
                            totalMinutes: totalMinutes,  // 총 시간 값을 그대로 전달
                            routeType: routeType,        // 경로 유형 전달
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: 300,
                      height: 228.37,  // 요청된 크기
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFFE75531), width: 1),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            // 경로와 시간을 시간/분 형식으로 표시하고 교통 수단을 추가
                            "경로(${index + 1}): $transportModesText (총 시간: ${formatTime(totalMinutes)}), 환승 횟수: $transferCount",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
