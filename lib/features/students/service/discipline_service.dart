
import 'package:school_desktop/features/students/models/student_discipline.dart';
import 'package:school_desktop/utils/authed_request.dart';
import 'package:logger/logger.dart';

class DisciplineService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final Logger logger = Logger();

  // Fetches a list of Discipline from the server
  Future<Discipline ?> fetchDisciplines(String url) async {
    final response = await _httpClient.authenticatedGet(url);
    logger.i("Fetch disciplines response: $response from $url");

    if (response != null) {
      return Discipline.fromJson(response);
          
    }

    return null;
  }

  // Creates a new discipline record
  Future<dynamic> createDiscipline(String url, Discipline discipline) async {
    final response =
        await _httpClient.authenticatedPost(url, discipline.toJson());
    logger.i("Create discipline request sent with data: ${discipline.toJson()}");

    if (response != null) {
      return "Success";
    }
    return null;
  }

  // Updates an existing discipline record
  Future<Discipline?> updateDiscipline(String url, Discipline discipline) async {
    final response =
        await _httpClient.authenticatedPut(url, discipline.toJson());
    if (response != null) {
      return Discipline.fromJson(response);
    }
    return null;
  }


}
