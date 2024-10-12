import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:school_desktop/utils/constants.dart';

import '../model/user.dart';

class AuthService {
  // Singleton instance
  static final AuthService _instance = AuthService._internal();

  // Private constructor for Singleton pattern
  AuthService._internal();

  // Factory constructor to return the same instance
  factory AuthService() {
    return _instance;
  }

  // Secure storage for storing JWT token
  final _storage = const FlutterSecureStorage();

  // Keys for storing data in FlutterSecureStorage
  final String _tokenKey = 'jwt_token';
  final String _schoolIDKey = 'school_id';
  final String _deviceKey = 'device_key';

  // Base URL for API requests (Replace with your backend's base URL)

  // ----------------------------- Auth Methods -----------------------------

  /// Login method: Authenticate the user with email and password.
  /// Sends a POST request to the login endpoint along with the device key and stores the JWT token.
  Future<bool> login(User user) async {
    final url = Uri.parse('$authUrl/authenticate');
    print(url);

    // Generate or retrieve the device key for Firebase notifications
    // String? deviceKey = await getDeviceKey();
    // deviceKey ??= await generateDeviceKey();

    // Create the login payload using the User model
    final payload = {
      'email': user.email,
      'password': user.password,
      // 'deviceKey': deviceKey, // Include device key in the login payload
    };

    // Send the login request
    final response = await http.post(url, body: jsonEncode(payload), headers: {
      'Content-Type': 'application/json',
    });

    print(response.statusCode);

    if (response.statusCode == 200) {
      // Extract JWT token from response
      final data = jsonDecode(response.body);
      final String token = data['token'];
      final int schoolID = data['schoolID'];

      print('the schoolID has been retrieved successfully $schoolID');

      // Store the token securely
      await _storeToken(token);

      // Store the schoolID , in order to come back to it later
      await _storeSchoolID(schoolID);

      return true;
    }

    return false;
  }

  /// Logout method: Clears the JWT token from secure storage.
  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Account info method: Retrieves the user's account information using the stored JWT token.
  /// Sends a GET request to the account info endpoint.
  Future<Map<String, dynamic>?> getAccountInfo() async {
    const token = ();

    final url = Uri.parse('$authUrl/account-info');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  // ----------------------------- Token Methods -----------------------------

  /// Store the JWT token securely using FlutterSecureStorage.
  Future<void> _storeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> _storeSchoolID(int schoolID) async {
    await _storage.write(key: _schoolIDKey, value: schoolID.toString());
  }

  /// Retrieve the JWT token from secure storage.
  Future<String?> retrieveToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Retrieve the SchooliD from secure storage.
  Future<String?> retrieveSchoolID() async {
    return await _storage.read(key: _schoolIDKey);
  }

  /// Verify if the JWT token is valid and not expired.
  Future<bool> isTokenValid() async {
    final token = await retrieveToken();
    if (token == null || JwtDecoder.isExpired(token)) {
      return false;
    }
    return true;
  }

  /// Check if the user is authenticated by verifying the token.
  Future<bool> isAuthenticated() async {
    return await isTokenValid();
  }

  // ----------------------------- Firebase Device Key Methods -----------------------------

  /// Generate a unique device key for Firebase notifications.
  /// This method retrieves the Firebase token and stores it securely.
  // Future<String?> generateDeviceKey() async {
  //   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  //   try {
  //     final deviceKey = await firebaseMessaging.getToken();
  //     if (deviceKey != null) {
  //       await _storage.write(key: _deviceKey, value: deviceKey);
  //       return deviceKey;
  //     }
  //   } catch (e) {
  //     // Handle any errors (e.g., permission issues, connectivity problems)
  //     print('Error generating device key: $e');
  //   }

  //   return null;
  // }

  /// Retrieve the device key from secure storage.
  Future<String?> getDeviceKey() async {
    return await _storage.read(key: _deviceKey);
  }

  /// Get user information from the token
}
