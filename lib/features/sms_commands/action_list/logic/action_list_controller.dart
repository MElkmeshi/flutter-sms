import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sms/domain/model/action_item.dart';
import 'package:sms/domain/model/service_provider.dart';

/// Parameters for the ActionListController family provider
@immutable
class ActionListParams extends Equatable {
  const ActionListParams({required this.provider});

  final ServiceProvider provider;

  @override
  List<Object?> get props => [provider];
}

/// Controller for managing action list for a specific provider
/// Uses FamilyNotifier to maintain separate state for each provider
class ActionListController
    extends FamilyNotifier<List<ActionItem>, ActionListParams> {
  /// Static provider following the convention pattern
  static final provider = NotifierProvider.family<ActionListController,
      List<ActionItem>, ActionListParams>(
    ActionListController.new,
  );

  @override
  List<ActionItem> build(ActionListParams arg) {
    // Simply return the actions from the provider
    return arg.provider.actions;
  }
}
