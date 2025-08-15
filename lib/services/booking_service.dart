import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api_flutter/models/booking_model.dart';

class BookingService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/booking';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get all bookings
  static Future<Booking> getBookings() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Booking.fromJson(json);
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  // Get single booking
static Future<Booking> getBooking() async {
  final response = await http.get(Uri.parse(baseUrl));
  final jsonData = jsonDecode(response.body);
  return Booking.fromJson(jsonData);
}

  // Create booking
  static Future<bool> createBooking({
    required int fieldId,
    required String startTime,
    required String endTime,
    required String status,
  }) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'field_id': fieldId,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
      }),
    );

    return response.statusCode == 201;
  }

  // Update booking
  static Future<bool> updateBooking({
    required int id,
    required int fieldId,
    required String startTime,
    required String endTime,
    required String status,
  }) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'field_id': fieldId,
        'start_time': startTime,
        'end_time': endTime,
        'status': status,
      }),
    );

    return response.statusCode == 200;
  }

  // Delete booking
  static Future<bool> deleteBooking(int id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {HttpHeaders.authorizationHeader: 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}
