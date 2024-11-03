import 'package:school_desktop/features/discipline/model/discipline.dart';
import 'package:school_desktop/features/discipline/model/rules_request.dart';
import 'package:school_desktop/utils/authed_request.dart';
import 'package:logger/logger.dart';

class RuleRequestService {
  final AuthenticatedHttpClient _httpClient = AuthenticatedHttpClient();
  final Logger logger = Logger();

  // Fetches a list of rule requests from the server
  Future<List<Rule>?> fetchRules(String url) async {
    final response = await _httpClient.authenticatedGet(url);
    if (response != null) {
      logger.i("Fetched rules successfully.");
      return List<Rule>.from(response.map((json) => Rule.fromJson(json)));
    }
    logger.w("Failed to fetch rules.");
    return null;
  }

  // Creates a new rule request
  Future<RuleRequest?> createRule(String url, RuleRequest ruleRequest) async {
    final response = await _httpClient.authenticatedPost(url, ruleRequest.toJson());
    logger.i("Create rule request sent.");

    if (response != null) {
      logger.i("Rule created successfully.");
      return RuleRequest.fromJson(response);
    }
    logger.w("Failed to create rule.");
    return null;
  }

  // Updates an existing rule request
  Future<RuleRequest?> updateRule(String url, RuleRequest ruleRequest) async {
    final response = await _httpClient.authenticatedPut(url, ruleRequest.toJson());
    if (response != null) {
      logger.i("Rule updated successfully.");
      return RuleRequest.fromJson(response);
    }
    logger.w("Failed to update rule.");
    return null;
  }

  // Deletes a rule request
  // Future<bool> deleteRule(String url) async {
  //   final token = await _httpClient.retrieveToken();
  //   if (token == null || !await _httpClient.isTokenValid()) {
  //     logger.w("Invalid or missing token. Unable to delete rule.");
  //     return false;
  //   }

  //   final response = await http.delete(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 204) {
  //     logger.i("Rule deleted successfully.");
  //     return true;
  //   } else {
  //     logger.w("Failed to delete rule. Status code: ${response.statusCode}");
  //     return false;
  //   }
  // }
}
