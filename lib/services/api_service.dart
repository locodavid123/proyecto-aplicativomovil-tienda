import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<dynamic>> fetchMeals(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['meals'] ?? [];
      } else {
        throw Exception('Fallo al cargar datos de la API');
      }
    } catch (e) {
      print('Error fetching meals: $e');
      return [];
    }
  }

  static Future<List<String>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list.php?c=list'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final meals = data['meals'] as List<dynamic>?;
        if (meals != null) {
          return meals.map((e) => e['strCategory'] as String).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
