import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiService {
  final http.Client _client;
  final String _baseUrl;

  ApiService({required this._client, this._baseUrl = ApiConfig.baseUrl});

  Future<String> get(String path) async {
    final baseUri = Uri.tryParse(_baseUrl);

    if (baseUri == null ||
        !baseUri.hasAuthority ||
        baseUri.host.isEmpty ||
        (baseUri.scheme != 'http' && baseUri.scheme != 'https')) {
      throw StateError(
        'API_BASE_URL doit être une adresse HTTP ou HTTPS valide',
      );
    }

    final uri = baseUri.resolve(path);

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    }

    throw Exception('Erreur HTTP ${response.statusCode}');
  }
}
