import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = 'EhDYONMDB86WyuLiJIzIo4kVcx8Ptd6c7g6SyONR'; // Tmap API Key 입력

  // 경로 데이터를 가져오는 메서드
  Future<List<dynamic>> fetchRoute({
    required String startX,
    required String startY,
    required String endX,
    required String endY,
  }) async {
    const String tmapUrl = 'https://apis.openapi.sk.com/transit/routes';

    final response = await http.post(
      Uri.parse(tmapUrl),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'appKey': apiKey,
      },
      body: jsonEncode({
        'startX': startX,
        'startY': startY,
        'endX': endX,
        'endY': endY,
        'lang': 0,
        'format': 'json',
        'count': 10,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      if (data['result'] != null && data['result']['message'] != null) {
        throw Exception('${data['result']['message']}');
      }

      return data['metaData']['plan']['itineraries']; // 경로 리스트 반환
    } else {
      final errorData = json.decode(utf8.decode(response.bodyBytes));
      throw Exception('Tmap API 호출 실패: ${errorData['result']['message']}');
    }
  }
}
