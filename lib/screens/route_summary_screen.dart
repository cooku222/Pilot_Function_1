import 'package:flutter/material.dart';

class RouteSummaryScreen extends StatefulWidget {
  final int routeCount;
  final List<String> routeSummaries;

  RouteSummaryScreen({required this.routeCount, required this.routeSummaries});

  @override
  _RouteSummaryScreenState createState() => _RouteSummaryScreenState();
}

class _RouteSummaryScreenState extends State<RouteSummaryScreen> {
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
                  return GestureDetector(
                    onTap: () {
                      // 경로 상세 화면으로 이동 (필요시 구현)
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
                            "경로(${index + 1}): ${widget.routeSummaries[index]}",
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
