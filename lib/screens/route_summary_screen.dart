import 'package:flutter/material.dart';
import 'package:route/services/api_service.dart';

class RouteSummaryScreen extends StatefulWidget {
  final int routeCount;
  final List<String> routeSummaries;

  RouteSummaryScreen({required this.routeCount, required this.routeSummaries}); // 생성자에서 routeCount와 routeSummaries 받음

  @override
  _RouteSummaryScreenState createState() => _RouteSummaryScreenState();
}

class _RouteSummaryScreenState extends State<RouteSummaryScreen> {
  ApiService apiService = ApiService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRoutes();
  }

  Future<void> fetchRoutes() async {
    try {
      var routeData = await apiService.fetchRoute();
      print('API 호출 성공: $routeData');
      setState(() {
        // routeSummaries 데이터를 업데이트하거나 필요에 따라 작업
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorMessage(e.toString());
    }
  }

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
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.routeCount}개의 경로를 찾았어요",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.routeCount,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // 상세 화면으로 이동
                    },
                    child: Container(
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
                          "경로(${index + 1}): ${widget.routeSummaries[index]}",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
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
