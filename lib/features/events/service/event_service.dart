import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:school_desktop/features/events/models/event_model.dart';
import 'package:school_desktop/utils/authed_request.dart';
import 'package:logger/logger.dart';

class EventService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final Logger logger = Logger();

  // Fetches a list of appointments from the server
  Future<List<Event>?> fetchAppointments(String url) async {
    final response = await _httpClient.authenticatedGet(url);
    if (response != null) {
      return List<Event>.from(response.map((json) => Event.fromJson(json)));
    }
    return null;
  }

  // Creates a new appointment
  Future<Event?> createAppointment(String url, Event appointment) async {
    final response =
        await _httpClient.authenticatedPost(url, appointment.toJson());
    logger.i("Create event request sent");

    if (response != null) {
      return Event.fromJson(response);
    }
    return null;
  }

  // Updates an existing appointment
  Future<Event?> updateAppointment(String url, Event appointment) async {
    final response =
        await _httpClient.authenticatedPut(url, appointment.toJson());
    if (response != null) {
      return Event.fromJson(response);
    }
    return null;
  }

  // Deletes an appointment
  Future<bool> deleteAppointment(String url) async {
    final token = await _httpClient
        .retrieveToken(); // Use the private method for retrieving the token
    if (token == null || await _httpClient.isTokenValid()) {
      return false; // or handle accordingly
    }

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode ==
        204; // Assuming 204 No Content for successful deletion
  }
}
