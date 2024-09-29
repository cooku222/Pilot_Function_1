import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = 'EhDYONMDB86WyuLiJIzIo4kVcx8Ptd6c7g6SyONR';  // 여기에 실제 API 키를 넣으세요

  Future<Map<String, dynamic>> fetchRoute({
    required String startX,
    required String startY,
    required String endX,
    required String endY,
  }) async {
    final url = Uri.parse('https://apis.openapi.sk.com/transit/routes');

    // 요청 데이터
    final requestData = {
      'startX': startX,
      'startY': startY,
      'endX': endX,
      'endY': endY,
      'count': 1,
      'format': 'json'
    };

    try {
      // API 요청
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'appKey': apiKey,  // SK Open API의 appKey 헤더에 API 키 추가
        },
        body: jsonEncode(requestData),
      );

      // 응답 상태 코드 확인
      print("Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        // 성공적으로 데이터를 받아올 경우
        return jsonDecode(response.body);
      } else {
        // 오류 처리
        print("Failed to fetch data. Status code: ${response.statusCode}");
        throw Exception('Failed to load route data');
      }
    } catch (e) {
      // 예외 처리
      print('Error fetching route: $e');
      throw Exception('Failed to load route data');
    }
  }
}
