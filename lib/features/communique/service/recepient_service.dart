import 'package:http/http.dart' as http;
import 'package:school_desktop/features/communique/model/recipients.dart';
import 'package:school_desktop/utils/authed_request.dart';
import 'package:logger/logger.dart';

class SectionService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final Logger logger = Logger();

  // Fetches a list of sections from the server
  Future<List<Section>?> fetchSections(String url) async {
    final response = await _httpClient.authenticatedGet(url);
    if (response != null) {
      return List<Section>.from(response.map((json) => Section.fromJson(json)));
    }
    return null;
  }

  // Fetches a single section by ID
  Future<Section?> fetchSectionById(String url, int sectionID) async {
    final response = await _httpClient.authenticatedGet('$url/$sectionID');
    if (response != null) {
      return Section.fromJson(response);
    }
    return null;
  }

  // Creates a new section
  Future<Section?> createSection(String url, Section section) async {
    final response = await _httpClient.authenticatedPost(url, section.toJson());
    logger.i("Create section request sent");

    if (response != null) {
      return Section.fromJson(response);
    }
    return null;
  }

  // Updates an existing section
  Future<Section?> updateSection(String url, Section section) async {
    final response = await _httpClient.authenticatedPut('$url/${section.sectionID}', section.toJson());
    if (response != null) {
      return Section.fromJson(response);
    }
    return null;
  }

  // Deletes a section
  Future<bool> deleteSection(String url, int sectionID) async {
    final token = await _httpClient.retrieveToken();
    if (token == null || await _httpClient.isTokenValid()) {
      return false;
    }

    final response = await http.delete(
      Uri.parse('$url/$sectionID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 204; // Assuming 204 No Content for successful deletion
  }
}
