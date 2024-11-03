import 'package:http/http.dart' as http;
import 'package:school_desktop/features/communique/model/Communique.dart';
import 'package:school_desktop/features/communique/model/communiqueSent.dart';

import 'package:school_desktop/utils/authed_request.dart';
import 'package:logger/logger.dart';

class CommuniqueService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final Logger logger = Logger();

  // Fetches a list of communiqués from the server
  Future<List<CommuniqueResponse>?> fetchCommuniques(String url) async {
    final response = await _httpClient.authenticatedGet(url);
    logger.i("$response and $url");
    

    if (response != null) {
      return List<CommuniqueResponse>.from(
          response.map((json) => CommuniqueResponse.fromJson(json)));
    }

    return null;
  }

  // Creates a new communiqué
  Future<CommuniqueResponse?> createCommunique(String url, Message communique) async {
    final response =
        await _httpClient.authenticatedPost(url, communique.toJson());
    logger.i("Create communiqué request sent");

    if (response != null) {
      return CommuniqueResponse.fromJson(response);
    }
    return null;
  }

  // Updates an existing communiqué
  Future<CommuniqueResponse?> updateCommunique(
      String url, CommuniqueResponse communique) async {
    final response =
        await _httpClient.authenticatedPut(url, communique.toJson());
    if (response != null) {
      return CommuniqueResponse.fromJson(response);
    }
    return null;
  }

  // Deletes a communiqué
  Future<bool> deleteCommunique(String url) async {
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
