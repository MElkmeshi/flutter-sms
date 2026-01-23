import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms/domain/model/category.dart';
import 'package:sms/core/initializer/app_providers.dart';

/// Controller for managing the category list state
/// Loads categories from config service and provides refresh functionality
class CategoryListController extends AsyncNotifier<List<Category>> {
  /// Static provider following the convention pattern
  static final provider = AsyncNotifierProvider<CategoryListController, List<Category>>(
    CategoryListController.new,
  );

  @override
  Future<List<Category>> build() async {
    // Load categories from config service
    final configService = ref.watch(configServiceProvider);
    return configService.fetchCategories();
  }

  /// Refresh the category list
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final configService = ref.read(configServiceProvider);
      return configService.fetchCategories();
    });
  }
}
