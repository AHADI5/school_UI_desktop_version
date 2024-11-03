import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';

class AuthenticatedHttpClient {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _tokenKey = 'jwt_token';
  final Logger _logger = Logger();

  // Retrieves the token from storage
  Future<String?> retrieveToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Checks if the token is valid
  Future<bool> isTokenValid() async {
    final token = await retrieveToken();
    return token != null && !JwtDecoder.isExpired(token);
  }

// Makes an authenticated GET request
  Future<dynamic> authenticatedGet(String url) async {
    _logger.i("Starting GET request to $url");

    final token = await retrieveToken();
    if (token == null) {
      _logger.i("Error: No token found.");
      return null;
    }
    
    _logger.i("Token retrieved successfully. Verifying if expired...");

    if (JwtDecoder.isExpired(token)) {
      _logger.i("Error: The token is expired.");
      return null;
    }

    _logger.i("Token is valid. Sending GET request to the server...");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        _logger.i("Request successful. Data received.");
        return jsonDecode(response.body);
      } else {
        _logger.i("Request failed with status code: ${response.statusCode}");
        _logger.i("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      _logger.i("Error occurred during GET request: $e");
      return null;
    }
  }

  // Makes an authenticated POST request
  Future<dynamic> authenticatedPost(
      String url, Map<String, dynamic> body) async {
    final token = await retrieveToken();
    if (token == null || JwtDecoder.isExpired(token)) {
      return null; // or throw an exception based on your error handling strategy
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      // Handle error based on status code or response
      _logger.i("response code  is ${response.statusCode}");

      return null;
    }
  }

  // Makes an authenticated PUT request
  Future<dynamic> authenticatedPut(
      String url, Map<String, dynamic> body) async {
    final token = await retrieveToken();
    if (token == null || JwtDecoder.isExpired(token)) {
      return null; // or throw an exception based on your error handling strategy
    }

    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      // Handle error based on status code or response
      return null;
    }
  }
}
