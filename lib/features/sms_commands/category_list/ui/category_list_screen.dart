import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:auto_route/auto_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sms/l10n/app_localizations.dart';
import 'package:sms/core/routing/app_router.dart';
import 'package:sms/ui/widget/x_scaffold.dart';
import 'package:sms/core/initializer/app_providers.dart';
import 'package:sms/core/services/config_service.dart';
import 'package:sms/features/sms_commands/category_list/logic/category_list_controller.dart';
import 'package:sms/features/sms_commands/shared/widgets/category_list_item.dart';

@RoutePage()
class CategoryListScreen extends HookConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    // Animation controllers using hooks - auto-dispose
    final fadeController = useAnimationController(
      duration: const Duration(milliseconds: 800),
    );
    final slideController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    // Animations
    final fadeAnimation = useMemoized(
      () => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: fadeController, curve: Curves.easeInOut),
      ),
      [fadeController],
    );

    final slideAnimation = useMemoized(
      () => Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: .zero,
      ).animate(
        CurvedAnimation(parent: slideController, curve: Curves.easeOutCubic),
      ),
      [slideController],
    );

    // Run animations once on mount
    useEffect(() {
      fadeController.forward();
      slideController.forward();
      return null;
    }, const []);

    // Watch categories from controller
    final categoriesAsync = ref.watch(CategoryListController.provider);

    return XScaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: GestureDetector(
                onLongPress: () => _showConfigUrlDialog(context, ref),
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Text(
                    l10n.appTitle,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 24,
                      fontWeight: .bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      colorScheme.primaryContainer.withAlpha(76),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              AnimatedBuilder(
                animation: fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: fadeAnimation,
                    child: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        _showAboutDialog(context, l10n);
                      },
                    ),
                  );
                },
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: categoriesAsync.when(
              loading: () => _buildLoadingState(context, l10n, fadeAnimation),
              error: (error, stack) => _buildErrorState(
                context,
                error.toString(),
                ref,
                l10n,
                fadeAnimation,
              ),
              data: (categories) => _buildLoadedState(
                context,
                categories,
                l10n,
                fadeAnimation,
                slideAnimation,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
    AppLocalizations l10n,
    Animation<double> fadeAnimation,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const SizedBox(height: 60),
          FadeTransition(
            opacity: fadeAnimation,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const CircularProgressIndicator(),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.loadingServices,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 16,
                    fontWeight: .w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(
    BuildContext context,
    List categories,
    AppLocalizations l10n,
    Animation<double> fadeAnimation,
    Animation<Offset> slideAnimation,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer,
                      Colors.blue.shade100.withAlpha(76),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(13),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.sms,
                            color: colorScheme.surface,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                l10n.selectCategory,
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 20,
                                  fontWeight: .bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.selectCategoryDescription,
                                style: GoogleFonts.ibmPlexSans(
                                  fontSize: 14,
                                  fontWeight: .w400,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Categories List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 100)),
                    curve: Curves.easeInOut,
                    child: CategoryListItem(
                      category: category,
                      onTap: () {
                        context.router.push(ProviderListRoute(category: category));
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String errorMessage,
    WidgetRef ref,
    AppLocalizations l10n,
    Animation<double> fadeAnimation,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const SizedBox(height: 60),
          FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.error,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 20,
                      fontWeight: .bold,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage,
                    textAlign: .center,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 14,
                      fontWeight: .w400,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(CategoryListController.provider.notifier).refresh();
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfigUrlDialog(BuildContext context, WidgetRef ref) {
    final configService = ref.read(configServiceProvider);
    final controller = TextEditingController(text: configService.getConfigUrl());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Config URL',
          style: GoogleFonts.ibmPlexSans(
            fontSize: 18,
            fontWeight: .bold,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter config URL'),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.text = ConfigService.defaultConfigUrl;
            },
            child: Text(
              'Reset',
              style: GoogleFonts.ibmPlexSans(fontWeight: .w600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.ibmPlexSans(fontWeight: .w600),
            ),
          ),
          TextButton(
            onPressed: () async {
              await configService.setConfigUrl(controller.text.trim());
              if (context.mounted) Navigator.pop(context);
              ref.read(CategoryListController.provider.notifier).refresh();
            },
            child: Text(
              'Save',
              style: GoogleFonts.ibmPlexSans(fontWeight: .w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          l10n.about,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 18,
            fontWeight: .bold,
          ),
        ),
        content: Text(
          l10n.aboutDescription,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 14,
            fontWeight: .w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.ok,
              style: GoogleFonts.ibmPlexSans(fontWeight: .w600),
            ),
          ),
        ],
      ),
    );
  }
}
