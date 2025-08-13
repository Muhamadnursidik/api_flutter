import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api_flutter/models/field_model.dart';

class FieldService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/field';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

// Get all fields
static Future<List<Field>> getFields() async {
  final token = await getToken();
  final response = await http.get(
    Uri.parse(baseUrl),
    headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final List<dynamic> fieldsJson = data['data'];

    return fieldsJson.map((json) => Field.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load fields');
  }
}


  // Get single field
  static Future<Field> showField(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Field.fromJson(data['data']);
    } else {
      throw Exception('Failed to load field');
    }
  }

  // Create field
  static Future<bool> createField(
    String name,
    String location,
    double price,
    String description,
  ) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'name': name,
        'location': location,
        'price': price,
        'description': description,
      }),
    );

    return response.statusCode == 201;
  }

  // Update field
  static Future<bool> updateField(
    int id,
    String name,
    String location,
    double price,
    String description,
  ) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'name': name,
        'location': location,
        'price': price,
        'description': description,
      }),
    );

    return response.statusCode == 200;
  }

  // Delete field
  static Future<bool> deleteField(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  static Future<void> updateFieldDetails(int id, Field field) async {
  final response = await http.put(
    Uri.parse('http://127.0.0.1:8000/api/fields/$id'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': field.name,
      'type': field.type,
      'price_per_hour': field.pricePerHour,
      'img': field.img,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal update lapangan');
  }
}

}
