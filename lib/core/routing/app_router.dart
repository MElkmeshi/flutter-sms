import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sms/domain/model/action_item.dart';
import 'package:sms/domain/model/category.dart';
import 'package:sms/domain/model/service_provider.dart';
import 'package:sms/features/sms_commands/category_list/ui/category_list_screen.dart';
import 'package:sms/features/sms_commands/provider_list/ui/provider_list_screen.dart';
import 'package:sms/features/sms_commands/action_list/ui/action_list_screen.dart';
import 'package:sms/features/sms_commands/form/ui/form_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: CategoryListRoute.page, initial: true),
    AutoRoute(page: ProviderListRoute.page),
    AutoRoute(page: ActionListRoute.page),
    AutoRoute(page: FormRoute.page),
  ];
}
