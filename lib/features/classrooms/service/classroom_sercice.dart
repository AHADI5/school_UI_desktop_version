import 'package:http/http.dart' as http;
import 'package:school_desktop/features/classrooms/model/class_room.dart';
import 'package:school_desktop/utils/authed_request.dart';
import 'package:logger/logger.dart';

class ClassroomService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final Logger logger = Logger();

  // Fetches a list of Classroom from the server
  Future<List<Classroom>?> fetchClassrooms(String url) async {
    final response = await _httpClient.authenticatedGet(url);
    logger.i("Fetch classrooms response: $response, URL: $url");

    if (response != null) {
      return List<Classroom>.from(
          response.map((json) => Classroom.fromJson(json)));
    }
    return null;
  }

  // Creates a new classroom
  Future<Classroom?> createClassroom(String url, Classroom classroom) async {
    final response = await _httpClient.authenticatedPost(url, classroom.toJson());
    logger.i("Create classroom request sent with data: ${classroom.toJson()}");

    if (response != null) {
      return Classroom.fromJson(response);
    }
    return null;
  }

  // Updates an existing classroom
  Future<Classroom?> updateClassroom(String url, Classroom classroom) async {
    final response = await _httpClient.authenticatedPut(url, classroom.toJson());
    logger.i("Update classroom request sent with data: ${classroom.toJson()}");

    if (response != null) {
      return Classroom.fromJson(response);
    }
    return null;
  }

  // Deletes a classroom
  Future<bool> deleteClassroom(String url) async {
    final token = await _httpClient.retrieveToken();
    if (token == null || await _httpClient.isTokenValid() == false) {
      return false;
    }

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    logger.i("Delete classroom response: ${response.statusCode}");

    return response.statusCode == 204; // Assuming 204 No Content for successful deletion
  }
}
