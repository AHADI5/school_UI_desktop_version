import 'package:http/http.dart' as http;
import 'package:school_desktop/features/students/models/student_information.dart';
import 'package:school_desktop/features/students/student_form.dart';
import 'package:school_desktop/utils/authed_request.dart';
import 'package:logger/logger.dart';

class StudentService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final Logger logger = Logger();

  // Fetches a list of StudentInfo from the server
  Future<List<StudentInfo>?> fetchStudents(String url) async {
    final response = await _httpClient.authenticatedGet(url);
    logger.i("$response and $url");

    if (response != null) {
      return List<StudentInfo>.from(
          response.map((json) => StudentInfo.fromJson(json)));
    }

    return null;
  }

  // Creates a new student
  Future<dynamic> createStudent(String url, Students student) async {
    final response = await _httpClient.authenticatedPost(url, student.toJson());
    logger.i("Create student request sent");
    logger.i("with this data ${student.toJson()}");

    if (response != null) {
      return "Success";
    }
    return null;
  }

  // Updates an existing student
  Future<StudentInfo?> updateStudent(String url, Students student) async {
    final response = await _httpClient.authenticatedPut(url, student.toJson());
    if (response != null) {
      return StudentInfo.fromJson(response);
    }
    return null;
  }

  // Deletes a student
  Future<bool> deleteStudent(String url) async {
    final token = await _httpClient.retrieveToken();
    if (token == null || await _httpClient.isTokenValid()) {
      return false;
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
