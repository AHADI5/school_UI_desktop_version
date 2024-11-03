import 'package:logger/logger.dart';
import 'package:school_desktop/features/parents/models/parent.dart';
import 'package:school_desktop/utils/authed_request.dart';

class ParentService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final Logger logger = Logger();

  // Fetches a list of parents from the server
  Future<List<Parent>?> fetchParents(String url) async {
    final response = await _httpClient.authenticatedGet(url);
    logger.i("Fetch parents response: $response from $url");

    if (response != null) {
      return List<Parent>.from(
        response.map((json) => Parent.fromJson(json)),
      );
    }

    return null;
  }
}