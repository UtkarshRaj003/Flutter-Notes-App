import 'package:flutter/material.dart';
import 'package:frontend/services/tag_service.dart';

class TagProvider with ChangeNotifier {
  final TagService _tagService = TagService();

  List<String> _tags = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedTag = ''; // Filter state ko bhi yahan manage kar sakte hain

  // Getters
  List<String> get tags => _tags;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get selectedTag => _selectedTag;

  // Selected Tag ko update karne ke liye
  void selectTag(String tag) {
    _selectedTag = tag;
    notifyListeners();
  }

  // Method to fetch tags (Type decide karega: 'all' ya 'suggested')
  Future<void> fetchTags({required String token, String type = 'all'}) async {
    _isLoading = true;
    _errorMessage = '';
    // notifyListeners() turant call nahi kar sakte initState me, isliye safe check
    WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());

    try {
      if (type == 'suggested') {
        _tags = await _tagService.getSuggestedTags(token);
      } else {
        _tags = await _tagService.getAllTags(token);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}