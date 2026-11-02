import 'package:get_it/get_it.dart';

import '../../presentation/providers/auth_provider.dart';
import '../../services/auth_service.dart';

/// Contenedor de dependencias (get_it). Aquí se crea cada pieza una sola vez.
final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  if (!getIt.isRegistered<AuthService>()) {
    getIt.registerLazySingleton<AuthService>(() => AuthService());
  }

  if (!getIt.isRegistered<AuthProvider>()) {
    getIt.registerLazySingleton<AuthProvider>(
      () => AuthProvider(getIt<AuthService>()),
    );
  }
}