import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../errors/api_exception.dart';
import 'api_config.dart';


class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String? _token;

  
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

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) {
    final uri = _uri(path, query);
    return _send('GET', uri, () => _client.get(uri, headers: _headers));
  }

  Future<dynamic> post(String path, {Object? body}) {
    final uri = _uri(path);
    return _send(
      'POST',
      uri,
      () => _client.post(uri, headers: _headers, body: jsonEncode(body)),
    );
  }

  Future<dynamic> put(String path, {Object? body}) {
    final uri = _uri(path);
    return _send(
      'PUT',
      uri,
      () => _client.put(uri, headers: _headers, body: jsonEncode(body)),
    );
  }

  Future<dynamic> delete(String path) {
    final uri = _uri(path);
    return _send('DELETE', uri, () => _client.delete(uri, headers: _headers));
  }

  
  Future<dynamic> _send(
    String method,
    Uri uri,
    Future<http.Response> Function() request,
  ) async {
    debugPrint('>>> $method $uri');
    try {
      final response = await request().timeout(ApiConfig.timeout);
      debugPrint('<<< ${response.statusCode} $uri');
      return _handle(response);
    } on TimeoutException catch (e) {
      debugPrint('!!! TimeoutException en $uri: $e');
      throw const ApiException('El servidor tardó demasiado en responder');
    } on SocketException catch (e) {
      debugPrint('!!! SocketException en $uri: $e');
      throw const ApiException('No se pudo conectar con el servidor');
    } on http.ClientException catch (e) {
      debugPrint('!!! ClientException en $uri: $e');
      throw const ApiException('No se pudo conectar con el servidor');
    } on FormatException catch (e) {
      debugPrint('!!! FormatException en $uri: $e');
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
      
        data = text;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) return data;

    debugPrint('!!! Respuesta de error ${response.statusCode}: $text');
    throw ApiException(
      _errorMessage(data, response.statusCode),
      statusCode: response.statusCode,
    );
  }

  String _errorMessage(dynamic data, int statusCode) {
    
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
