import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // API 호출 및 데이터 가져오기
  Future<List<dynamic>> fetchRoute() async {
    final url = 'https://api.example.com/route'; // 실제 API URL 사용
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // API 응답에서 'error_code' 존재 여부 체크
      if (data is Map && data.containsKey('error_code')) {
        switch (data['error_code']) {
          case 11:
            throw Exception('출발지/도착지 간 거리가 너무 가까워 경로가 없습니다.');
          case 12:
            throw Exception('출발지 정류장을 찾을 수 없습니다.');
          case 13:
            throw Exception('도착지 정류장을 찾을 수 없습니다.');
          case 14:
            throw Exception('대중교통 경로를 찾을 수 없습니다.');
          default:
            throw Exception('알 수 없는 오류가 발생했습니다.');
        }
      } else if (data is List) {
        // 정상적인 경로 데이터가 리스트 형태로 제공될 경우
        return data;
      } else {
        throw Exception('Unexpected response format');
      }
    } else if (response.statusCode == 400) {
      throw Exception('필수 입력 값 오류');
    } else if (response.statusCode == 500) {
      throw Exception('서버 오류 발생');
    } else {
      throw Exception('알 수 없는 오류 발생');
    }
  }
}
