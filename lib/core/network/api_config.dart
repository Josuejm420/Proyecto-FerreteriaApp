/// Configuración de la conexión con la API.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue:
        'https://xn--apidontoo-exc8brhqcbdua6cr-orc.canadacentral-01.azurewebsites.net/api',
  );

  /// Tiempo máximo de espera por cada petición.
  static const Duration timeout = Duration(seconds: 30);
}
