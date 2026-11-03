import 'package:get_it/get_it.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/categories_repository.dart';
import '../../presentation/providers/auth_provider.dart';
import '../network/api_client.dart';

/// Contenedor de dependencias (get_it). Aquí se crea cada pieza una sola vez.
final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  if (!getIt.isRegistered<ApiClient>()) {
    getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  }

  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<ApiClient>()),
    );
  }

  if (!getIt.isRegistered<AuthProvider>()) {
    getIt.registerLazySingleton<AuthProvider>(
      () => AuthProvider(getIt<AuthRepository>()),
    );
  }

  if (!getIt.isRegistered<CategoriesRepository>()) {
    getIt.registerLazySingleton<CategoriesRepository>(
      () => CategoriesRepository(getIt<ApiClient>()),
    );
  }
}