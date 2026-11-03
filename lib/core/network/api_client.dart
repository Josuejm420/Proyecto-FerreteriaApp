import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../errors/api_exception.dart';
import 'api_config.dart';

/// Cliente HTTP único de la app. Todos los repositorios lo usan para hablar
/// con la API: agrega el token, convierte JSON y traduce los errores.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String? _token;

  /// Guarda (o borra con null) el token que se envía en cada petición.
  void setToken(String? token) => _token = token;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    if (query == null || query.isEmpty) return uri;
    return uri.replace(
      queryParameters: query.map((key, value) => MapEntry(key, '$value')),
    );
  }

  // --- Métodos públicos ---
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) {
    return _send(() => _client.get(_uri(path, query), headers: _headers));
  }

  Future<dynamic> post(String path, {Object? body}) {
    return _send(
      () => _client.post(_uri(path), headers: _headers, body: jsonEncode(body)),
    );
  }

  Future<dynamic> put(String path, {Object? body}) {
    return _send(
      () => _client.put(_uri(path), headers: _headers, body: jsonEncode(body)),
    );
  }

  Future<dynamic> delete(String path) {
    return _send(() => _client.delete(_uri(path), headers: _headers));
  }

  // --- Interno ---
  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(ApiConfig.timeout);
      return _handle(response);
    } on TimeoutException {
      throw const ApiException('El servidor tardó demasiado en responder');
    } on SocketException {
      throw const ApiException('No se pudo conectar con el servidor');
    } on http.ClientException {
      throw const ApiException('No se pudo conectar con el servidor');
    } on FormatException {
      throw const ApiException('El servidor respondió algo inesperado');
    }
  }

  dynamic _handle(http.Response response) {
    final text = utf8.decode(response.bodyBytes);
    dynamic data;
    if (text.isNotEmpty) {
      try {
        data = jsonDecode(text);
      } on FormatException {
        // Algunos endpoints responden texto plano al guardar correctamente.
        data = text;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) return data;

    throw ApiException(
      _errorMessage(data, response.statusCode),
      statusCode: response.statusCode,
    );
  }

  String _errorMessage(dynamic data, int statusCode) {
    // Si la API manda su propio mensaje, se usa ese.
    if (data is String && data.trim().isNotEmpty) return data.trim();

    if (data is Map) {
      final message = data['message'] ?? data['mensaje'] ?? data['error'];
      if (message is String && message.isNotEmpty) return message;
    }

    return switch (statusCode) {
      401 => 'No autorizado',
      403 => 'No tienes permiso para esta acción',
      404 => 'No se encontró lo que buscas',
      >= 500 => 'Error en el servidor, intenta más tarde',
      _ => 'Error inesperado ($statusCode)',
    };
  }
}
