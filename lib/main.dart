import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';  // config.dart에서 API Key를 불러옴

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _departureController,
              hintText: "출발",
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _arrivalController,
              hintText: "도착",
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTransportButton("지하철"),
                _buildTransportButton("버스"),
              ],
            ),
            Spacer(),
            SizedBox(
              width: 304,
              height: 64,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE75531),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(39),
                  ),
                ),
                onPressed: () async {
                  String departure = _departureController.text;
                  String arrival = _arrivalController.text;

                  try {
                    List<String> routeSummaries =
                    await _fetchTmapRoutes(departure, arrival);

                  } catch (error) {
                    print("Error: $error");
                  }
                },
                child: Text(
                  "경로 찾기",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
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


  Future<List<String>> _fetchTmapRoutes(String departure, String arrival) async {
    const String tmapUrl = 'https://apis.openapi.sk.com/transit/routes';

    final response = await http.post(
      Uri.parse(tmapUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'appKey': 'YEWVxfrK4j8xTNQZURJ4z1Te4JTZs26v45fgmfn7',  // 실제 API Key로 변경
      },
      body: jsonEncode({
        'startX': '126.926493082645',
        'startY': '37.6134436427887',
        'endX': '127.126936754911',
        'endY': '37.5004198786564',
        'lang': 0,
        'format': 'json',
        'count': 10,
        'searchDttm': '202301011200'
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<String> routeSummaries = [];
      // metadata/plan/legs
      // print(data['plan']['legs'])

      for (var feature in data['metaData']['plan']['itineraries']) {
        // if (feature['geometry']['type'] == 'LineString') {
          routeSummaries.add(feature['totalTime'].toString());
        // }
      }
      print(routeSummaries);
      return routeSummaries;
    } else {
      final errorData = json.decode(response.body);
      throw Exception('Tmap API 호출 실패: ${errorData['error']['message']}');
    }
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText}) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(39),
          borderSide: BorderSide(color: Color(0xFFE75531), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(39),
          borderSide: BorderSide(color: Color(0xFFE75531), width: 2),
        ),
      ),
    );
  }

  Widget _buildTransportButton(String label) {
    return SizedBox(
      width: 140,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE75531),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        onPressed: () {
          print('$label 버튼 클릭됨');
        },
        child: Text(
          label,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
