import 'package:get_it/get_it.dart';
import 'package:app/core/api/api_client.dart';

final GetIt getIt = GetIt.instance;

void setupDi() {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
}
