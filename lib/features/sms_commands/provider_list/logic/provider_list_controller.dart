import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms/domain/model/category.dart' as models;
import 'package:sms/domain/model/service_provider.dart';

/// Parameters for the ProviderListController family provider
@immutable
class ProviderListParams extends Equatable {
  const ProviderListParams({required this.category});

  final models.Category category;

  @override
  List<Object?> get props => [category];
}

/// Controller for managing provider list for a specific category
/// Uses FamilyNotifier to maintain separate state for each category
class ProviderListController
    extends FamilyNotifier<List<ServiceProvider>, ProviderListParams> {
  /// Static provider following the convention pattern
  static final provider = NotifierProvider.family<ProviderListController,
      List<ServiceProvider>, ProviderListParams>(
    ProviderListController.new,
  );

  @override
  List<ServiceProvider> build(ProviderListParams arg) {
    // Simply return the providers from the category
    return arg.category.providers;
  }
}
