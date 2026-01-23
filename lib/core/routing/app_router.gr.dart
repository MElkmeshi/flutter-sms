// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ActionListRoute.name: (routeData) {
      final args = routeData.argsAs<ActionListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ActionListScreen(
          key: args.key,
          provider: args.provider,
          category: args.category,
        ),
      );
    },
    CategoryListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CategoryListScreen(),
      );
    },
    FormRoute.name: (routeData) {
      final args = routeData.argsAs<FormRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: FormScreen(
          key: args.key,
          action: args.action,
          provider: args.provider,
        ),
      );
    },
    ProviderListRoute.name: (routeData) {
      final args = routeData.argsAs<ProviderListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ProviderListScreen(
          key: args.key,
          category: args.category,
        ),
      );
    },
  };
}

/// generated route for
/// [ActionListScreen]
class ActionListRoute extends PageRouteInfo<ActionListRouteArgs> {
  ActionListRoute({
    Key? key,
    required ServiceProvider provider,
    required Category category,
    List<PageRouteInfo>? children,
  }) : super(
          ActionListRoute.name,
          args: ActionListRouteArgs(
            key: key,
            provider: provider,
            category: category,
          ),
          initialChildren: children,
        );

  static const String name = 'ActionListRoute';

  static const PageInfo<ActionListRouteArgs> page =
      PageInfo<ActionListRouteArgs>(name);
}

class ActionListRouteArgs {
  const ActionListRouteArgs({
    this.key,
    required this.provider,
    required this.category,
  });

  final Key? key;

  final ServiceProvider provider;

  final Category category;

  @override
  String toString() {
    return 'ActionListRouteArgs{key: $key, provider: $provider, category: $category}';
  }
}

/// generated route for
/// [CategoryListScreen]
class CategoryListRoute extends PageRouteInfo<void> {
  const CategoryListRoute({List<PageRouteInfo>? children})
      : super(
          CategoryListRoute.name,
          initialChildren: children,
        );

  static const String name = 'CategoryListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [FormScreen]
class FormRoute extends PageRouteInfo<FormRouteArgs> {
  FormRoute({
    Key? key,
    required ActionItem action,
    required ServiceProvider provider,
    List<PageRouteInfo>? children,
  }) : super(
          FormRoute.name,
          args: FormRouteArgs(
            key: key,
            action: action,
            provider: provider,
          ),
          initialChildren: children,
        );

  static const String name = 'FormRoute';

  static const PageInfo<FormRouteArgs> page = PageInfo<FormRouteArgs>(name);
}

class FormRouteArgs {
  const FormRouteArgs({
    this.key,
    required this.action,
    required this.provider,
  });

  final Key? key;

  final ActionItem action;

  final ServiceProvider provider;

  @override
  String toString() {
    return 'FormRouteArgs{key: $key, action: $action, provider: $provider}';
  }
}

/// generated route for
/// [ProviderListScreen]
class ProviderListRoute extends PageRouteInfo<ProviderListRouteArgs> {
  ProviderListRoute({
    Key? key,
    required Category category,
    List<PageRouteInfo>? children,
  }) : super(
          ProviderListRoute.name,
          args: ProviderListRouteArgs(
            key: key,
            category: category,
          ),
          initialChildren: children,
        );

  static const String name = 'ProviderListRoute';

  static const PageInfo<ProviderListRouteArgs> page =
      PageInfo<ProviderListRouteArgs>(name);
}

class ProviderListRouteArgs {
  const ProviderListRouteArgs({
    this.key,
    required this.category,
  });

  final Key? key;

  final Category category;

  @override
  String toString() {
    return 'ProviderListRouteArgs{key: $key, category: $category}';
  }
}
