import 'package:http/http.dart' as http;

class ApiService {
  Future<http.Response> getRequest(String url, String token) async {
    return await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> postRequest(String url, String token) async {
    return await http.post(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> putRequest(String url, String token) async {
    return await http.put(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> deleteRequest(String url, String token) async {
    return await http.delete(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
