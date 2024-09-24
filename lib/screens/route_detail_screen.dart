import 'package:flutter/material.dart';

class RouteDetailScreen extends StatelessWidget {
  final int routeIndex;
  final String routeDetail;

  RouteDetailScreen({required this.routeIndex, required this.routeDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경을 흰색으로 설정
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true, // 뒤로 가기 버튼 추가
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            // 경로(n) 상세 정보 (검정 볼드체)
            Text(
              "경로($routeIndex) 상세 정보",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold, // displayBold
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            // 경로(n) 상세 정보 (회색, 왼쪽 정렬, displayBold 20)
            Text(
              routeDetail,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold, // displayBold
                color: Colors.grey,
              ),
            ),
            Spacer(),
            // 경로 안내하기 버튼
            Center(
              child: SizedBox(
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
                    // 경로 안내 로직
                  },
                  child: Text(
                    "경로 안내하기",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600, // Semibold
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
