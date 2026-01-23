import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms/core/services/local_storage_service.dart';
import 'package:sms/core/services/config_service.dart';

/// Provider for LocalStorageService
/// This will be overridden in main.dart with the initialized instance
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError(
    'LocalStorageService provider must be overridden in main.dart with initialized instance',
  );
});

/// Provider for ConfigService
final configServiceProvider = Provider<ConfigService>((ref) {
  final localStorage = ref.watch(localStorageServiceProvider);
  return ConfigService(localStorage);
});
