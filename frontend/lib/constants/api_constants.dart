class ApiConstants {
  // static const String baseUrl = 'http://192.168.1.3:5000/api';
  static const String baseUrl = 'https://notes-api-eg33.onrender.com/api';

  
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';


  static const String profile = '$baseUrl/auth/profile';
  static const String notes = '$baseUrl/notes';
  static const String allTags = '$baseUrl/tags/';
  static const String suggestedTags = '$baseUrl/tags/suggested';
}
