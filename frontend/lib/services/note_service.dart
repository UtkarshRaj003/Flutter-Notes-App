import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class NoteService {
  // GET NOTES
  Future<Map<String, dynamic>> fetchNotes({
    required String token,
    int page = 1,
    String search = '',
    String tag = '',
    bool pinnedOnly = false,
    bool archivedOnly = false,
  }) async {
    // FIXED: ApiConstants.notes ko sahi se query params ke sath string interpolation mein dala
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.notes}'
        '?page=$page'
        '&search=$search'
        '&tag=$tag'
        '&isPinned=$pinnedOnly'
        '&isArchived=$archivedOnly',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    return jsonDecode(response.body);
  }

  // CREATE NOTE
  Future<Map<String, dynamic>> createNote({
    required String token,
    required String title,
    required String content,
    required List<String> tags,
    required bool isPinned,
    required bool isArchived,
  }) async {
    // FIXED: Direct variable pass kiya bina string literal aur $ ke jhamele ke
    final response = await http.post(
      Uri.parse(ApiConstants.notes),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'tags': tags,
        'isPinned': isPinned,
        'isArchived': isArchived,
      }),
    );

    return jsonDecode(response.body);
  }

  // UPDATE NOTE
  Future<Map<String, dynamic>> updateNote({
    required String token,
    required String noteId,
    required String title,
    required String content,
    required List<String> tags,
    required bool isPinned,
    required bool isArchived,
  }) async {
    // Yeh pehle se sahi tha, isko waise hi rehne diya
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/notes/$noteId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'tags': tags,
        'isPinned': isPinned,
        'isArchived': isArchived,
      }),
    );

    return jsonDecode(response.body);
  }

  // DELETE NOTE
  Future<void> deleteNote({
    required String token,
    required String noteId,
  }) async {
    // FIXED: Base URL ke standard structure ke sath clean format kiya
    await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/notes/$noteId'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<List<String>> fetchSuggestedTags({required String token}) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.suggestedTags),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((tag) => tag.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
