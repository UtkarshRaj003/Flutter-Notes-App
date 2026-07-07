import 'dart:convert';
import 'package:frontend/constants/api_constants.dart';

import 'api_service.dart'; // Aapki ApiService class ka path

class TagService {
  final ApiService _apiService = ApiService();
  // final String baseUrl = ApiConstants.baseUrl; // Apni actual base URL yahan dalein

  // 1. Fetch All Tags
  Future<List<String>> getAllTags(String token) async {
    try {
      final response = await _apiService.getRequest(ApiConstants.allTags, token);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((tag) => tag.toString()).toList();
      } else {
        throw Exception('Failed to load all tags: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching all tags: $e');
    }
  }

  // 2. Fetch Suggested Tags
  Future<List<String>> getSuggestedTags(String token) async {
    try {
      final response = await _apiService.getRequest(ApiConstants.suggestedTags, token);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((tag) => tag.toString()).toList();
      } else {
        throw Exception('Failed to load suggested tags: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching suggested tags: $e');
    }
  }
}