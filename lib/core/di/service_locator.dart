import 'package:get_it/get_it.dart';

import '../../data/repositories/auth_repository.dart';
import '../../presentation/providers/auth_provider.dart';
import '../network/api_client.dart';

/// Contenedor de dependencias (get_it). Aquí se crea cada pieza una sola vez.
final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  // Red
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Repositorios (hablan con la API)
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<ApiClient>()),
  );

  // Providers (estado que usan las pantallas)
  getIt.registerLazySingleton<AuthProvider>(
    () => AuthProvider(getIt<AuthRepository>()),
  );
}