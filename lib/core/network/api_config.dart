/// Configuración de la conexión con la API.
class ApiConfig {
  ApiConfig._();

  /// Dirección base de la API. Se puede cambiar al ejecutar, sin tocar código:
  ///   flutter run --dart-define=API_URL=http://192.168.1.50:3000/api
  ///
  /// Valores típicos:
  ///   - Emulador de Android  -> http://10.0.2.2:PUERTO/api
  ///   - Celular físico       -> http://IP_DE_TU_PC:PUERTO/api
  ///   - Simulador de iOS     -> http://localhost:PUERTO/api
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://xn--apidontoo-exc8brhqcbdua6cr-orc.canadacentral-01.azurewebsites.net/api',
  );

  /// Tiempo máximo de espera por cada petición.
  static const Duration timeout = Duration(seconds: 15);
}