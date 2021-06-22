import 'dart:convert';

import 'package:http/http.dart';

class ApiService {
  const ApiService(this.client);

  final Client client;
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  Future<Map<String, dynamic>> getCharacters(int page) async {
    final Uri url = Uri.parse('$baseUrl/character/?page=$page');

    try {
      final Response response = await client.get(url);

      final decodedData = json.decode(response.body);

      if (decodedData is Map<String, dynamic>) {
        return decodedData;
      } else {
        throw Exception('Ocurrió un error en el servidor');
      }
    } catch (e) {
      rethrow;
    }
  }
}
