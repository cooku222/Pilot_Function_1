import 'package:flutter/material.dart';

class RouteSummaryScreen extends StatelessWidget {
  final int routeCount;
  final List<String> routeSummaries;

  RouteSummaryScreen({required this.routeCount, required this.routeSummaries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // 뒤로 가기 버튼 없애기
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            // "n개의 경로를 찾았어요"
            Text(
              "$routeCount개의\n경로를 찾았어요",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold, // displaybold
              ),
            ),
            SizedBox(height: 20),
            // 경로 요약 블록들
            Expanded(
              child: ListView.builder(
                itemCount: routeCount,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: 300,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFE75531), width: 2),
                    ),
                    child: Center(
                      child: Text(
                        "경로(${index + 1}): ${routeSummaries[index]}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
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
