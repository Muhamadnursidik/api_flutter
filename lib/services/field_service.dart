import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api_flutter/models/field_model.dart';

class FieldService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/field';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get all fields
  static Future<Field> getFields() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Field.fromJson(json);
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

    static Future<bool> createField(
    String name,
    int locationId,
    String type,
    int pricePerHour,
    String description,
    Uint8List? imageBytes,
    String? imageName,
  ) async {
    final token = await getToken();
    final uri = Uri.parse(baseUrl);
    final request = http.MultipartRequest('POST', uri);

    request.fields['name'] = name;
    request.fields['location_id'] = locationId.toString();
    request.fields['type'] = type;
    request.fields['price_per_hour'] = pricePerHour.toString();
    request.fields['description'] = description;

    if (imageBytes != null && imageName != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'img',
          imageBytes,
          filename: imageName,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();
    return response.statusCode == 201;
  }

  // Update field
static Future<bool> updateField(
  int id,
  String name,
  int locationId,
  String type,
  int pricePerHour,
  String description,
  Uint8List? imageBytes,
  String? imageName,
) async {
  final token = await getToken();
  final uri = Uri.parse('$baseUrl/$id');
  final request = http.MultipartRequest('POST', uri); // kalau API update pakai POST+_method=PUT

  request.fields['_method'] = 'PUT'; // Laravel method spoofing
  request.fields['name'] = name;
  request.fields['location_id'] = locationId.toString();
  request.fields['type'] = type;
  request.fields['price_per_hour'] = pricePerHour.toString();
  request.fields['description'] = description;

  if (imageBytes != null && imageName != null) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'img',
        imageBytes,
        filename: imageName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );
  }

  request.headers['Authorization'] = 'Bearer $token';

  final response = await request.send();
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

  static Future<void> updateFieldDetails(int id, DataField field) async {
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
