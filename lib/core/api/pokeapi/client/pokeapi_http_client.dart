import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../network/remote_response.dart';

final class PokeApiHttpClient {
  PokeApiHttpClient({
    required http.Client client,
    String baseUrl = 'https://pokeapi.co/api/v2',
  })  : _client = client,
        _baseUrl = baseUrl;

  final http.Client _client;
  final String _baseUrl;

  Future<PokeApiRemoteResponse<Map<String, dynamic>>> getJson(
      String path, {
        Map<String, String>? queryParameters,
      }) async {
    final uri = Uri.parse('$_baseUrl$path').replace(
      queryParameters: queryParameters,
    );

    try {
      final response = await _client.get(uri);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return PokeApiFailure(
          error: PokeApiNetworkError(
            message: 'HTTP ${response.statusCode} for GET $uri',
          ),
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return const PokeApiFailure(
          error: PokeApiParsingError(message: 'Expected JSON object at root'),
        );
      }

      return PokeApiSuccess(decoded);
    } on http.ClientException catch (e, st) {
      return PokeApiFailure(
        error: PokeApiNetworkError(message: e.message),
        stackTrace: st,
      );
    } on FormatException catch (e, st) {
      return PokeApiFailure(
        error: PokeApiParsingError(message: e.message),
        stackTrace: st,
      );
    } catch (e, st) {
      return PokeApiFailure(
        error: PokeApiUnknownError(message: e.toString()),
        stackTrace: st,
      );
    }
  }
}